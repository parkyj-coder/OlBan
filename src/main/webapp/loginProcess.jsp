<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page import="util.DBUtil" %>
<%
    // POST 요청만 처리
    if (!request.getMethod().equals("POST")) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // 한글 인코딩 설정
    request.setCharacterEncoding("UTF-8");
    
    // 폼 데이터 받기
    String userId = request.getParameter("userId");
    String userPw = request.getParameter("userPw");
    
    // 필수 필드 검증
    if (userId == null || userId.trim().isEmpty() ||
        userPw == null || userPw.trim().isEmpty()) {
        %>
        <script>
            alert("아이디와 비밀번호를 입력해주세요.");
            history.back();
        </script>
        <%
        return;
    }
    
    // 비밀번호 해시화 함수
    String hashPassword = "";
    try {
        java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(userPw.getBytes("UTF-8"));
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        hashPassword = hexString.toString();
    } catch (java.security.NoSuchAlgorithmException | java.io.UnsupportedEncodingException e) {
        hashPassword = userPw; // 해시화 실패시 원본 반환
    }
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        // 데이터베이스 연결
        conn = DBUtil.getConnection();
        
        // 사용자 인증 (실제 테이블 구조에 맞춤)
        String sql = "SELECT id, username, business_name, representative_name, email FROM members WHERE username = ? AND password = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);
        pstmt.setString(2, hashPassword);
        
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            // 로그인 성공
            // 세션에 사용자 정보 저장
            session.setAttribute("userId", rs.getString("username"));
            session.setAttribute("userName", rs.getString("business_name"));
            session.setAttribute("userEmail", rs.getString("email"));
            session.setAttribute("memberId", rs.getInt("id"));
            
            // is_admin 필드가 있는지 확인하고 설정
            try {
                String adminCheckSql = "SELECT is_admin FROM members WHERE username = ?";
                PreparedStatement adminPstmt = conn.prepareStatement(adminCheckSql);
                adminPstmt.setString(1, userId);
                ResultSet adminRs = adminPstmt.executeQuery();
                
                if (adminRs.next()) {
                    session.setAttribute("isAdmin", adminRs.getBoolean("is_admin"));
                } else {
                    session.setAttribute("isAdmin", false);
                }
                
                adminRs.close();
                adminPstmt.close();
            } catch (SQLException e) {
                // is_admin 필드가 없는 경우
                session.setAttribute("isAdmin", false);
            }
            
            // 로그인 성공 후 메인 페이지로 이동
            response.sendRedirect("index.jsp");
            return;
        } else {
            // 로그인 실패
            %>
            <script>
                alert("아이디 또는 비밀번호가 올바르지 않습니다.");
                history.back();
            </script>
            <%
        }
        
    } catch (SQLException e) {
        // 데이터베이스 오류
        %>
        <script>
            alert("데이터베이스 오류가 발생했습니다: <%= e.getMessage() %>");
            history.back();
        </script>
        <%
        e.printStackTrace();
    } catch (Exception e) {
        // 기타 오류
        %>
        <script>
            alert("오류가 발생했습니다: <%= e.getMessage() %>");
            history.back();
        </script>
        <%
        e.printStackTrace();
    } finally {
        // 리소스 해제
        if (rs != null) {
            try { rs.close(); } catch (SQLException e) { }
        }
        if (pstmt != null) {
            try { pstmt.close(); } catch (SQLException e) { }
        }
        if (conn != null) {
            DBUtil.closeConnection(conn);
        }
    }
%> 