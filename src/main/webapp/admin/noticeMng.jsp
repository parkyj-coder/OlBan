<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<jsp:include page="../common/adminCheck.jsp" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지사항 관리 - 올반푸드</title>
    <link rel="icon" type="image/x-icon" href="../img/logo.png">
    <link rel="stylesheet" href="../css/main.css">
    <link rel="stylesheet" href="css/admin.css">
    <style>
        /* 모바일 반응형 테이블 스타일 */
        @media (max-width: 768px) {
            .admin-table {
                overflow-x: auto;
                -webkit-overflow-scrolling: touch;
            }
            
            .admin-table table {
                min-width: 600px;
                width: 100%;
            }
            
            .admin-table th,
            .admin-table td {
                padding: 8px 4px;
                font-size: 14px;
                white-space: nowrap;
            }
            
            .admin-table th:nth-child(1),
            .admin-table td:nth-child(1) {
                width: 50px;
                min-width: 50px;
            }
            
            .admin-table th:nth-child(2),
            .admin-table td:nth-child(2) {
                width: 150px;
                min-width: 150px;
            }
            
            .admin-table th:nth-child(3),
            .admin-table td:nth-child(3) {
                width: 200px;
                min-width: 200px;
                white-space: normal;
                word-break: break-word;
            }
            
            .admin-table th:nth-child(4),
            .admin-table td:nth-child(4) {
                width: 60px;
                min-width: 60px;
            }
            
            .admin-table th:nth-child(5),
            .admin-table td:nth-child(5) {
                width: 80px;
                min-width: 80px;
            }
            
            .admin-table th:nth-child(6),
            .admin-table td:nth-child(6) {
                width: 100px;
                min-width: 100px;
            }
            
            .content-preview {
                max-width: 200px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }
            
            .action-buttons {
                display: flex;
                flex-direction: column;
                gap: 4px;
            }
            
            .action-buttons a {
                padding: 4px 8px;
                font-size: 12px;
                text-align: center;
                border-radius: 4px;
                text-decoration: none;
                display: block;
            }
            
            .edit-btn {
                background-color: #007bff;
                color: white;
            }
            
            .delete-btn {
                background-color: #dc3545;
                color: white;
            }
            
            .status-active {
                background-color: #28a745;
                color: white;
                padding: 2px 6px;
                border-radius: 12px;
                font-size: 11px;
            }
            
            .status-inactive {
                background-color: #6c757d;
                color: white;
                padding: 2px 6px;
                border-radius: 12px;
                font-size: 11px;
            }
            
            /* 검색 필터 영역 모바일 최적화 */
            .search-filter-content {
                flex-direction: column;
                gap: 10px;
            }
            
            .search-group {
                width: 100%;
            }
            
            .filter-group {
                width: 100%;
                display: flex;
                flex-wrap: wrap;
                gap: 8px;
            }
            
            .filter-group .admin-btn {
                flex: 1;
                min-width: 80px;
                padding: 10px 12px;
                font-size: 14px;
            }
        }
        
        /* 더 작은 화면 (480px 이하) */
        @media (max-width: 480px) {
            .admin-table table {
                min-width: 500px;
            }
            
            .admin-table th,
            .admin-table td {
                padding: 6px 2px;
                font-size: 12px;
            }
            
            .admin-table th:nth-child(3),
            .admin-table td:nth-child(3) {
                width: 150px;
                min-width: 150px;
            }
            
            .content-preview {
                max-width: 150px;
            }
            
            .filter-group {
                flex-direction: column;
            }
            
            .filter-group .admin-btn {
                width: 100%;
                margin-bottom: 5px;
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
                <h1>공지사항 관리</h1>
                <p>공지사항을 관리할 수 있습니다.</p>
            </div>
            
            <!-- 검색 및 필터 -->
            <div class="search-filter">
                <div class="search-filter-content">
                    <div class="search-group">
                        <label for="searchInput">공지사항 검색</label>
                        <input type="text" id="searchInput" placeholder="제목, 내용으로 검색...">
                    </div>
                    <div class="filter-group">
                        <button class="admin-btn admin-btn-primary" onclick="searchNotices()">검색</button>
                        <button class="admin-btn admin-btn-secondary" onclick="resetSearch()">초기화</button>
                        <a href="addNotice.jsp" class="admin-btn admin-btn-notice">+ 새 공지사항</a>
                    </div>
                </div>
            </div>
            
            <!-- 공지사항 목록 테이블 -->
            <div class="admin-table">
                <table>
                    <thead>
                        <tr>
                            <th>번호</th>
                            <th>제목</th>
                            <th>내용 미리보기</th>
                            <th>상태</th>
                            <th>작성일</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody id="noticeTableBody">
                        <%
                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;
                        
                        try {
                            conn = DBUtil.getConnection();
                            String sql = "SELECT id, title, content, is_active, created_at " +
                                       "FROM notices " +
                                       "ORDER BY created_at DESC";
                            
                            pstmt = conn.prepareStatement(sql);
                            rs = pstmt.executeQuery();
                            
                            while (rs.next()) {
                                int id = rs.getInt("id");
                                String title = rs.getString("title");
                                String content = rs.getString("content");
                                boolean isActive = rs.getBoolean("is_active");
                                String createdAt = rs.getString("created_at");
                                
                                // 날짜 포맷팅
                                String formattedDate = createdAt;
                                if (createdAt != null && createdAt.length() > 10) {
                                    formattedDate = createdAt.substring(0, 10);
                                }
                                
                                // 내용 미리보기 (30자 제한 - 모바일 최적화)
                                String contentPreview = content;
                                if (content != null && content.length() > 30) {
                                    contentPreview = content.substring(0, 30) + "...";
                                }
                        %>
                        <tr>
                            <td><%= id %></td>
                            <td><%= title %></td>
                            <td class="content-preview"><%= contentPreview != null ? contentPreview : "" %></td>
                            <td>
                                <span class="<%= isActive ? "status-active" : "status-inactive" %>">
                                    <%= isActive ? "활성" : "비활성" %>
                                </span>
                            </td>
                            <td><%= formattedDate %></td>
                            <td class="action-buttons">
                                <a href="editNotice.jsp?id=<%= id %>" class="edit-btn">수정</a>
                                <a href="deleteNotice.jsp?id=<%= id %>" class="delete-btn" 
                                   onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
                            </td>
                        </tr>
                        <%
                            }
                        } catch (Exception e) {
                            System.out.println("공지사항 조회 실패: " + e.getMessage());
                        } finally {
                            if (rs != null) rs.close();
                            if (pstmt != null) pstmt.close();
                            if (conn != null) DBUtil.closeConnection(conn);
                        }
                        %>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
    
    <script>
        function searchNotices() {
            const searchTerm = document.getElementById('searchInput').value.trim();
            // 검색 기능 구현
            console.log('검색어:', searchTerm);
        }
        
        function resetSearch() {
            document.getElementById('searchInput').value = '';
            // 검색 초기화
        }
    </script>
</body>
</html>
