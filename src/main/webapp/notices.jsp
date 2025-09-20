<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지사항 - 올반푸드</title>
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="css/pages/notices.css">
</head>
<body>
    <jsp:include page="common/header.jsp" />
    
    <main class="notices-page">
        <div class="notices-container">
            <div class="page-header">
                <h1 class="page-title">공지사항</h1>
                <p class="page-subtitle">올반푸드의 최신 소식과 안내사항을 확인하세요</p>
            </div>
            
            <!-- 검색 섹션 -->
            <div class="search-section">
                <form class="search-form" method="get" action="notices.jsp">
                    <input type="text" name="search" class="search-input" 
                           placeholder="공지사항 제목 또는 내용을 검색하세요" 
                           value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                    <button type="submit" class="search-btn">검색</button>
                </form>
            </div>
            
            <!-- 공지사항 목록 -->
            <div class="notices-list">
                <%
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                
                // 페이지네이션 설정
                int currentPage = 1;
                int pageSize = 10;
                String pageParam = request.getParameter("page");
                if (pageParam != null && !pageParam.isEmpty()) {
                    currentPage = Integer.parseInt(pageParam);
                }
                int offset = (currentPage - 1) * pageSize;
                
                // 검색 조건
                String search = request.getParameter("search");
                String whereClause = "WHERE is_active = 1";
                String searchParam = "";
                
                if (search != null && !search.trim().isEmpty()) {
                    whereClause += " AND (title LIKE ? OR content LIKE ?)";
                    searchParam = "%" + search.trim() + "%";
                }
                
                try {
                    conn = DBUtil.getConnection();
                    
                    // 전체 게시글 수 조회
                    String countSql = "SELECT COUNT(*) as total FROM notices " + whereClause;
                    pstmt = conn.prepareStatement(countSql);
                    if (!searchParam.isEmpty()) {
                        pstmt.setString(1, searchParam);
                        pstmt.setString(2, searchParam);
                    }
                    rs = pstmt.executeQuery();
                    
                    int totalNotices = 0;
                    if (rs.next()) {
                        totalNotices = rs.getInt("total");
                    }
                    
                    int totalPages = (int) Math.ceil((double) totalNotices / pageSize);
                    
                    // 공지사항 목록 조회
                    String sql = "SELECT id, title, content, created_at " +
                               "FROM notices " + whereClause + " " +
                               "ORDER BY created_at DESC " +
                               "LIMIT ? OFFSET ?";
                    
                    pstmt = conn.prepareStatement(sql);
                    int paramIndex = 1;
                    if (!searchParam.isEmpty()) {
                        pstmt.setString(paramIndex++, searchParam);
                        pstmt.setString(paramIndex++, searchParam);
                    }
                    pstmt.setInt(paramIndex++, pageSize);
                    pstmt.setInt(paramIndex++, offset);
                    
                    rs = pstmt.executeQuery();
                    
                    boolean hasNotices = false;
                    while (rs.next()) {
                        hasNotices = true;
                        int noticeId = rs.getInt("id");
                        String title = rs.getString("title");
                        String content = rs.getString("content");
                        String createdAt = rs.getString("created_at");
                        
                        // 날짜 포맷팅
                        String formattedDate = createdAt;
                        if (createdAt != null && createdAt.length() > 10) {
                            formattedDate = createdAt.substring(0, 10);
                        }
                %>
                <div class="notice-item" onclick="viewNotice(<%= noticeId %>)">
                    <div class="notice-header">
                        <h3 class="notice-title"><%= title %></h3>
                        <span class="notice-date"><%= formattedDate %></span>
                    </div>
                    <p class="notice-content"><%= content != null ? content : "" %></p>
                </div>
                <%
                    }
                    
                    if (!hasNotices) {
                %>
                <div class="no-notices">
                    <h3>공지사항이 없습니다</h3>
                    <p>
                        <% if (search != null && !search.trim().isEmpty()) { %>
                            검색 결과가 없습니다. 다른 키워드로 검색해보세요.
                        <% } else { %>
                            현재 등록된 공지사항이 없습니다.
                        <% } %>
                    </p>
                    <a href="index.jsp" class="back-btn">홈으로 돌아가기</a>
                </div>
                <%
                    }
                %>
            </div>
            
            <!-- 페이지네이션 -->
            <% if (hasNotices && totalPages > 1) { %>
            <div class="pagination">
                <% if (currentPage > 1) { %>
                    <a href="?page=1<%= search != null && !search.trim().isEmpty() ? "&search=" + java.net.URLEncoder.encode(search, "UTF-8") : "" %>">처음</a>
                    <a href="?page=<%= currentPage - 1 %><%= search != null && !search.trim().isEmpty() ? "&search=" + java.net.URLEncoder.encode(search, "UTF-8") : "" %>">이전</a>
                <% } else { %>
                    <span class="disabled">처음</span>
                    <span class="disabled">이전</span>
                <% } %>
                
                <% 
                int startPage = Math.max(1, currentPage - 2);
                int endPage = Math.min(totalPages, currentPage + 2);
                
                for (int i = startPage; i <= endPage; i++) {
                    if (i == currentPage) {
                %>
                    <span class="current"><%= i %></span>
                <% } else { %>
                    <a href="?page=<%= i %><%= search != null && !search.trim().isEmpty() ? "&search=" + java.net.URLEncoder.encode(search, "UTF-8") : "" %>"><%= i %></a>
                <% } %>
                <% } %>
                
                <% if (currentPage < totalPages) { %>
                    <a href="?page=<%= currentPage + 1 %><%= search != null && !search.trim().isEmpty() ? "&search=" + java.net.URLEncoder.encode(search, "UTF-8") : "" %>">다음</a>
                    <a href="?page=<%= totalPages %><%= search != null && !search.trim().isEmpty() ? "&search=" + java.net.URLEncoder.encode(search, "UTF-8") : "" %>">마지막</a>
                <% } else { %>
                    <span class="disabled">다음</span>
                    <span class="disabled">마지막</span>
                <% } %>
            </div>
            <% } %>
            
            <%
                } catch (Exception e) {
                    System.out.println("공지사항 조회 실패: " + e.getMessage());
            %>
            <div class="no-notices">
                <h3>시스템 점검 중</h3>
                <p>공지사항을 불러오는 중 오류가 발생했습니다.</p>
                <a href="index.jsp" class="back-btn">홈으로 돌아가기</a>
            </div>
            <%
                } finally {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) DBUtil.closeConnection(conn);
                }
            %>
        </div>
    </main>
    
    <jsp:include page="common/footer.jsp" />
    
    <script>
        function viewNotice(noticeId) {
            // 공지사항 상세보기 페이지로 이동
            // 현재는 간단히 alert로 표시하지만, 필요시 상세 페이지를 만들 수 있습니다
            alert('공지사항 상세보기 기능은 추후 구현 예정입니다.\n공지사항 ID: ' + noticeId);
        }
        
        // 검색 폼 제출 시 빈 검색어 처리
        document.querySelector('.search-form').addEventListener('submit', function(e) {
            const searchInput = document.querySelector('.search-input');
            if (searchInput.value.trim() === '') {
                e.preventDefault();
                window.location.href = 'notices.jsp';
            }
        });
    </script>
</body>
</html>
