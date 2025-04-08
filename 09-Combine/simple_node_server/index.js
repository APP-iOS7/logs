const http = require('http');
const url = require('url');

// 사용 불가능한 사용자 이름 목록
const unavailableUsernames = ['jmbae', 'johnnyappleseed', 'page', 'johndoe'];

const server = http.createServer((req, res) => {
  // URL 파싱
  const parsedUrl = url.parse(req.url, true);
  
  // 요청 경로가 /isUserNameAvailable인지 확인
  if (parsedUrl.pathname === '/isUserNameAvailable') {
    // 쿼리 파라미터 확인
    const queryParams = parsedUrl.query;
    
    // userName 파라미터가 있는지 확인
    if (queryParams.userName) {
      const username = queryParams.userName;
      
      // 요청 로깅
      console.log(`Checking availability for username: ${username}`);

      // 사용자 이름이 비어있거나 공백인 경우 처리
      if (!username || username.trim() === '') {
        res.writeHead(400, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Username 이 비었습니다.' }));
        return;
      }
      
      // 사용자 이름이 사용 불가능한 목록에 있는지 확인
      const isAvailable = !unavailableUsernames.includes(username);
      
      // JSON 응답 생성
      const response = {
        isAvailable: isAvailable,
        userName: username
      };
      
      // HTTP 응답 헤더 설정
      res.writeHead(200, { 'Content-Type': 'application/json' });
      
      // JSON 응답 전송
      res.end(JSON.stringify(response));
      return;
    }
  }
  
  // 요청 경로가 일치하지 않는 경우 404 반환
  res.writeHead(404);
  res.end('Not Found');
});

const PORT = 8080;

server.listen(PORT, '127.0.0.1', () => {
  console.log(`Starting username availability server at http://127.0.0.1:${PORT}`);
  console.log("Available endpoints:");
  console.log(`  GET http://127.0.0.1:${PORT}/isUserNameAvailable?userName=<username>`);
  console.log("\nUnavailable usernames for testing:");
  unavailableUsernames.forEach(name => {
    console.log(`  - ${name}`);
  });
  console.log("\n서버를 중지하려면 Ctrl+C를 누르세요.");
});