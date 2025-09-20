<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>데이터베이스 뷰어 - 올반푸드 관리자</title>
    <link rel="stylesheet" href="../css/admin.css">
    <style>
        .db-viewer {
            padding: 20px;
            max-width: 1400px;
            margin: 0 auto;
        }
        
        .table-selector {
            margin-bottom: 30px;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .table-selector h2 {
            margin-bottom: 15px;
            color: #2c3e50;
        }
        
        .table-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .table-btn {
            padding: 10px 20px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .table-btn:hover {
            background: #2980b9;
            transform: translateY(-2px);
        }
        
        .table-btn.active {
            background: #e74c3c;
        }
        
        .data-table {
            width: 100%;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
            margin-bottom: 20px;
        }
        
        .data-table h3 {
            padding: 20px;
            margin: 0;
            background: #2c3e50;
            color: white;
            font-size: 1.2rem;
        }
        
        .table-container {
            overflow-x: auto;
            max-height: 600px;
            overflow-y: auto;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }
        
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        th {
            background: #f8f9fa;
            font-weight: 600;
            color: #2c3e50;
            position: sticky;
            top: 0;
            z-index: 10;
        }
        
        tr:hover {
            background: #f8f9fa;
        }
        
        .status-active {
            color: #27ae60;
            font-weight: 600;
        }
        
        .status-inactive {
            color: #e74c3c;
            font-weight: 600;
        }
        
        .image-preview {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 5px;
        }
        
        .no-data {
            padding: 40px;
            text-align: center;
            color: #666;
            font-style: italic;
        }
        
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: #3498db;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #666;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/adminCheck.jsp" />
    
    <div class="db-viewer">
        <h1>데이터베이스 뷰어</h1>
        
        <!-- 통계 카드 -->
        <div class="stats">
            <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                conn = DBUtil.getConnection();
                
                // 총 회원 수
                String memberSql = "SELECT COUNT(*) FROM members";
                pstmt = conn.prepareStatement(memberSql);
                rs = pstmt.executeQuery();
                int totalMembers = 0;
                if (rs.next()) totalMembers = rs.getInt(1);
                
                // 총 상품 수
                String productSql = "SELECT COUNT(*) FROM products";
                pstmt = conn.prepareStatement(productSql);
                rs = pstmt.executeQuery();
                int totalProducts = 0;
                if (rs.next()) totalProducts = rs.getInt(1);
                
                // 활성 상품 수
                String activeProductSql = "SELECT COUNT(*) FROM products WHERE is_active = 1";
                pstmt = conn.prepareStatement(activeProductSql);
                rs = pstmt.executeQuery();
                int activeProducts = 0;
                if (rs.next()) activeProducts = rs.getInt(1);
                
                // 총 주문 수
                String orderSql = "SELECT COUNT(*) FROM orders";
                pstmt = conn.prepareStatement(orderSql);
                rs = pstmt.executeQuery();
                int totalOrders = 0;
                if (rs.next()) totalOrders = rs.getInt(1);
            %>
            <div class="stat-card">
                <div class="stat-number"><%= totalMembers %></div>
                <div class="stat-label">총 회원 수</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= totalProducts %></div>
                <div class="stat-label">총 상품 수</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= activeProducts %></div>
                <div class="stat-label">활성 상품 수</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= totalOrders %></div>
                <div class="stat-label">총 주문 수</div>
            </div>
            <%
            } catch (Exception e) {
                out.println("<p style='color: red;'>통계 조회 중 오류 발생: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
            %>
        </div>
        
        <!-- 테이블 선택기 -->
        <div class="table-selector">
            <h2>테이블 선택</h2>
            <div class="table-buttons">
                <button class="table-btn" onclick="showTable('members')">회원 테이블</button>
                <button class="table-btn" onclick="showTable('products')">상품 테이블</button>
                <button class="table-btn" onclick="showTable('categories')">카테고리 테이블</button>
                <button class="table-btn" onclick="showTable('subcategories')">서브카테고리 테이블</button>
                <button class="table-btn" onclick="showTable('orders')">주문 테이블</button>
                <button class="table-btn" onclick="showTable('order_items')">주문 상품 테이블</button>
                <button class="table-btn" onclick="showTable('inquiries')">문의 테이블</button>
            </div>
        </div>
        
        <!-- 데이터 테이블 컨테이너 -->
        <div id="dataContainer">
            <!-- 여기에 선택된 테이블의 데이터가 표시됩니다 -->
        </div>
    </div>

    <script>
        // 현재 선택된 테이블
        let currentTable = '';
        
        // 테이블 표시 함수
        function showTable(tableName) {
            currentTable = tableName;
            
            // 버튼 상태 업데이트
            document.querySelectorAll('.table-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            event.target.classList.add('active');
            
            // AJAX로 데이터 로드
            loadTableData(tableName);
        }
        
        // AJAX로 테이블 데이터 로드
        function loadTableData(tableName) {
            const container = document.getElementById('dataContainer');
            container.innerHTML = '<div style="text-align: center; padding: 40px;">데이터를 로딩 중...</div>';
            
            fetch(`db_data.jsp?table=${tableName}`)
                .then(response => response.text())
                .then(data => {
                    container.innerHTML = data;
                })
                .catch(error => {
                    container.innerHTML = `<div style="color: red; text-align: center; padding: 40px;">데이터 로드 중 오류 발생: ${error}</div>`;
                });
        }
        
        // 페이지 로드 시 회원 테이블 표시
        document.addEventListener('DOMContentLoaded', function() {
            showTable('members');
        });
    </script>
</body>
</html> 