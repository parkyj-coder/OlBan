<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<%
    // 관리자 권한 확인
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    if (isAdmin == null || !isAdmin) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    String noticeId = request.getParameter("id");
    
    if (noticeId != null && !noticeId.trim().isEmpty()) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "DELETE FROM notices WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, noticeId);
            
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                response.sendRedirect("noticeMng.jsp?deleted=1");
            } else {
                response.sendRedirect("noticeMng.jsp?error=1");
            }
        } catch (Exception e) {
            System.out.println("공지사항 삭제 실패: " + e.getMessage());
            response.sendRedirect("noticeMng.jsp?error=1");
        } finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) DBUtil.closeConnection(conn);
        }
    } else {
        response.sendRedirect("noticeMng.jsp?error=1");
    }
%>
