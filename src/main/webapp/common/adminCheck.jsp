<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 로그인 상태 확인
    String userId = (String) session.getAttribute("userId");
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    
    // 로그인되지 않았거나 관리자가 아닌 경우
    if (userId == null || isAdmin == null || !isAdmin) {
        %>
        <script>
            alert("관리자 권한이 필요합니다.");
            location.href = "../login.jsp";
        </script>
        <%
        return;
    }
%> 