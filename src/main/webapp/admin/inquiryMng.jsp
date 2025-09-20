<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<jsp:include page="../common/adminCheck.jsp" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>문의사항 관리 - 올반푸드</title>
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
                <h1>문의사항 관리</h1>
                <p>고객 문의사항을 관리하고 답변할 수 있습니다.</p>
            </div>
            
            <!-- 검색 및 필터 -->
            <div class="search-filter">
                <div class="search-filter-content">
                    <div class="search-group">
                        <label for="searchInput">문의사항 검색</label>
                        <input type="text" id="searchInput" placeholder="제목, 내용으로 검색...">
                    </div>
                    <div class="filter-group">
                        <select id="statusFilter">
                            <option value="">전체 상태</option>
                            <option value="pending">답변 대기</option>
                            <option value="answered">답변 완료</option>
                            <option value="closed">처리 완료</option>
                        </select>
                        <button class="admin-btn admin-btn-primary" onclick="searchInquiries()">검색</button>
                        <button class="admin-btn admin-btn-secondary" onclick="resetSearch()">초기화</button>
                    </div>
                </div>
            </div>
            
            <!-- 문의사항 목록 테이블 -->
            <div class="admin-table">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>회원</th>
                            <th>제목</th>
                            <th>내용</th>
                            <th>상태</th>
                            <th>등록일</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody id="inquiryTableBody">
                        <%
                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;
                        
                        try {
                            conn = DBUtil.getConnection();
                            
                            // 문의사항 목록 조회
                            String sql = "SELECT i.id, i.subject, i.content, i.status, i.created_at, " +
                                       "m.business_name, m.username " +
                                       "FROM inquiries i " +
                                       "LEFT JOIN members m ON i.member_id = m.id " +
                                       "ORDER BY i.created_at DESC";
                            
                            pstmt = conn.prepareStatement(sql);
                            rs = pstmt.executeQuery();
                            
                            while (rs.next()) {
                                int inquiryId = rs.getInt("id");
                                String subject = rs.getString("subject");
                                String content = rs.getString("content");
                                String status = rs.getString("status");
                                Timestamp createdAt = rs.getTimestamp("created_at");
                                String businessName = rs.getString("business_name");
                                String username = rs.getString("username");
                                
                                // 내용 길이 제한
                                String shortContent = content != null && content.length() > 50 ? 
                                    content.substring(0, 50) + "..." : content;
                                %>
                                <tr>
                                    <td><%= inquiryId %></td>
                                    <td><%= businessName != null ? businessName : username %></td>
                                    <td><%= subject %></td>
                                    <td><%= shortContent %></td>
                                    <td>
                                        <span class="status-badge <%= 
                                            status.equals("pending") ? "status-pending" : 
                                            status.equals("answered") ? "status-completed" : "status-active" %>">
                                            <%= status.equals("pending") ? "답변 대기" : 
                                               status.equals("answered") ? "답변 완료" : "처리 완료" %>
                                        </span>
                                    </td>
                                    <td><%= createdAt.toString().substring(0, 10) %></td>
                                    <td>
                                        <button class="admin-btn admin-btn-secondary" onclick="viewInquiry(<%= inquiryId %>)">상세보기</button>
                                        <button class="admin-btn admin-btn-primary" onclick="replyInquiry(<%= inquiryId %>)">답변</button>
                                    </td>
                                </tr>
                                <%
                            }
                            
                        } catch (SQLException e) {
                            %>
                            <tr>
                                <td colspan="7" style="text-align: center; color: var(--red-500);">
                                    문의사항 정보를 불러오는 중 오류가 발생했습니다.
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
    
    <!-- 문의사항 상세보기 모달 -->
    <div id="inquiryModal" class="custom-modal">
        <div class="modal-content" style="max-width: 700px;">
            <div class="modal-header">
                <h3>문의사항 상세</h3>
                <button class="modal-close" onclick="closeInquiryModal()">&times;</button>
            </div>
            <div class="modal-body" id="inquiryModalBody">
                <!-- 동적으로 내용이 채워집니다 -->
            </div>
            <div class="modal-footer">
                <button class="modal-btn modal-btn-primary" onclick="closeInquiryModal()">닫기</button>
            </div>
        </div>
    </div>
    
    <!-- 답변 작성 모달 -->
    <div id="replyModal" class="custom-modal">
        <div class="modal-content" style="max-width: 600px;">
            <div class="modal-header">
                <h3>답변 작성</h3>
                <button class="modal-close" onclick="closeReplyModal()">&times;</button>
            </div>
            <div class="modal-body">
                <form id="replyForm" class="admin-form">
                    <input type="hidden" id="inquiryId" name="inquiry_id">
                    
                    <div class="form-group">
                        <label for="replyContent">답변 내용 *</label>
                        <textarea id="replyContent" name="content" rows="6" required placeholder="답변 내용을 입력하세요..."></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="modal-btn modal-btn-primary" onclick="saveReply()">답변 등록</button>
                <button class="modal-btn modal-btn-secondary" onclick="closeReplyModal()">취소</button>
            </div>
        </div>
    </div>
    
    <script>
        // 문의사항 검색
        function searchInquiries() {
            const searchTerm = document.getElementById('searchInput').value.trim();
            const statusFilter = document.getElementById('statusFilter').value;
            
            // AJAX로 검색 결과 가져오기
            fetch('inquirySearch.jsp?search=' + encodeURIComponent(searchTerm) + '&status=' + statusFilter)
                .then(response => response.text())
                .then(html => {
                    document.getElementById('inquiryTableBody').innerHTML = html;
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
        
        // 문의사항 상세보기
        function viewInquiry(inquiryId) {
            fetch('getInquiryInfo.jsp?id=' + inquiryId)
                .then(response => response.text())
                .then(html => {
                    document.getElementById('inquiryModalBody').innerHTML = html;
                    document.getElementById('inquiryModal').style.display = 'block';
                    document.body.style.overflow = 'hidden';
                })
                .catch(error => {
                    console.error('문의사항 정보 가져오기 오류:', error);
                    alert('문의사항 정보를 가져오는 중 오류가 발생했습니다.');
                });
        }
        
        // 답변 작성
        function replyInquiry(inquiryId) {
            document.getElementById('inquiryId').value = inquiryId;
            document.getElementById('replyContent').value = '';
            document.getElementById('replyModal').style.display = 'block';
            document.body.style.overflow = 'hidden';
        }
        
        // 답변 저장
        function saveReply() {
            const form = document.getElementById('replyForm');
            const formData = new FormData(form);
            
            fetch('saveReply.jsp', {
                method: 'POST',
                body: formData
            })
            .then(response => response.text())
            .then(result => {
                if (result === 'success') {
                    alert('답변이 등록되었습니다.');
                    closeReplyModal();
                    location.reload();
                } else {
                    alert('답변 등록 중 오류가 발생했습니다.');
                }
            })
            .catch(error => {
                console.error('답변 저장 오류:', error);
                alert('답변 저장 중 오류가 발생했습니다.');
            });
        }
        
        // 문의사항 모달 닫기
        function closeInquiryModal() {
            document.getElementById('inquiryModal').style.display = 'none';
            document.body.style.overflow = 'auto';
        }
        
        // 답변 모달 닫기
        function closeReplyModal() {
            document.getElementById('replyModal').style.display = 'none';
            document.body.style.overflow = 'auto';
        }
        
        // 모달 외부 클릭 시 닫기
        document.getElementById('inquiryModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeInquiryModal();
            }
        });
        
        document.getElementById('replyModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeReplyModal();
            }
        });
        
        // ESC 키로 모달 닫기
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeInquiryModal();
                closeReplyModal();
            }
        });
        
        // 엔터 키로 검색
        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchInquiries();
            }
        });
    </script>
</body>
</html> 