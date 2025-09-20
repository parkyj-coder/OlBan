<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<%
    // POST 요청만 처리
    if (!request.getMethod().equals("POST")) {
        out.print("error:Method not allowed");
        return;
    }
    
    String memberIdStr = request.getParameter("id");
    
    if (memberIdStr == null || memberIdStr.trim().isEmpty()) {
        out.print("error:회원 ID가 제공되지 않았습니다.");
        return;
    }
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        conn = DBUtil.getConnection();
        
        // 회원 삭제 쿼리
        String sql = "DELETE FROM members WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(memberIdStr));
        
        int result = pstmt.executeUpdate();
        
        if (result > 0) {
            out.print("success");
        } else {
            out.print("error:회원을 찾을 수 없습니다.");
        }
        
    } catch (SQLException e) {
        out.print("error:데이터베이스 오류가 발생했습니다.");
        e.printStackTrace();
    } catch (NumberFormatException e) {
        out.print("error:잘못된 회원 ID입니다.");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
        if (conn != null) try { conn.close(); } catch (SQLException e) { }
    }
%>
