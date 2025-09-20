<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 - 올반푸드</title>
    <link rel="icon" type="image/x-icon" href="img/logo.png">
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="css/pages/join.css">
</head>
<body>
    <div class="join-container">
        <div class="join-card">
            <a href="index.jsp" class="home-btn">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M3 9L12 2L21 9V20C21 20.5304 20.7893 21.0391 20.4142 21.4142C20.0391 21.7893 19.5304 22 19 22H5C4.46957 22 3.96086 21.7893 3.58579 21.4142C3.21071 21.0391 3 20.5304 3 20V9Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M9 22V12H15V22" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                홈으로
            </a>
            <div class="join-header">
                <h1>회원가입</h1>
                <p>올반푸드 회원이 되어 프리미엄 육류를 만나보세요</p>
            </div>
            
            <form class="join-form" action="joinProcess.jsp" method="post">
                <div class="join-form-group full-width">
                    <label for="userId">아이디 <span class="required">*</span></label>
                    <input type="text" id="userId" name="userId" placeholder="아이디를 입력하세요" required>
                </div>
                
                <div class="form-row">
                    <div class="join-form-group">
                        <label for="userPw">비밀번호 <span class="required">*</span></label>
                        <input type="password" id="userPw" name="userPw" placeholder="비밀번호를 입력하세요" required>
                    </div>
                    <div class="join-form-group">
                        <label for="userPwConfirm">비밀번호 확인 <span class="required">*</span></label>
                        <input type="password" id="userPwConfirm" name="userPwConfirm" placeholder="비밀번호를 다시 입력하세요" required>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="join-form-group">
                        <label for="businessName">상호명 <span class="required">*</span></label>
                        <input type="text" id="businessName" name="businessName" placeholder="상호명을 입력하세요" required>
                    </div>
                    <div class="join-form-group">
                        <label for="representativeName">대표자명 <span class="required">*</span></label>
                        <input type="text" id="representativeName" name="representativeName" placeholder="대표자명을 입력하세요" required>
                    </div>
                </div>
                
                <div class="join-form-group full-width">
                    <label for="userEmail">이메일 <span class="required">*</span></label>
                    <input type="email" id="userEmail" name="userEmail" placeholder="이메일을 입력하세요" required>
                </div>
                
                <div class="form-row">
                    <div class="join-form-group">
                        <label for="userPhone">전화번호 <span class="required">*</span></label>
                        <input type="tel" id="userPhone" name="userPhone" placeholder="전화번호를 입력하세요" required>
                    </div>
                    <div class="join-form-group">
                        <label for="userBirth">생년월일</label>
                        <input type="date" id="userBirth" name="userBirth">
                    </div>
                </div>
                
                <div class="join-form-group full-width">
                    <label for="userAddress">주소</label>
                    <input type="text" id="userAddress" name="userAddress" placeholder="주소를 입력하세요">
                </div>
                
                <div class="join-form-group full-width">
                    <label for="userType">회원 유형</label>
                    <select id="userType" name="userType" class="form-select">
                        <option value="customer">일반 고객</option>
                        <option value="business">사업자</option>
                        <option value="admin">관리자</option>
                    </select>
                    <small class="form-text">관리자 권한은 별도 승인이 필요합니다.</small>
                </div>
                
                <button type="submit" class="join-btn">회원가입</button>
            </form>
            
            <div class="join-footer">
                이미 계정이 있으신가요? <a href="login.jsp">로그인하기</a>
            </div>
        </div>
    </div>
</body>
</html>
