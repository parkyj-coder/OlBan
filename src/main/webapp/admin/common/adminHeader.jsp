<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 현재 페이지 URL을 가져와서 active 상태를 설정
    String currentPage = request.getRequestURI();
    String activePage = "";
    
    if (currentPage.contains("adminMain.jsp")) {
        activePage = "dashboard";
    } else if (currentPage.contains("memberMng.jsp")) {
        activePage = "member";
    } else if (currentPage.contains("productMng.jsp")) {
        activePage = "product";
    } else if (currentPage.contains("orderMng.jsp")) {
        activePage = "order";
    } else if (currentPage.contains("noticeMng.jsp") || currentPage.contains("addNotice.jsp")) {
        activePage = "notice";
    } else if (currentPage.contains("inquiryMng.jsp")) {
        activePage = "inquiry";
    }
%>
<!-- 관리자 헤더 -->
<header class="admin-header">
    <div class="admin-header-content">
        <!-- 햄버거 메뉴 버튼 -->
        <div class="admin-hamburger-menu" id="adminHamburgerMenu">
            <span></span>
            <span></span>
            <span></span>
        </div>
        
        <div class="admin-logo">
            <img src="<%= request.getContextPath() %>/img/logo.png" alt="올반푸드 로고" class="logo">
            <span class="logo-text">OLBANFOOD</span>
        </div>
        <nav class="admin-nav" id="adminNav">
            <a href="adminMain.jsp" class="nav-link <%= "dashboard".equals(activePage) ? "active" : "" %>">대시보드</a>
            <a href="memberMng.jsp" class="nav-link <%= "member".equals(activePage) ? "active" : "" %>">회원관리</a>
            <a href="productMng.jsp" class="nav-link <%= "product".equals(activePage) ? "active" : "" %>">상품관리</a>
            <a href="orderMng.jsp" class="nav-link <%= "order".equals(activePage) ? "active" : "" %>">주문관리</a>
            <a href="noticeMng.jsp" class="nav-link <%= "notice".equals(activePage) ? "active" : "" %>">공지사항</a>
            <a href="inquiryMng.jsp" class="nav-link <%= "inquiry".equals(activePage) ? "active" : "" %>">문의사항</a>
            <a href="<%= request.getContextPath() %>/index.jsp" class="nav-link">사이트로</a>
            <a href="<%= request.getContextPath() %>/logout.jsp" class="nav-link logout">로그아웃</a>
        </nav>
    </div>
</header>

<script>
// 햄버거 메뉴 토글 기능
document.addEventListener('DOMContentLoaded', function() {
    const hamburgerMenu = document.getElementById('adminHamburgerMenu');
    const adminNav = document.getElementById('adminNav');
    
    hamburgerMenu.addEventListener('click', function() {
        hamburgerMenu.classList.toggle('active');
        adminNav.classList.toggle('active');
    });
    
    // 메뉴 항목 클릭 시 모바일 메뉴 닫기
    const navLinks = adminNav.querySelectorAll('.nav-link');
    navLinks.forEach(link => {
        link.addEventListener('click', function() {
            hamburgerMenu.classList.remove('active');
            adminNav.classList.remove('active');
        });
    });
    
    // 화면 크기 변경 시 모바일 메뉴 상태 초기화
    window.addEventListener('resize', function() {
        if (window.innerWidth > 1024) {
            hamburgerMenu.classList.remove('active');
            adminNav.classList.remove('active');
        }
    });
    
    // 오버레이 클릭 시 메뉴 닫기
    document.addEventListener('click', function(e) {
        // 메뉴가 열려있고, 햄버거 메뉴나 네비게이션 내부가 아닌 곳을 클릭했을 때
        if (adminNav.classList.contains('active') && 
            !hamburgerMenu.contains(e.target) && 
            !adminNav.contains(e.target)) {
            hamburgerMenu.classList.remove('active');
            adminNav.classList.remove('active');
        }
    });
});
</script>
