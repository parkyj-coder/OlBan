<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<%
    String memberIdStr = request.getParameter("id");
    
    if (memberIdStr == null || memberIdStr.trim().isEmpty()) {
        out.print("<p style='color: var(--red-500);'>회원 ID가 제공되지 않았습니다.</p>");
        return;
    }
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        conn = DBUtil.getConnection();
        
        // 회원 상세 정보 조회
        String sql = "SELECT * FROM members WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(memberIdStr));
        
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            String username = rs.getString("username");
            String businessName = rs.getString("business_name");
            String representativeName = rs.getString("representative_name");
            String email = rs.getString("email");
            String phone = rs.getString("phone");
            String address = rs.getString("address");
            Timestamp createdAt = rs.getTimestamp("created_at");
            Timestamp updatedAt = rs.getTimestamp("updated_at");
            boolean isAdmin = rs.getBoolean("is_admin");
            boolean isActive = rs.getBoolean("is_active");
            %>
            <div class="member-detail">
                <div class="detail-section">
                    <h4>기본 정보</h4>
                    <div class="detail-grid">
                        <div class="detail-item">
                            <label>회원 ID:</label>
                            <span><%= memberIdStr %></span>
                        </div>
                        <div class="detail-item">
                            <label>아이디:</label>
                            <span><%= username %></span>
                        </div>
                        <div class="detail-item">
                            <label>상호명:</label>
                            <span><%= businessName != null ? businessName : "-" %></span>
                        </div>
                        <div class="detail-item">
                            <label>대표자명:</label>
                            <span><%= representativeName != null ? representativeName : "-" %></span>
                        </div>
                    </div>
                </div>
                
                <div class="detail-section">
                    <h4>연락처 정보</h4>
                    <div class="detail-grid">
                        <div class="detail-item">
                            <label>이메일:</label>
                            <span><%= email %></span>
                        </div>
                        <div class="detail-item">
                            <label>전화번호:</label>
                            <span><%= phone != null ? phone : "-" %></span>
                        </div>
                        <div class="detail-item">
                            <label>주소:</label>
                            <span><%= address != null ? address : "-" %></span>
                        </div>
                        <div class="detail-item">
                            <label>계정 상태:</label>
                            <span class="status-badge <%= isActive ? "status-active" : "status-inactive" %>">
                                <%= isActive ? "활성" : "비활성" %>
                            </span>
                        </div>
                    </div>
                </div>
                
                <div class="detail-section">
                    <h4>권한 및 가입 정보</h4>
                    <div class="detail-grid">
                        <div class="detail-item">
                            <label>관리자 권한:</label>
                            <span class="status-badge <%= isAdmin ? "status-admin" : "status-user" %>">
                                <%= isAdmin ? "관리자" : "일반회원" %>
                            </span>
                        </div>
                        <div class="detail-item">
                            <label>가입일:</label>
                            <span><%= createdAt != null ? createdAt.toString() : "-" %></span>
                        </div>
                        <div class="detail-item">
                            <label>최종 수정일:</label>
                            <span><%= updatedAt != null ? updatedAt.toString() : "-" %></span>
                        </div>
                        <div class="detail-item">
                            <label>비밀번호:</label>
                            <span style="color: #999;">••••••••</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <style>
                .member-detail {
                    max-width: 100%;
                }
                
                .detail-section {
                    margin-bottom: 20px;
                    padding: 15px;
                    background: #f8f9fa;
                    border-radius: 8px;
                }
                
                .detail-section h4 {
                    margin: 0 0 15px 0;
                    color: #333;
                    font-size: 16px;
                    font-weight: 600;
                }
                
                .detail-grid {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 10px;
                }
                
                .detail-item {
                    display: flex;
                    flex-direction: column;
                    gap: 4px;
                }
                
                .detail-item label {
                    font-weight: 600;
                    color: #666;
                    font-size: 12px;
                }
                
                .detail-item span {
                    color: #333;
                    font-size: 14px;
                    word-break: break-all;
                }
                
                .status-badge {
                    display: inline-block;
                    padding: 4px 8px;
                    border-radius: 12px;
                    font-size: 12px;
                    font-weight: 500;
                    text-align: center;
                    min-width: 60px;
                }
                
                .status-active {
                    background-color: #d1fae5;
                    color: #065f46;
                }
                
                .status-inactive {
                    background-color: #fee2e2;
                    color: #991b1b;
                }
                
                .status-admin {
                    background-color: #dbeafe;
                    color: #1e40af;
                }
                
                .status-user {
                    background-color: #f3f4f6;
                    color: #374151;
                }
                
                @media (max-width: 480px) {
                    .detail-grid {
                        grid-template-columns: 1fr;
                    }
                    
                    .detail-section {
                        padding: 10px;
                    }
                    
                    .detail-section h4 {
                        font-size: 14px;
                    }
                    
                    .detail-item label {
                        font-size: 11px;
                    }
                    
                    .detail-item span {
                        font-size: 13px;
                    }
                }
            </style>
            <%
        } else {
            out.print("<p style='color: var(--red-500);'>회원 정보를 찾을 수 없습니다.</p>");
        }
        
    } catch (SQLException e) {
        out.print("<p style='color: var(--red-500);'>회원 정보를 가져오는 중 오류가 발생했습니다.</p>");
        e.printStackTrace();
    } catch (NumberFormatException e) {
        out.print("<p style='color: var(--red-500);'>잘못된 회원 ID입니다.</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
        if (conn != null) try { conn.close(); } catch (SQLException e) { }
    }
%>
