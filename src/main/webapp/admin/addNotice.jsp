<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<%
    // POST 요청 처리
    if ("POST".equals(request.getMethod())) {
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String isActive = request.getParameter("is_active");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO notices (title, content, is_active) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, title);
            pstmt.setString(2, content);
            pstmt.setString(3, isActive != null ? "1" : "0");
            
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                response.sendRedirect("noticeMng.jsp?success=1");
                return;
            } else {
                response.sendRedirect("addNotice.jsp?error=1");
                return;
            }
        } catch (Exception e) {
            System.out.println("공지사항 추가 실패: " + e.getMessage());
            response.sendRedirect("addNotice.jsp?error=1");
            return;
        } finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) DBUtil.closeConnection(conn);
        }
    }
%>
<jsp:include page="../common/adminCheck.jsp" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지사항 추가 - 올반푸드</title>
    <link rel="icon" type="image/x-icon" href="../img/logo.png">
    <link rel="stylesheet" href="../css/main.css">
    <link rel="stylesheet" href="css/admin.css">
    <style>
        /* 체크박스 스타일 우선 적용 */
        .admin-form .checkbox-label {
            display: flex !important;
            align-items: center !important;
            color: var(--gray-700) !important;
            font-weight: 500 !important;
            cursor: pointer !important;
            margin-bottom: 0 !important;
            line-height: 1.5 !important;
            width: fit-content !important;
            max-width: none !important;
            position: relative !important;
        }
        
        .admin-form .checkbox-label input[type="checkbox"] {
            margin-right: var(--spacing-3) !important;
            transform: scale(1.3) !important;
            margin-top: 0 !important;
            margin-bottom: 0 !important;
            flex-shrink: 0 !important;
            position: relative !important;
            z-index: 1 !important;
        }
        
        .admin-form .checkbox-label span {
            line-height: 1.5 !important;
            white-space: nowrap !important;
            flex-shrink: 0 !important;
            position: relative !important;
            z-index: 1 !important;
            margin-left: 0 !important;
            margin-right: 0 !important;
        }
        
        /* 체크박스가 있는 form-group 특별 처리 */
        .admin-form .form-group:has(.checkbox-label) {
            display: flex !important;
            justify-content: flex-start !important;
            align-items: center !important;
        }
        
        .admin-form .form-group .checkbox-label {
            margin: 0 !important;
            padding: 0 !important;
        }
        
        @media (max-width: 768px) {
            .admin-form .checkbox-label {
                align-items: flex-start !important;
                padding-top: var(--spacing-1) !important;
            }
            
            .admin-form .checkbox-label input[type="checkbox"] {
                transform: scale(1.2) !important;
                margin-top: 2px !important;
            }
            
            .admin-form .checkbox-label span {
                line-height: 1.4 !important;
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
                <h1>새 공지사항 작성</h1>
                <p>새로운 공지사항을 작성하세요.</p>
            </div>
            
            <!-- 공지사항 작성 폼 -->
            <div class="admin-form">
                <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-error">
                    공지사항 추가 중 오류가 발생했습니다. 다시 시도해주세요.
                </div>
                <% } %>
                
                <form method="post" action="addNotice.jsp">
                    <div class="form-group">
                        <label for="title">제목 *</label>
                        <input type="text" id="title" name="title" required 
                               placeholder="공지사항 제목을 입력하세요">
                    </div>
                    
                    <div class="form-group">
                        <label for="content">내용 *</label>
                        <textarea id="content" name="content" required 
                                  placeholder="공지사항 내용을 입력하세요" rows="10"></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label class="checkbox-label">
                            <input type="checkbox" name="is_active" checked>
                            <span>활성 상태</span>
                        </label>
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="admin-btn admin-btn-primary">공지사항 등록</button>
                        <a href="noticeMng.jsp" class="admin-btn admin-btn-secondary">취소</a>
                    </div>
                </form>
            </div>
        </main>
    </div>
    
    <script>
        // 폼 제출 전 유효성 검사
        document.querySelector('form').addEventListener('submit', function(e) {
            const title = document.getElementById('title').value.trim();
            const content = document.getElementById('content').value.trim();
            
            if (title === '') {
                alert('제목을 입력해주세요.');
                e.preventDefault();
                return;
            }
            
            if (content === '') {
                alert('내용을 입력해주세요.');
                e.preventDefault();
                return;
            }
        });
    </script>
</body>
</html>
