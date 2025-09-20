<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
// subcategories 테이블 대신 하드코딩된 하위분류 옵션 제공
String categoryId = request.getParameter("category_id");

if (categoryId != null && !categoryId.trim().isEmpty()) {
    int catId = Integer.parseInt(categoryId);
    
    if (catId == 1) { // 국산
        %>
        <option value="1">돼지고기</option>
        <option value="2">소고기</option>
        <%
    } else if (catId == 2) { // 수입
        %>
        <option value="1">돼지고기</option>
        <option value="2">소고기</option>
        <%
    }
} else {
    // 모든 하위분류 표시
    %>
    <option value="1">돼지고기</option>
    <option value="2">소고기</option>
    <%
}
%>