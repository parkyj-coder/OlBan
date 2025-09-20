<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<jsp:include page="../common/adminCheck.jsp" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주문 테이블 수정 - 올반푸드</title>
    <link rel="icon" type="image/x-icon" href="../img/logo.png">
    <link rel="stylesheet" href="../css/main.css">
    <link rel="stylesheet" href="css/admin.css">
    <style>
        .fix-section { background: #f8f9fa; padding: 20px; margin: 15px 0; border-radius: 8px; }
        .success { color: #28a745; font-weight: bold; }
        .error { color: #dc3545; font-weight: bold; }
        .info { color: #17a2b8; font-weight: bold; }
        .sql-output { background: #f8f9fa; padding: 10px; border: 1px solid #dee2e6; border-radius: 4px; margin: 10px 0; font-family: monospace; }
        button { padding: 10px 20px; margin: 5px; background: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; }
        button:hover { background: #0056b3; }
        button.danger { background: #dc3545; }
        button.danger:hover { background: #c82333; }
    </style>
</head>
<body>
    <div class="admin-container">
        <header class="admin-header">
            <div class="admin-header-content">
                <div class="admin-logo">
                    <img src="../img/logo.png" alt="올반푸드 로고" class="logo">
                    <span class="logo-text">OLBANFOOD 관리자</span>
                </div>
                <nav class="admin-nav">
                    <a href="adminMain.jsp" class="nav-link">대시보드</a>
                    <a href="orderMng.jsp" class="nav-link">주문관리</a>
                    <a href="../index.jsp" class="nav-link">사이트로</a>
                </nav>
            </div>
        </header>

        <main class="admin-main">
            <div class="page-header">
                <h1>주문 테이블 구조 수정</h1>
                <p>orders 테이블의 누락된 컬럼들을 추가합니다.</p>
            </div>

            <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                conn = DBUtil.getConnection();
                %>
                
                <div class="fix-section">
                    <h3>1. 현재 orders 테이블 구조 확인</h3>
                    <%
                    try {
                        String describeSql = "DESCRIBE orders";
                        pstmt = conn.prepareStatement(describeSql);
                        rs = pstmt.executeQuery();
                        
                        out.println("<div class='sql-output'>");
                        out.println("<strong>현재 orders 테이블 구조:</strong><br>");
                        while (rs.next()) {
                            String field = rs.getString("Field");
                            String type = rs.getString("Type");
                            String null_ = rs.getString("Null");
                            String key = rs.getString("Key");
                            String default_ = rs.getString("Default");
                            out.println("• " + field + " | " + type + " | " + null_ + " | " + key + " | " + default_ + "<br>");
                        }
                        out.println("</div>");
                    } catch (SQLException e) {
                        out.println("<div class='error'>orders 테이블 구조 확인 실패: " + e.getMessage() + "</div>");
                    }
                    %>
                </div>

                <%
                // 누락된 컬럼 추가 요청 처리
                String action = request.getParameter("action");
                if ("add_missing_columns".equals(action)) {
                    %>
                    <div class="fix-section">
                        <h3>2. 누락된 컬럼 추가 중...</h3>
                        <%
                        // shipping_phone 컬럼 추가
                        try {
                            String addPhoneSql = "ALTER TABLE orders ADD COLUMN shipping_phone VARCHAR(20) AFTER shipping_address";
                            pstmt = conn.prepareStatement(addPhoneSql);
                            pstmt.executeUpdate();
                            out.println("<div class='success'>✅ shipping_phone 컬럼이 추가되었습니다.</div>");
                        } catch (SQLException e) {
                            if (e.getMessage().contains("Duplicate column name")) {
                                out.println("<div class='info'>ℹ️ shipping_phone 컬럼이 이미 존재합니다.</div>");
                            } else {
                                out.println("<div class='error'>❌ shipping_phone 컬럼 추가 실패: " + e.getMessage() + "</div>");
                            }
                        }
                        
                        // shipping_name 컬럼 추가
                        try {
                            String addNameSql = "ALTER TABLE orders ADD COLUMN shipping_name VARCHAR(100) AFTER shipping_phone";
                            pstmt = conn.prepareStatement(addNameSql);
                            pstmt.executeUpdate();
                            out.println("<div class='success'>✅ shipping_name 컬럼이 추가되었습니다.</div>");
                        } catch (SQLException e) {
                            if (e.getMessage().contains("Duplicate column name")) {
                                out.println("<div class='info'>ℹ️ shipping_name 컬럼이 이미 존재합니다.</div>");
                            } else {
                                out.println("<div class='error'>❌ shipping_name 컬럼 추가 실패: " + e.getMessage() + "</div>");
                            }
                        }
                        
                        // updated_at 컬럼 추가
                        try {
                            String addUpdatedAtSql = "ALTER TABLE orders ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER created_at";
                            pstmt = conn.prepareStatement(addUpdatedAtSql);
                            pstmt.executeUpdate();
                            out.println("<div class='success'>✅ updated_at 컬럼이 추가되었습니다.</div>");
                        } catch (SQLException e) {
                            if (e.getMessage().contains("Duplicate column name")) {
                                out.println("<div class='info'>ℹ️ updated_at 컬럼이 이미 존재합니다.</div>");
                            } else {
                                out.println("<div class='error'>❌ updated_at 컬럼 추가 실패: " + e.getMessage() + "</div>");
                            }
                        }
                        %>
                    </div>
                    <%
                }
                
                if ("create_sample_orders".equals(action)) {
                    %>
                    <div class="fix-section">
                        <h3>3. 샘플 주문 데이터 생성 중...</h3>
                        <%
                        try {
                            // 먼저 members 테이블에서 첫 번째 회원 가져오기
                            String memberSql = "SELECT id FROM members LIMIT 1";
                            pstmt = conn.prepareStatement(memberSql);
                            rs = pstmt.executeQuery();
                            
                            if (rs.next()) {
                                int memberId = rs.getInt("id");
                                
                                // 샘플 주문 생성
                                String insertOrderSql = "INSERT INTO orders (order_number, member_id, total_amount, status, shipping_address, shipping_phone, shipping_name) VALUES (?, ?, ?, ?, ?, ?, ?)";
                                pstmt = conn.prepareStatement(insertOrderSql);
                                
                                // 주문 1
                                pstmt.setString(1, "ORD-2024-001");
                                pstmt.setInt(2, memberId);
                                pstmt.setInt(3, 45000);
                                pstmt.setString(4, "completed");
                                pstmt.setString(5, "서울시 강남구 테헤란로 123");
                                pstmt.setString(6, "010-1234-5678");
                                pstmt.setString(7, "홍길동");
                                pstmt.executeUpdate();
                                
                                // 주문 2
                                pstmt.setString(1, "ORD-2024-002");
                                pstmt.setInt(2, memberId);
                                pstmt.setInt(3, 32000);
                                pstmt.setString(4, "processing");
                                pstmt.setString(5, "서울시 서초구 서초대로 456");
                                pstmt.setString(6, "010-9876-5432");
                                pstmt.setString(7, "김철수");
                                pstmt.executeUpdate();
                                
                                out.println("<div class='success'>✅ 샘플 주문 데이터가 성공적으로 생성되었습니다!</div>");
                            } else {
                                out.println("<div class='error'>❌ 회원 데이터가 없어 샘플 주문을 생성할 수 없습니다.</div>");
                            }
                        } catch (SQLException e) {
                            out.println("<div class='error'>❌ 샘플 주문 데이터 생성 실패: " + e.getMessage() + "</div>");
                        }
                        %>
                    </div>
                    <%
                }
                %>

                <div class="fix-section">
                    <h3>4. 누락된 컬럼 추가</h3>
                    <p>orders 테이블에 누락된 컬럼들을 추가합니다:</p>
                    <ul>
                        <li><strong>shipping_phone</strong> - 배송 연락처 (VARCHAR(20))</li>
                        <li><strong>shipping_name</strong> - 배송 받는 사람 (VARCHAR(100))</li>
                        <li><strong>updated_at</strong> - 수정 시간 (TIMESTAMP)</li>
                    </ul>
                    <form method="post">
                        <input type="hidden" name="action" value="add_missing_columns">
                        <button type="submit" class="danger">누락된 컬럼 추가</button>
                    </form>
                </div>

                <div class="fix-section">
                    <h3>5. 샘플 주문 데이터 생성</h3>
                    <p>컬럼 추가가 완료되면 샘플 주문 데이터를 생성할 수 있습니다.</p>
                    <form method="post">
                        <input type="hidden" name="action" value="create_sample_orders">
                        <button type="submit">샘플 주문 데이터 생성</button>
                    </form>
                </div>

                <div class="fix-section">
                    <h3>6. 다음 단계</h3>
                    <p>모든 수정이 완료되면 <a href="orderMng.jsp">주문관리 페이지</a>로 이동하여 주문 정보를 확인할 수 있습니다.</p>
                </div>

                <%
            } catch (SQLException e) {
                out.println("<div class='error'>데이터베이스 연결 실패: " + e.getMessage() + "</div>");
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { }
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
                if (conn != null) try { conn.close(); } catch (SQLException e) { }
            }
            %>
        </main>
    </div>
</body>
</html> 