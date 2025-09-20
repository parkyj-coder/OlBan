<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<jsp:include page="../common/adminCheck.jsp" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 관리 - 올반푸드</title>
    <link rel="icon" type="image/x-icon" href="../img/logo.png">
    <link rel="stylesheet" href="../css/main.css">
    <link rel="stylesheet" href="css/admin.css">
    
    <style>
        /* 회원 목록 테이블 모바일 최적화 */
        .admin-table {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }
        
        /* 회원 상세보기 모달 스타일 개선 */
        .custom-modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(2px);
        }
        
        .modal-content {
            background-color: #fff;
            margin: 2% auto;
            padding: 0;
            border-radius: 12px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
            width: 90%;
            max-width: 600px;
            max-height: 90vh;
            overflow-y: auto;
            animation: modalSlideIn 0.3s ease-out;
        }
        
        @keyframes modalSlideIn {
            from {
                opacity: 0;
                transform: translateY(-50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 24px;
            border-bottom: 1px solid #e5e7eb;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 12px 12px 0 0;
        }
        
        .modal-header h3 {
            margin: 0;
            font-size: 18px;
            font-weight: 600;
        }
        
        .modal-close {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: white;
            padding: 0;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: background-color 0.2s;
        }
        
        .modal-close:hover {
            background-color: rgba(255, 255, 255, 0.2);
        }
        
        .modal-body {
            padding: 24px;
            max-height: 60vh;
            overflow-y: auto;
        }
        
        .modal-footer {
            padding: 16px 24px;
            border-top: 1px solid #e5e7eb;
            display: flex;
            justify-content: flex-end;
            background-color: #f9fafb;
            border-radius: 0 0 12px 12px;
        }
        
        .modal-btn {
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
            border: none;
            font-size: 14px;
        }
        
        .modal-btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .modal-btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(102, 126, 234, 0.3);
        }
        
        /* 모바일 반응형 */
        @media (max-width: 768px) {
            .modal-content {
                width: 95%;
                margin: 5% auto;
                max-height: 85vh;
            }
            
            .modal-header {
                padding: 16px 20px;
            }
            
            .modal-header h3 {
                font-size: 16px;
            }
            
            .modal-body {
                padding: 20px;
                max-height: 50vh;
            }
            
            .modal-footer {
                padding: 12px 20px;
            }
            
            .modal-btn {
                padding: 8px 16px;
                font-size: 13px;
            }
        }
        
        @media (max-width: 480px) {
            .modal-content {
                width: 98%;
                margin: 2% auto;
                max-height: 90vh;
            }
            
            .modal-header {
                padding: 12px 16px;
            }
            
            .modal-header h3 {
                font-size: 14px;
            }
            
            .modal-body {
                padding: 16px;
                max-height: 60vh;
            }
            
            .modal-footer {
                padding: 10px 16px;
            }
        }
        
        .admin-table table {
            min-width: 800px;
            width: 100%;
            border-collapse: collapse;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .admin-table th,
        .admin-table td {
            padding: 12px 8px;
            font-size: 14px;
            border: 1px solid #dee2e6;
        }
        
        .admin-table th {
            text-align: center;
            font-weight: 600;
            background-color: #f8f9fa;
            border-bottom: 2px solid #dee2e6;
        }
        
        .admin-table tbody tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        
        .admin-table tbody tr:hover {
            background-color: #e9ecef;
            transition: background-color 0.2s;
        }
        
        /* 컬럼별 너비 설정 */
        .admin-table th:nth-child(1),
        .admin-table td:nth-child(1) {
            width: 60px;
            min-width: 60px;
            text-align: center;
        }
        
        .admin-table th:nth-child(2),
        .admin-table td:nth-child(2) {
            width: 120px;
            min-width: 120px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            text-align: left;
        }
        
        .admin-table th:nth-child(3),
        .admin-table td:nth-child(3) {
            width: 150px;
            min-width: 150px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            text-align: left;
        }
        
        .admin-table th:nth-child(4),
        .admin-table td:nth-child(4) {
            width: 100px;
            min-width: 100px;
            white-space: nowrap;
            text-align: center;
        }
        
        .admin-table th:nth-child(5),
        .admin-table td:nth-child(5) {
            width: 180px;
            min-width: 180px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            text-align: left;
        }
        
        .admin-table th:nth-child(6),
        .admin-table td:nth-child(6) {
            width: 120px;
            min-width: 120px;
            white-space: nowrap;
            text-align: center;
        }
        
        .admin-table th:nth-child(7),
        .admin-table td:nth-child(7) {
            width: 100px;
            min-width: 100px;
            white-space: nowrap;
            text-align: center;
        }
        
        .admin-table th:nth-child(8),
        .admin-table td:nth-child(8) {
            width: 140px;
            min-width: 140px;
            white-space: nowrap;
        }
        
        .action-buttons {
            display: flex;
            gap: 4px;
            justify-content: center;
            align-items: center;
        }
        
        .action-buttons .admin-btn {
            padding: 4px 8px;
            font-size: 12px;
            min-height: 28px;
        }
        
        /* 모바일 반응형 */
        @media (max-width: 768px) {
            .admin-table table {
                min-width: 700px;
            }
            
            .admin-table th,
            .admin-table td {
                padding: 8px 4px;
                font-size: 12px;
            }
            
            .admin-table th:nth-child(2),
            .admin-table td:nth-child(2) {
                width: 100px;
                min-width: 100px;
            }
            
            .admin-table th:nth-child(3),
            .admin-table td:nth-child(3) {
                width: 120px;
                min-width: 120px;
            }
            
            .admin-table th:nth-child(5),
            .admin-table td:nth-child(5) {
                width: 150px;
                min-width: 150px;
            }
            
            .action-buttons {
                flex-direction: column;
                gap: 2px;
            }
            
            .action-buttons .admin-btn {
                padding: 2px 6px;
                font-size: 10px;
                min-height: 24px;
            }
        }
        
        @media (max-width: 480px) {
            .admin-table table {
                min-width: 600px;
                border-radius: 6px;
            }
            
            .admin-table th,
            .admin-table td {
                padding: 6px 2px;
                font-size: 11px;
            }
            
            .admin-table th:nth-child(2),
            .admin-table td:nth-child(2) {
                width: 80px;
                min-width: 80px;
            }
            
            .admin-table th:nth-child(3),
            .admin-table td:nth-child(3) {
                width: 100px;
                min-width: 100px;
            }
            
            .admin-table th:nth-child(5),
            .admin-table td:nth-child(5) {
                width: 120px;
                min-width: 120px;
            }
            
            .action-buttons .admin-btn {
                padding: 1px 4px;
                font-size: 9px;
                min-height: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <!-- 관리자 헤더 -->
        <jsp:include page="common/adminHeader.jsp" />

        <main class="admin-main">
            <div class="page-header">
                <h1>회원 관리</h1>
                <p>등록된 회원들을 관리할 수 있습니다.</p>
            </div>
            
            <!-- 검색 및 필터 -->
            <div class="search-filter">
                <div class="search-filter-content">
                    <div class="search-group">
                        <label for="searchInput">회원 검색</label>
                        <input type="text" id="searchInput" placeholder="이름, 아이디, 이메일로 검색...">
                    </div>
                    <div class="filter-group">
                        <button class="admin-btn admin-btn-primary" onclick="searchMembers()">검색</button>
                        <button class="admin-btn admin-btn-secondary" onclick="resetSearch()">초기화</button>
                    </div>
                </div>
            </div>
            
            <!-- 회원 목록 테이블 -->
            <div class="admin-table">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>아이디</th>
                            <th>상호명</th>
                            <th>대표자명</th>
                            <th>이메일</th>
                            <th>전화번호</th>
                            <th>가입일</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody id="memberTableBody">
                        <%
                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;
                        
                        try {
                            conn = DBUtil.getConnection();
                            
                            // 회원 목록 조회
                            String sql = "SELECT id, username, business_name, representative_name, email, phone, created_at, is_active " +
                                       "FROM members " +
                                       "ORDER BY created_at DESC";
                            
                            pstmt = conn.prepareStatement(sql);
                            rs = pstmt.executeQuery();
                            
                            while (rs.next()) {
                                int memberId = rs.getInt("id");
                                String username = rs.getString("username");
                                String businessName = rs.getString("business_name");
                                String representativeName = rs.getString("representative_name");
                                String email = rs.getString("email");
                                String phone = rs.getString("phone");
                                Timestamp createdAt = rs.getTimestamp("created_at");
                                boolean isActive = rs.getBoolean("is_active");
                                %>
                                <tr>
                                    <td><%= memberId %></td>
                                    <td><%= username %></td>
                                    <td><%= businessName %></td>
                                    <td><%= representativeName %></td>
                                    <td><%= email %></td>
                                    <td><%= phone != null ? phone : "-" %></td>
                                    <td><%= createdAt.toString().substring(0, 10) %></td>
                                    <td>
                                        <div class="action-buttons">
                                            <button class="admin-btn admin-btn-secondary" onclick="viewMember(<%= memberId %>)">상세보기</button>
                                            <button class="admin-btn admin-btn-danger" onclick="deleteMember(<%= memberId %>, '<%= businessName %>')">삭제</button>
                                        </div>
                                    </td>
                                </tr>
                                <%
                            }
                            
                        } catch (SQLException e) {
                            %>
                            <tr>
                                <td colspan="8" style="text-align: center; color: var(--red-500);">
                                    회원 정보를 불러오는 중 오류가 발생했습니다.
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
    
    <!-- 회원 상세보기 모달 -->
    <div id="memberModal" class="custom-modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>회원 상세 정보</h3>
                <button class="modal-close" onclick="closeMemberModal()">&times;</button>
            </div>
            <div class="modal-body" id="memberModalBody">
                <!-- 동적으로 내용이 채워집니다 -->
            </div>
            <div class="modal-footer">
                <button class="modal-btn modal-btn-primary" onclick="closeMemberModal()">닫기</button>
            </div>
        </div>
    </div>
    
    <script>
        // 회원 검색
        function searchMembers() {
            const searchTerm = document.getElementById('searchInput').value.trim();
            if (searchTerm === '') {
                alert('검색어를 입력해주세요.');
                return;
            }
            
            // AJAX로 검색 결과 가져오기
            fetch('memberSearch.jsp?search=' + encodeURIComponent(searchTerm))
                .then(response => response.text())
                .then(html => {
                    document.getElementById('memberTableBody').innerHTML = html;
                })
                .catch(error => {
                    console.error('검색 오류:', error);
                    alert('검색 중 오류가 발생했습니다.');
                });
        }
        
        // 검색 초기화
        function resetSearch() {
            document.getElementById('searchInput').value = '';
            location.reload();
        }
        
        // 회원 상세보기
        function viewMember(memberId) {
            fetch('getMemberInfo.jsp?id=' + memberId)
                .then(response => response.text())
                .then(html => {
                    document.getElementById('memberModalBody').innerHTML = html;
                    document.getElementById('memberModal').style.display = 'block';
                    document.body.style.overflow = 'hidden';
                })
                .catch(error => {
                    console.error('회원 정보 가져오기 오류:', error);
                    alert('회원 정보를 가져오는 중 오류가 발생했습니다.');
                });
        }
        
        // 회원 삭제
        function deleteMember(memberId, businessName) {
            if (confirm('정말로 "' + businessName + '" 회원을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.')) {
                fetch('deleteMember.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'id=' + memberId
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.text();
                })
                .then(result => {
                    console.log('삭제 응답:', result); // 디버깅용
                    if (result.trim() === 'success') {
                        alert('회원이 삭제되었습니다.');
                        location.reload();
                    } else if (result.startsWith('error:')) {
                        alert('오류: ' + result.substring(6));
                    } else {
                        alert('회원 삭제 중 오류가 발생했습니다. 응답: ' + result);
                    }
                })
                .catch(error => {
                    console.error('삭제 오류:', error);
                    alert('회원 삭제 중 네트워크 오류가 발생했습니다.');
                });
            }
        }
        
        // 모달 닫기
        function closeMemberModal() {
            document.getElementById('memberModal').style.display = 'none';
            document.body.style.overflow = 'auto';
        }
        
        // 모달 외부 클릭 시 닫기
        window.onclick = function(event) {
            const modal = document.getElementById('memberModal');
            if (event.target === modal) {
                closeMemberModal();
            }
        }
        
        // ESC 키로 모달 닫기
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                const modal = document.getElementById('memberModal');
                if (modal.style.display === 'block') {
                    closeMemberModal();
                }
            }
        });
        
        // 엔터 키로 검색
        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchMembers();
            }
        });
    </script>
</body>
</html> 