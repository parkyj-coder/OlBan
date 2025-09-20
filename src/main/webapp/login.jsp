<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 - 올반푸드</title>
    <link rel="icon" type="image/x-icon" href="img/logo.png">
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="css/pages/login.css">
</head>
<body>
    <div class="login-container">
        <div class="login-card">
            <a href="index.jsp" class="home-btn">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M3 9L12 2L21 9V20C21 20.5304 20.7893 21.0391 20.4142 21.4142C20.0391 21.7893 19.5304 22 19 22H5C4.46957 22 3.96086 21.7893 3.58579 21.4142C3.21071 21.0391 3 20.5304 3 20V9Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M9 22V12H15V22" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                홈으로
            </a>
            <div class="login-header">
                <h1>로그인</h1>
                <p>올반푸드에 오신 것을 환영합니다</p>
            </div>
            
            <form class="login-form" action="loginProcess.jsp" method="post">
                <div class="login-form-group">
                    <label for="userId">아이디</label>
                    <input type="text" id="userId" name="userId" placeholder="아이디를 입력하세요" required>
                </div>
                <div class="login-form-group">
                    <label for="userPw">비밀번호</label>
                    <input type="password" id="userPw" name="userPw" placeholder="비밀번호를 입력하세요" required>
                </div>
                <button type="submit" class="login-btn">로그인</button>
            </form>
            
            <div class="login-footer">
                <a href="join.jsp">회원가입</a> | 
                <a href="findId.jsp">아이디 찾기</a> | 
                <a href="findPw.jsp">비밀번호 찾기</a>
            </div>
        </div>
    </div>
</body>
</html>
