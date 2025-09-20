<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>문의사항 - 올반푸드</title>
    <link rel="icon" type="image/x-icon" href="img/logo.png">
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="css/pages/inquiry.css">
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    
    <main>
        <div class="inquiry-container">
            
            <div class="inquiry-header">
                <h1>문의사항</h1>
                <p>궁금한 점이나 건의사항이 있으시면 언제든 연락주세요</p>
            </div>
            
            <form class="inquiry-form" action="inquiryProcess.jsp" method="post">
                <div class="inquiry-form-group">
                    <label for="inquiryType">문의 유형 <span class="required">*</span></label>
                    <select id="inquiryType" name="inquiryType" required>
                        <option value="">문의 유형을 선택하세요</option>
                        <option value="product">상품 문의</option>
                        <option value="order">주문/결제 문의</option>
                        <option value="delivery">배송 문의</option>
                        <option value="refund">환불/교환 문의</option>
                        <option value="technical">기술적 문제</option>
                        <option value="other">기타</option>
                    </select>
                </div>
                
                <div class="inquiry-form-group">
                    <label for="inquiryTitle">제목 <span class="required">*</span></label>
                    <input type="text" id="inquiryTitle" name="inquiryTitle" placeholder="문의 제목을 입력하세요" required>
                </div>
                
                <div class="inquiry-form-group">
                    <label for="inquiryContent">내용 <span class="required">*</span></label>
                    <textarea id="inquiryContent" name="inquiryContent" placeholder="문의 내용을 자세히 입력해주세요" required></textarea>
                </div>
                
                <div class="inquiry-form-group">
                    <label for="userName">이름 <span class="required">*</span></label>
                    <input type="text" id="userName" name="userName" placeholder="이름을 입력하세요" required>
                </div>
                
                <div class="inquiry-form-group">
                    <label for="userEmail">이메일 <span class="required">*</span></label>
                    <input type="email" id="userEmail" name="userEmail" placeholder="이메일을 입력하세요" required>
                </div>
                
                <div class="inquiry-form-group">
                    <label for="userPhone">전화번호</label>
                    <input type="tel" id="userPhone" name="userPhone" placeholder="전화번호를 입력하세요">
                </div>
                
                <button type="submit" class="submit-btn">문의하기</button>
            </form>
            
            <div class="contact-info">
                <h3>연락처 정보</h3>
                <div class="contact-grid">
                    <div class="contact-item">
                        <div class="contact-icon">📞</div>
                        <div class="contact-details">
                            <h4>고객센터</h4>
                            <p>1588-1234</p>
                        </div>
                    </div>
                    <div class="contact-item">
                        <div class="contact-icon">✉️</div>
                        <div class="contact-details">
                            <h4>이메일</h4>
                            <p>support@olbanfood.com</p>
                        </div>
                    </div>
                    <div class="contact-item">
                        <div class="contact-icon">🕒</div>
                        <div class="contact-details">
                            <h4>운영시간</h4>
                            <p>평일 09:00 - 18:00</p>
                        </div>
                    </div>
                    <div class="contact-item">
                        <div class="contact-icon">📍</div>
                        <div class="contact-details">
                            <h4>주소</h4>
                            <p>서울특별시 강남구 테헤란로 123</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="/common/footer.jsp" />
</body>
</html>
