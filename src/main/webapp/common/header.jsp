<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 로그인 상태 확인
    String userId = (String) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    
    // isAdmin이 null인 경우 false로 설정
    if (isAdmin == null) {
        isAdmin = false;
    }
%>
<header>
    <div class="logo-nav">
        <!-- 햄버거 메뉴 버튼 -->
        <div class="hamburger-menu" onclick="toggleMenu()">
            <span></span>
            <span></span>
            <span></span>
        </div>
        
        <div class="logo-container">
            <a href="index.jsp" class="logo-link">
                <img src="img/logo.png" alt="올반푸드 로고" class="logo">
                <span class="logo-text">OLBANFOOD</span>
            </a>
        </div>
        
        <nav class="nav-menu">
            <ul>
                <li><a href="index.jsp">홈</a></li>
                <li><a href="company.jsp">회사소개</a></li>
                <li><a href="products.jsp">상품리스트</a></li>
                <li><a href="cart.jsp">장바구니</a></li>
                <li><a href="inquiry.jsp">문의사항</a></li>
                <%
                // 관리자인 경우에만 관리자 메뉴 표시
                if (isAdmin) {
                    %>
                    <li><a href="admin/adminMain.jsp">관리자</a></li>
                    <%
                }
                %>
                <%
                if (userId != null) {
                    // 로그인된 상태
                    %>
                    <li><a href="#" style="color: #007bff; font-weight: bold;"><%= userName %>님</a></li>
                    <li><a href="logout.jsp">로그아웃</a></li>
                    <%
                } else {
                    // 로그인되지 않은 상태
                    %>
                    <li><a href="login.jsp">로그인</a></li>
                    <li><a href="join.jsp">회원가입</a></li>
                    <%
                }
                %>
            </ul>
        </nav>
        
        <!-- 장바구니 아이콘 -->
        <div class="cart-icon-container">
            <a href="cart.jsp" class="cart-icon-link">
                <div class="cart-icon">
                    <span class="cart-icon-fallback">🛒</span>
                </div>
                <span class="cart-count" id="cartCount">0</span>
            </a>
        </div>
    </div>
</header>

<script>
function toggleMenu() {
    const navMenu = document.querySelector('.nav-menu');
    const hamburger = document.querySelector('.hamburger-menu');
    
    navMenu.classList.toggle('active');
    hamburger.classList.toggle('active');
}

// 메뉴 항목 클릭 시 메뉴 닫기
document.addEventListener('DOMContentLoaded', function() {
    const menuItems = document.querySelectorAll('.nav-menu a');
    menuItems.forEach(item => {
        item.addEventListener('click', function() {
            const navMenu = document.querySelector('.nav-menu');
            const hamburger = document.querySelector('.hamburger-menu');
            navMenu.classList.remove('active');
            hamburger.classList.remove('active');
        });
    });
    
    // 장바구니 카운트 업데이트
    updateCartCount();
    
    // localStorage 변경 감지
    window.addEventListener('storage', function(e) {
        if (e.key === 'cart') {
            updateCartCount();
        }
    });
});

// 장바구니 카운트 업데이트 함수
function updateCartCount() {
    const cartData = JSON.parse(localStorage.getItem('cart') || '[]');
    const cartCount = document.getElementById('cartCount');
    
    if (cartCount) {
        const totalItems = cartData.reduce((total, item) => total + item.quantity, 0);
        cartCount.textContent = totalItems;
        
        // 상품이 있으면 카운트 표시, 없으면 숨김
        if (totalItems > 0) {
            cartCount.style.display = 'block';
        } else {
            cartCount.style.display = 'none';
        }
    }
}

// 전역 함수로 등록 (다른 페이지에서도 호출 가능)
window.updateCartCount = updateCartCount;
</script> 