<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<%
    // 검색 파라미터 받기
    String searchTerm = request.getParameter("search");
    String categoryFilter = request.getParameter("category");
    String subcategoryFilter = request.getParameter("subcategory");
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        conn = DBUtil.getConnection();
        
        // 동적 쿼리 생성
        StringBuilder sqlBuilder = new StringBuilder();
        sqlBuilder.append("SELECT p.id, p.name, p.description, p.price, p.stock_quantity, p.image_url, p.is_active, p.created_at, p.subcategory_id, c.name as category_name ");
        sqlBuilder.append("FROM products p ");
        sqlBuilder.append("LEFT JOIN categories c ON p.category_id = c.id ");
        sqlBuilder.append("WHERE 1=1 ");
        
        // 검색 조건 추가
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sqlBuilder.append("AND (p.name LIKE ? OR p.description LIKE ?) ");
        }
        
        // 카테고리 필터 추가
        if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
            sqlBuilder.append("AND p.category_id = ? ");
        }
        
        // 하위분류 필터 추가
        if (subcategoryFilter != null && !subcategoryFilter.trim().isEmpty()) {
            sqlBuilder.append("AND p.subcategory_id = ? ");
        }
        
        sqlBuilder.append("ORDER BY p.created_at DESC");
        
        pstmt = conn.prepareStatement(sqlBuilder.toString());
        
        // 파라미터 바인딩
        int paramIndex = 1;
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            String searchPattern = "%" + searchTerm.trim() + "%";
            pstmt.setString(paramIndex++, searchPattern);
            pstmt.setString(paramIndex++, searchPattern);
        }
        if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
            pstmt.setInt(paramIndex++, Integer.parseInt(categoryFilter));
        }
        if (subcategoryFilter != null && !subcategoryFilter.trim().isEmpty()) {
            pstmt.setInt(paramIndex++, Integer.parseInt(subcategoryFilter));
        }
        
        rs = pstmt.executeQuery();
        
        while (rs.next()) {
            int productId = rs.getInt("id");
            String productName = rs.getString("name");
            String description = rs.getString("description");
            int price = rs.getInt("price");
            int stockQuantity = rs.getInt("stock_quantity");
            String imageUrl = rs.getString("image_url");
            boolean isActive = rs.getBoolean("is_active");
            Timestamp createdAt = rs.getTimestamp("created_at");
            String categoryName = rs.getString("category_name");
            int subcategoryId = rs.getInt("subcategory_id");
            
            // subcategory_id로 하위분류명 결정
            String subcategoryName = null;
            if (subcategoryId == 1) {
                subcategoryName = "돼지고기";
            } else if (subcategoryId == 2) {
                subcategoryName = "소고기";
            }
            
            // 상품명 표시용 처리 (긴 이름은 잘라서 표시)
            String displayProductName = productName;
            if (productName != null && productName.length() > 12) {
                displayProductName = productName.substring(0, 12) + "...";
            }
            
            // 이미지 URL 처리 - productMng.jsp와 동일한 로직
            String originalImageUrl = imageUrl;
            if (imageUrl == null || imageUrl.trim().isEmpty()) {
                imageUrl = "../img/products/default.png";
            } else {
                // 파일명만 추출하여 경로 구성
                String fileName = imageUrl;
                if (imageUrl.indexOf("/") != -1) {
                    fileName = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);
                }
                imageUrl = "../img/products/" + fileName;
            }
            
            // 디버깅: 이미지 URL 정보 출력
            System.out.println("=== 검색 결과 이미지 URL 디버깅 ===");
            System.out.println("상품 ID: " + productId);
            System.out.println("상품명: " + productName);
            System.out.println("원본 imageUrl: " + originalImageUrl);
            System.out.println("변환된 imageUrl: " + imageUrl);
            System.out.println("=====================================");
            %>
            <tr>
                <td><%= productId %></td>
                <td>
                    <img src="<%= imageUrl %>" alt="<%= productName %>" style="width: 50px; height: 50px; object-fit: cover; border-radius: 4px;" 
                         onerror="this.src='../img/products/default.png'; this.onerror=null;">
                </td>
                <td title="<%= productName %>"><%= displayProductName %></td>
                <td>
                    <%= categoryName != null ? categoryName : "-" %>
                    <% if (subcategoryName != null && !subcategoryName.trim().isEmpty()) { %>
                        <br><small style="color: #666;"><%= subcategoryName %></small>
                    <% } %>
                </td>
                <td>₩<%= String.format("%,d", price) %></td>
                <td><%= stockQuantity %></td>
                <td>
                    <span class="status-badge <% if (isActive) { %>status-active<% } else { %>status-inactive<% } %>">
                        <% if (isActive) { %>활성<% } else { %>비활성<% } %>
                    </span>
                </td>
                <td><%= createdAt.toString().substring(0, 10) %></td>
                <td>
                    <button class="admin-btn admin-btn-secondary" onclick="editProduct(<%= productId %>)">수정</button>
                    <button class="admin-btn admin-btn-danger" onclick="deleteProduct(<%= productId %>)" data-product-name="<%= productName %>">삭제</button>
                </td>
            </tr>
            <%
        }
        
    } catch (SQLException e) {
        %>
        <tr>
            <td colspan="9" style="text-align: center; color: var(--red-500);">
                검색 중 오류가 발생했습니다: <%= e.getMessage() %>
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