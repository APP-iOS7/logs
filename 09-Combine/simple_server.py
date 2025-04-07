from http.server import BaseHTTPRequestHandler, HTTPServer
import json
from urllib.parse import urlparse, parse_qs

# 사용 불가능한 사용자 이름 목록
unavailable_usernames = ['jmbae', 'johnnyappleseed', 'page', 'johndoe']

class UserNameHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        # URL 파싱
        parsed_url = urlparse(self.path)
        
        # 요청 경로가 /isUserNameAvailable인지 확인
        if parsed_url.path == '/isUserNameAvailable':
            # 쿼리 파라미터 파싱
            query_params = parse_qs(parsed_url.query)
            
            # userName 파라미터가 있는지 확인
            if 'userName' in query_params:
                username = query_params['userName'][0]
                
                # 요청 로깅
                print(f"Checking availability for username: {username}")
                
                # 사용자 이름이 사용 불가능한 목록에 있는지 확인
                is_available = username not in unavailable_usernames
                
                # JSON 응답 생성
                response = {
                    "isAvailable": is_available,
                    "userName": username
                }
                
                # HTTP 응답 헤더 설정
                self.send_response(200)
                self.send_header('Content-Type', 'application/json')
                self.end_headers()
                
                # JSON 응답 전송
                self.wfile.write(json.dumps(response).encode())
                return
        
        # 요청 경로가 일치하지 않는 경우 404 반환
        self.send_response(404)
        self.end_headers()
        self.wfile.write(b'Not Found')

def run_server(port=8080):
    server_address = ('127.0.0.1', port)
    httpd = HTTPServer(server_address, UserNameHandler)
    print(f"Starting username availability server at http://127.0.0.1:{port}")
    print("Available endpoints:")
    print(f"  GET http://127.0.0.1:{port}/isUserNameAvailable?userName=<username>")
    print("\nUnavailable usernames for testing:")
    for name in unavailable_usernames:
        print(f"  - {name}")
    print("\n서버를 중지하려면 Ctrl+C를 누르세요.")
    
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n서버가 종료됩니다.")
        httpd.server_close()

if __name__ == '__main__':
    run_server()