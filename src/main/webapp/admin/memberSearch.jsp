<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<%
    String searchTerm = request.getParameter("search");
    
    if (searchTerm == null || searchTerm.trim().isEmpty()) {
        out.print("<tr><td colspan='8' style='text-align: center; color: var(--red-500);'>검색어를 입력해주세요.</td></tr>");
        return;
    }
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        conn = DBUtil.getConnection();
        
        // 회원 검색 쿼리
        String sql = "SELECT id, username, business_name, representative_name, email, phone, created_at, is_active " +
                   "FROM members " +
                   "WHERE username LIKE ? OR business_name LIKE ? OR representative_name LIKE ? OR email LIKE ? " +
                   "ORDER BY created_at DESC";
        
        pstmt = conn.prepareStatement(sql);
        String searchPattern = "%" + searchTerm.trim() + "%";
        pstmt.setString(1, searchPattern);
        pstmt.setString(2, searchPattern);
        pstmt.setString(3, searchPattern);
        pstmt.setString(4, searchPattern);
        
        rs = pstmt.executeQuery();
        
        boolean hasResults = false;
        while (rs.next()) {
            hasResults = true;
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
        
        if (!hasResults) {
            out.print("<tr><td colspan='8' style='text-align: center; color: var(--gray-500);'>검색 결과가 없습니다.</td></tr>");
        }
        
    } catch (SQLException e) {
        out.print("<tr><td colspan='8' style='text-align: center; color: var(--red-500);'>검색 중 오류가 발생했습니다.</td></tr>");
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
        if (conn != null) try { conn.close(); } catch (SQLException e) { }
    }
%>
