<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="util.DBUtil" %>

<%
// POST 요청만 처리
if (!request.getMethod().equals("POST")) {
    response.sendRedirect("join.jsp");
    return;
}

// 한글 인코딩 설정
request.setCharacterEncoding("UTF-8");

// 폼 데이터 받기
String userId = request.getParameter("userId");
String userPw = request.getParameter("userPw");
String userPwConfirm = request.getParameter("userPwConfirm");
String businessName = request.getParameter("businessName");
String representativeName = request.getParameter("representativeName");
String userEmail = request.getParameter("userEmail");
String userPhone = request.getParameter("userPhone");
String userAddress = request.getParameter("userAddress");
String userType = request.getParameter("userType");

// 회원 유형에 따른 관리자 권한 설정
boolean isAdmin = false;
if (userType != null && userType.equals("admin")) {
    isAdmin = true;
}

// 필수 필드 검증
if (userId == null || userId.trim().isEmpty() ||
    userPw == null || userPw.trim().isEmpty() ||
    businessName == null || businessName.trim().isEmpty() ||
    representativeName == null || representativeName.trim().isEmpty() ||
    userEmail == null || userEmail.trim().isEmpty() ||
    userPhone == null || userPhone.trim().isEmpty()) {
    %>
    <script>
        alert("필수 항목을 모두 입력해주세요.");
        history.back();
    </script>
    <%
    return;
}

// 비밀번호 확인
if (!userPw.equals(userPwConfirm)) {
    %>
    <script>
        alert("비밀번호가 일치하지 않습니다.");
        history.back();
    </script>
    <%
    return;
}

// 비밀번호 해시화
String hashedPassword = "";
try {
    MessageDigest md = MessageDigest.getInstance("SHA-256");
    byte[] hash = md.digest(userPw.getBytes("UTF-8"));
    StringBuilder hexString = new StringBuilder();
    for (byte b : hash) {
        String hex = Integer.toHexString(0xff & b);
        if (hex.length() == 1) hexString.append('0');
        hexString.append(hex);
    }
    hashedPassword = hexString.toString();
} catch (Exception e) {
    hashedPassword = userPw; // 해시화 실패시 원본 사용
}

Connection conn = null;
PreparedStatement pstmt = null;
boolean success = false;
String errorMessage = "";

try {
    // 데이터베이스 연결
    conn = DBUtil.getConnection();
    
    // 아이디 중복 확인
    String checkSql = "SELECT COUNT(*) FROM members WHERE username = ?";
    pstmt = conn.prepareStatement(checkSql);
    pstmt.setString(1, userId);
    ResultSet rs = pstmt.executeQuery();
    
    if (rs.next() && rs.getInt(1) > 0) {
        errorMessage = "이미 사용 중인 아이디입니다.";
    } else {
        rs.close();
        pstmt.close();
        
        // 이메일 중복 확인
        checkSql = "SELECT COUNT(*) FROM members WHERE email = ?";
        pstmt = conn.prepareStatement(checkSql);
        pstmt.setString(1, userEmail);
        rs = pstmt.executeQuery();
        
        if (rs.next() && rs.getInt(1) > 0) {
            errorMessage = "이미 사용 중인 이메일입니다.";
        } else {
            rs.close();
            pstmt.close();
            
            // 회원 정보 삽입
            String insertSql = "INSERT INTO members (username, password, business_name, representative_name, email, phone, address) VALUES (?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(insertSql);
            pstmt.setString(1, userId);
            pstmt.setString(2, hashedPassword);
            pstmt.setString(3, businessName);
            pstmt.setString(4, representativeName);
            pstmt.setString(5, userEmail);
            pstmt.setString(6, userPhone);
            pstmt.setString(7, userAddress);
            
            int result = pstmt.executeUpdate();
            if (result > 0) {
                success = true;
            } else {
                errorMessage = "회원가입 중 오류가 발생했습니다.";
            }
        }
    }
    
} catch (SQLException e) {
    errorMessage = "데이터베이스 오류: " + e.getMessage();
} catch (Exception e) {
    errorMessage = "오류가 발생했습니다: " + e.getMessage();
} finally {
    if (pstmt != null) {
        try { pstmt.close(); } catch (SQLException e) { }
    }
    if (conn != null) {
        DBUtil.closeConnection(conn);
    }
}

// 결과 처리
if (success) {
    String message = "회원가입이 완료되었습니다!";
    if (isAdmin) {
        message += "\\n관리자 권한은 별도 승인이 필요합니다.";
    }
    %>
    <script>
        alert("<%= message %>");
        location.href = "login.jsp";
    </script>
    <%
} else {
    %>
    <script>
        alert("<%= errorMessage %>");
        history.back();
    </script>
    <%
}
%> 