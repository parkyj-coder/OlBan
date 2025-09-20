<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<jsp:include page="../common/adminCheck.jsp" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주문 관리 - 올반푸드</title>
    <link rel="icon" type="image/x-icon" href="../img/logo.png">
    <link rel="stylesheet" href="../css/main.css">
    <link rel="stylesheet" href="css/admin.css">
</head>
<body>
    <div class="admin-container">
        <!-- 관리자 헤더 -->
        <jsp:include page="common/adminHeader.jsp" />

        <main class="admin-main">
            <div class="page-header">
                <h1>주문 관리</h1>
                <p>고객 주문을 관리하고 처리할 수 있습니다.</p>
            </div>
            
            <!-- 검색 및 필터 -->
            <div class="search-filter">
                <div class="search-filter-content">
                    <div class="search-group">
                        <label for="searchInput">주문 검색</label>
                        <input type="text" id="searchInput" placeholder="주문번호, 고객명으로 검색...">
                    </div>
                    <div class="filter-group">
                        <select id="statusFilter">
                            <option value="">전체 상태</option>
                            <option value="pending">주문 대기</option>
                            <option value="processing">처리 중</option>
                            <option value="shipped">배송 중</option>
                            <option value="completed">배송 완료</option>
                            <option value="cancelled">주문 취소</option>
                        </select>
                        <button class="admin-btn admin-btn-primary" onclick="searchOrders()">검색</button>
                        <button class="admin-btn admin-btn-secondary" onclick="resetSearch()">초기화</button>
                    </div>
                </div>
            </div>
            
            <!-- 주문 목록 테이블 -->
            <div class="admin-table">
                <table>
                    <thead>
                        <tr>
                            <th>주문번호</th>
                            <th>고객명</th>
                            <th>상품 수</th>
                            <th>총 금액</th>
                            <th>주문 상태</th>
                            <th>주문일</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody id="orderTableBody">
                        <%
                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;
                        
                        try {
                            conn = DBUtil.getConnection();
                            
                            // 주문 목록 조회 (상품 수와 총 금액 포함)
                            String sql = "SELECT o.id, o.order_number, o.total_amount, o.status, o.created_at, " +
                                       "m.business_name, m.username, " +
                                       "COUNT(oi.id) as item_count " +
                                       "FROM orders o " +
                                       "LEFT JOIN members m ON o.member_id = m.id " +
                                       "LEFT JOIN order_items oi ON o.id = oi.order_id " +
                                       "GROUP BY o.id, o.order_number, o.total_amount, o.status, o.created_at, m.business_name, m.username " +
                                       "ORDER BY o.created_at DESC";
                            
                            pstmt = conn.prepareStatement(sql);
                            rs = pstmt.executeQuery();
                            
                            while (rs.next()) {
                                int orderId = rs.getInt("id");
                                String orderNumber = rs.getString("order_number");
                                int totalAmount = rs.getInt("total_amount");
                                String status = rs.getString("status");
                                Timestamp createdAt = rs.getTimestamp("created_at");
                                String businessName = rs.getString("business_name");
                                String username = rs.getString("username");
                                int itemCount = rs.getInt("item_count");
                                
                                // 상태별 배지 클래스
                                String statusClass = "";
                                String statusText = "";
                                switch (status) {
                                    case "pending":
                                        statusClass = "status-pending";
                                        statusText = "주문 대기";
                                        break;
                                    case "processing":
                                        statusClass = "status-active";
                                        statusText = "처리 중";
                                        break;
                                    case "shipped":
                                        statusClass = "status-completed";
                                        statusText = "배송 중";
                                        break;
                                    case "completed":
                                        statusClass = "status-completed";
                                        statusText = "배송 완료";
                                        break;
                                    case "cancelled":
                                        statusClass = "status-inactive";
                                        statusText = "주문 취소";
                                        break;
                                    default:
                                        statusClass = "status-pending";
                                        statusText = "주문 대기";
                                }
                                %>
                                <tr>
                                    <td><%= orderNumber %></td>
                                    <td><%= businessName != null ? businessName : username %></td>
                                    <td><%= itemCount %>개</td>
                                    <td>₩<%= String.format("%,d", totalAmount) %></td>
                                    <td>
                                        <span class="status-badge <%= statusClass %>">
                                            <%= statusText %>
                                        </span>
                                    </td>
                                    <td><%= createdAt.toString().substring(0, 10) %></td>
                                    <td>
                                        <button class="admin-btn admin-btn-secondary" onclick="viewOrder(<%= orderId %>)">상세보기</button>
                                        <button class="admin-btn admin-btn-primary" onclick="updateOrderStatus(<%= orderId %>)">상태 변경</button>
                                    </td>
                                </tr>
                                <%
                            }
                            
                        } catch (SQLException e) {
                            %>
                            <tr>
                                <td colspan="7" style="text-align: center; color: var(--red-500);">
                                    주문 정보를 불러오는 중 오류가 발생했습니다.
                                </td>
                            </tr>
                            <%
                            e.printStackTrace();
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException e) { }
                            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
                            if (conn != null) try { conn.close(); } catch (SQLException e) { }
                        }
                        %>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
    
    <!-- 주문 상세보기 모달 -->
    <div id="orderModal" class="custom-modal">
        <div class="modal-content" style="max-width: 800px;">
            <div class="modal-header">
                <h3>주문 상세 정보</h3>
                <button class="modal-close" onclick="closeOrderModal()">&times;</button>
            </div>
            <div class="modal-body" id="orderModalBody">
                <!-- 동적으로 내용이 채워집니다 -->
            </div>
            <div class="modal-footer">
                <button class="modal-btn modal-btn-primary" onclick="closeOrderModal()">닫기</button>
            </div>
        </div>
    </div>
    
    <!-- 주문 상태 변경 모달 -->
    <div id="statusModal" class="custom-modal">
        <div class="modal-content" style="max-width: 500px;">
            <div class="modal-header">
                <h3>주문 상태 변경</h3>
                <button class="modal-close" onclick="closeStatusModal()">&times;</button>
            </div>
            <div class="modal-body">
                <form id="statusForm" class="admin-form">
                    <input type="hidden" id="orderId" name="order_id">
                    
                    <div class="form-group">
                        <label for="orderStatus">주문 상태</label>
                        <select id="orderStatus" name="status" required>
                            <option value="pending">주문 대기</option>
                            <option value="processing">처리 중</option>
                            <option value="shipped">배송 중</option>
                            <option value="completed">배송 완료</option>
                            <option value="cancelled">주문 취소</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="modal-btn modal-btn-primary" onclick="saveOrderStatus()">상태 변경</button>
                <button class="modal-btn modal-btn-secondary" onclick="closeStatusModal()">취소</button>
            </div>
        </div>
    </div>
    
    <script>
        // 주문 검색
        function searchOrders() {
            const searchTerm = document.getElementById('searchInput').value.trim();
            const statusFilter = document.getElementById('statusFilter').value;
            
            // AJAX로 검색 결과 가져오기
            fetch('orderSearch.jsp?search=' + encodeURIComponent(searchTerm) + '&status=' + statusFilter)
                .then(response => response.text())
                .then(html => {
                    document.getElementById('orderTableBody').innerHTML = html;
                })
                .catch(error => {
                    console.error('검색 오류:', error);
                    alert('검색 중 오류가 발생했습니다.');
                });
        }
        
        // 검색 초기화
        function resetSearch() {
            document.getElementById('searchInput').value = '';
            document.getElementById('statusFilter').value = '';
            location.reload();
        }
        
        // 주문 상세보기
        function viewOrder(orderId) {
            fetch('getOrderInfo.jsp?id=' + orderId)
                .then(response => response.text())
                .then(html => {
                    document.getElementById('orderModalBody').innerHTML = html;
                    document.getElementById('orderModal').style.display = 'block';
                    document.body.style.overflow = 'hidden';
                })
                .catch(error => {
                    console.error('주문 정보 가져오기 오류:', error);
                    alert('주문 정보를 가져오는 중 오류가 발생했습니다.');
                });
        }
        
        // 주문 상태 변경
        function updateOrderStatus(orderId) {
            document.getElementById('orderId').value = orderId;
            document.getElementById('orderStatus').value = 'pending';
            document.getElementById('statusModal').style.display = 'block';
            document.body.style.overflow = 'hidden';
        }
        
        // 주문 상태 저장
        function saveOrderStatus() {
            const form = document.getElementById('statusForm');
            const formData = new FormData(form);
            
            fetch('updateOrderStatus.jsp', {
                method: 'POST',
                body: formData
            })
            .then(response => response.text())
            .then(result => {
                if (result === 'success') {
                    alert('주문 상태가 변경되었습니다.');
                    closeStatusModal();
                    location.reload();
                } else {
                    alert('주문 상태 변경 중 오류가 발생했습니다.');
                }
            })
            .catch(error => {
                console.error('상태 변경 오류:', error);
                alert('주문 상태 변경 중 오류가 발생했습니다.');
            });
        }
        
        // 주문 모달 닫기
        function closeOrderModal() {
            document.getElementById('orderModal').style.display = 'none';
            document.body.style.overflow = 'auto';
        }
        
        // 상태 변경 모달 닫기
        function closeStatusModal() {
            document.getElementById('statusModal').style.display = 'none';
            document.body.style.overflow = 'auto';
        }
        
        // 모달 외부 클릭 시 닫기
        document.getElementById('orderModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeOrderModal();
            }
        });
        
        document.getElementById('statusModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeStatusModal();
            }
        });
        
        // ESC 키로 모달 닫기
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeOrderModal();
                closeStatusModal();
            }
        });
        
        // 엔터 키로 검색
        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchOrders();
            }
        });
    </script>
</body>
</html> 