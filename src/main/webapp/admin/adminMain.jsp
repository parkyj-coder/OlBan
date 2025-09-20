<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<jsp:include page="../common/adminCheck.jsp" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 대시보드 - 올반푸드</title>
    <link rel="icon" type="image/x-icon" href="../img/logo.png">
    <link rel="stylesheet" href="../css/main.css">
    <link rel="stylesheet" href="css/admin.css">
</head>
<body>
    <div class="admin-container">
        <!-- 관리자 헤더 -->
        <jsp:include page="common/adminHeader.jsp" />

        <main class="admin-main">
            <div class="dashboard-container">
                <h1>관리자 대시보드</h1>
                
                <!-- 통계 카드들 -->
                <div class="stats-grid">
                    <%
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    
                    try {
                        conn = DBUtil.getConnection();
                        
                        // 회원 수 조회
                        String memberSql = "SELECT COUNT(*) as count FROM members";
                        pstmt = conn.prepareStatement(memberSql);
                        rs = pstmt.executeQuery();
                        int memberCount = 0;
                        if (rs.next()) {
                            memberCount = rs.getInt("count");
                        }
                        rs.close();
                        pstmt.close();
                        
                        // 상품 수 조회
                        String productSql = "SELECT COUNT(*) as count FROM products WHERE is_active = 1";
                        pstmt = conn.prepareStatement(productSql);
                        rs = pstmt.executeQuery();
                        int productCount = 0;
                        if (rs.next()) {
                            productCount = rs.getInt("count");
                        }
                        rs.close();
                        pstmt.close();
                        
                        // 주문 수 조회
                        String orderSql = "SELECT COUNT(*) as count FROM orders";
                        pstmt = conn.prepareStatement(orderSql);
                        rs = pstmt.executeQuery();
                        int orderCount = 0;
                        if (rs.next()) {
                            orderCount = rs.getInt("count");
                        }
                        rs.close();
                        pstmt.close();
                        
                        // 문의사항 수 조회
                        String inquirySql = "SELECT COUNT(*) as count FROM inquiries WHERE status = 'pending'";
                        pstmt = conn.prepareStatement(inquirySql);
                        rs = pstmt.executeQuery();
                        int inquiryCount = 0;
                        if (rs.next()) {
                            inquiryCount = rs.getInt("count");
                        }
                        rs.close();
                        pstmt.close();
                        %>
                        
                        <div class="stat-card">
                            <div class="stat-icon">👥</div>
                            <div class="stat-content">
                                <h3>총 회원 수</h3>
                                <p class="stat-number"><%= memberCount %>명</p>
                            </div>
                        </div>
                        
                        <div class="stat-card">
                            <div class="stat-icon">📦</div>
                            <div class="stat-content">
                                <h3>등록 상품 수</h3>
                                <p class="stat-number"><%= productCount %>개</p>
                            </div>
                        </div>
                        
                        <div class="stat-card">
                            <div class="stat-icon">🛒</div>
                            <div class="stat-content">
                                <h3>총 주문 수</h3>
                                <p class="stat-number"><%= orderCount %>건</p>
                            </div>
                        </div>
                        
                        <div class="stat-card">
                            <div class="stat-icon">❓</div>
                            <div class="stat-content">
                                <h3>답변 대기 문의</h3>
                                <p class="stat-number"><%= inquiryCount %>건</p>
                            </div>
                        </div>
                        
                        <%
                    } catch (SQLException e) {
                        %>
                        <div class="error-message">
                            <p>통계 정보를 불러오는 중 오류가 발생했습니다.</p>
                        </div>
                        <%
                        e.printStackTrace();
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { }
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { }
                    }
                    %>
                </div>
                
                <!-- 최근 활동 -->
                <div class="recent-activities">
                    <h2>최근 활동</h2>
                    <div class="activity-list">
                        <div class="activity-item">
                            <div class="activity-icon">📊</div>
                            <div class="activity-content">
                                <h4>시스템 상태</h4>
                                <p>모든 시스템이 정상적으로 작동 중입니다.</p>
                                <span class="activity-time">방금 전</span>
                            </div>
                        </div>
                        
                        <div class="activity-item">
                            <div class="activity-icon">🔧</div>
                            <div class="activity-content">
                                <h4>데이터베이스 연결</h4>
                                <p>MySQL 데이터베이스 연결이 안정적으로 유지되고 있습니다.</p>
                                <span class="activity-time">5분 전</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- 빠른 액션 -->
                <div class="quick-actions">
                    <h2>빠른 액션</h2>
                    <div class="action-buttons">
                        <a href="memberMng.jsp" class="action-btn">
                            <span class="action-icon">👥</span>
                            <span>회원 관리</span>
                        </a>
                        <a href="productMng.jsp" class="action-btn">
                            <span class="action-icon">📦</span>
                            <span>상품 관리</span>
                        </a>
                        <a href="orderMng.jsp" class="action-btn">
                            <span class="action-icon">🛒</span>
                            <span>주문 관리</span>
                        </a>
                        <a href="inquiryMng.jsp" class="action-btn">
                            <span class="action-icon">❓</span>
                            <span>문의사항</span>
                        </a>
                        <a href="db_viewer.jsp" class="action-btn">
                            <span class="action-icon">🗄️</span>
                            <span>데이터베이스 뷰어</span>
                        </a>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html> 