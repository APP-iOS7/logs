require 'socket'
require 'json'
require 'uri'

# 사용 불가능한 사용자 이름 목록
UNAVAILABLE_USERNAMES = ['jmbae', 'johnnyappleseed', 'page', 'johndoe']

# HTTP 응답 헬퍼 메서드
def http_response(code, content_type, body)
  "HTTP/1.1 #{code}\r\n" +
  "Content-Type: #{content_type}\r\n" +
  "Content-Length: #{body.bytesize}\r\n" +
  "Connection: close\r\n" +
  "\r\n" +
  body
end

# 쿼리 파라미터 파싱 헬퍼 메서드
def parse_query_params(query_string)
  params = {}
  return params if query_string.nil? || query_string.empty?
  
  query_string.split('&').each do |param|
    key, value = param.split('=', 2)
    params[URI.decode_www_form_component(key)] = URI.decode_www_form_component(value || '')
  end
  
  params
end

# 서버 실행 함수
def run_server(port=8080)
  # 서버 소켓 생성
  server = TCPServer.new('127.0.0.1', port)
  
  # 시작 메시지 출력
  puts "Starting username availability server at http://127.0.0.1:#{port}"
  puts "Available endpoints:"
  puts "  GET http://127.0.0.1:#{port}/isUserNameAvailable?userName=<username>"
  puts "\nUnavailable usernames for testing:"
  UNAVAILABLE_USERNAMES.each do |name|
    puts "  - #{name}"
  end
  puts "\n서버를 중지하려면 Ctrl+C를 누르세요."
  
  # 인터럽트 시그널(Ctrl+C) 처리
  running = true
  trap('INT') do
    if running
      running = false
      puts "\n서버가 종료됩니다."
      server.close rescue nil
      exit
    else
      # 두 번째 Ctrl+C가 눌릴 경우 강제 종료
      puts "\n강제 종료합니다."
      exit!
    end
  end
  
  # 클라이언트 요청 처리 루프
  loop do
    # 클라이언트 연결 수락
    client = nil
    
    begin
      # 클라이언트 연결 수락 - 타임아웃 설정
      client = server.accept_nonblock
    rescue IO::WaitReadable, Errno::EINTR
      # 논블로킹 모드에서 소켓이 준비되지 않았을 때 발생하는 예외 처리
      IO.select([server])
      retry
    end
    
    # 각 클라이언트 요청을 별도 스레드에서 처리
    Thread.new(client) do |c|
      begin
        # 시간 초과 설정
        c.setsockopt(Socket::SOL_SOCKET, Socket::SO_RCVTIMEO, [5, 0].pack('l_*'))
        c.setsockopt(Socket::SOL_SOCKET, Socket::SO_SNDTIMEO, [5, 0].pack('l_*'))
        
        # 요청 데이터 읽기
        request_line = c.gets
        
        # nil 체크 - 빈 요청인 경우
        if request_line.nil? || request_line.strip.empty?
          c.close
          next
        end
        
        # 요청 정보 파싱
        parts = request_line.split
        
        # 유효한 HTTP 요청인지 확인
        if parts.length < 2
          c.close
          next
        end
        
        method, path_with_query = parts[0], parts[1]
        
        # 경로와 쿼리 문자열 분리
        if path_with_query.include?('?')
          path, query_string = path_with_query.split('?', 2)
        else
          path = path_with_query
          query_string = ''
        end
        
        # 요청 헤더 건너뛰기
        while line = c.gets
          break if line.strip.empty?
        end
        
        # 요청 처리
        if path == '/isUserNameAvailable' && method == 'GET'
          params = parse_query_params(query_string)
          
          if params.has_key?('userName')
            username = params['userName']
            
            # 요청 로깅
            puts "Checking availability for username: #{username}"
            
            # 사용자 이름이 사용 불가능한 목록에 있는지 확인
            is_available = !UNAVAILABLE_USERNAMES.include?(username)
            
            # JSON 응답 생성
            result = {
              isAvailable: is_available,
              userName: username
            }
            
            # JSON 응답 전송
            response = http_response(
              '200 OK',
              'application/json',
              JSON.generate(result)
            )
            c.write(response)
          else
            # userName 파라미터가 없는 경우
            response = http_response(
              '400 Bad Request',
              'text/plain',
              'Bad Request: userName parameter is required'
            )
            c.write(response)
          end
        else
          # 요청 경로가 일치하지 않는 경우
          response = http_response(
            '404 Not Found',
            'text/plain',
            'Not Found'
          )
          c.write(response)
        end
      rescue => e
        puts "Error handling request: #{e.message}"
      ensure
        # 항상 클라이언트 연결을 닫음
        c.close rescue nil
      end
    end
  end
end

# 메인 실행
if __FILE__ == $0
  run_server
end