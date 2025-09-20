<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>

<%@ page import="java.util.*" %>
<%
    // JSON 응답을 위한 설정
    response.setContentType("application/json; charset=UTF-8");
    
    // 상품 ID 파라미터 가져오기
    String productIdParam = request.getParameter("id");
    int productId = 0;
    
    if (productIdParam != null && !productIdParam.trim().isEmpty()) {
        try {
            productId = Integer.parseInt(productIdParam);
        } catch (NumberFormatException e) {
            // 잘못된 ID인 경우
        }
    }
    
    Map<String, Object> result = new HashMap<>();
    
    if (productId > 0) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            
            // 상품 정보 조회 (카테고리 정보 및 detail_images 포함)
            String sql = "SELECT p.id, p.name, p.description, p.price, p.image_url, p.stock_quantity, " +
                        "p.subcategory_id, c.name as category_name, p.detail_images " +
                        "FROM products p " +
                        "LEFT JOIN categories c ON p.category_id = c.id " +
                        "WHERE p.id = ? AND p.is_active = 1";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, productId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String productName = rs.getString("name");
                String description = rs.getString("description");
                int price = rs.getInt("price");
                String imageUrl = rs.getString("image_url");
                int stockQuantity = rs.getInt("stock_quantity");
                int subcategoryId = rs.getInt("subcategory_id");
                String categoryName = rs.getString("category_name");
                String detailImagesJson = rs.getString("detail_images");
                

                
                // 이미지 URL 처리
                if (imageUrl == null || imageUrl.trim().isEmpty()) {
                    imageUrl = "img/products/default.png";
                } else {
                    String fileName = imageUrl;
                    if (imageUrl.indexOf("/") != -1) {
                        fileName = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);
                    }
                    imageUrl = "img/products/" + fileName;
                }
                
                // 카테고리 정보 설정
                String subcategoryName = "";
                switch (subcategoryId) {
                    case 1: subcategoryName = "돼지고기"; break;
                    case 2: subcategoryName = "소고기"; break;
                    default: subcategoryName = "기타"; break;
                }
                
                // 결과 데이터 구성
                Map<String, Object> productData = new HashMap<>();
                productData.put("id", productId);
                productData.put("name", productName);
                productData.put("description", description);
                productData.put("price", price);
                productData.put("image_url", imageUrl);
                productData.put("stock_quantity", stockQuantity);
                productData.put("category_name", categoryName != null ? categoryName : "기본");
                productData.put("subcategory_name", subcategoryName);
                
                // JSON 응답을 직접 구성하여 최상위 레벨에 모든 정보 포함
                StringBuilder json = new StringBuilder();
                json.append("{");
                json.append("\"success\":true,");
                json.append("\"id\":").append(productId).append(",");
                json.append("\"name\":\"").append(productName.replace("\"", "\\\"")).append("\",");
                
                if (description != null && !description.trim().isEmpty()) {
                    // 특수 문자 이스케이프 처리
                    description = description.replace("\\", "\\\\")
                                           .replace("\"", "\\\"")
                                           .replace("\n", "\\n")
                                           .replace("\r", "\\r")
                                           .replace("\t", "\\t")
                                           .replace("\b", "\\b")
                                           .replace("\f", "\\f");
                    json.append("\"description\":\"").append(description).append("\",");
                } else {
                    json.append("\"description\":\"상품 설명이 없습니다.\",");
                }
                
                json.append("\"price\":").append(price).append(",");
                json.append("\"image_url\":\"").append(imageUrl.replace("\"", "\\\"")).append("\",");
                json.append("\"stock_quantity\":").append(stockQuantity).append(",");
                json.append("\"category_name\":\"").append((categoryName != null ? categoryName : "기본").replace("\"", "\\\"")).append("\",");
                json.append("\"subcategory_name\":\"").append(subcategoryName.replace("\"", "\\\"")).append("\",");
                json.append("\"detail_images\":").append(detailImagesJson != null ? detailImagesJson : "null");
                json.append("}");
                

                
                
                
                out.print(json.toString());
                return; // 여기서 종료
                

                
            } else {
                // 상품을 찾을 수 없는 경우
                StringBuilder json = new StringBuilder();
                json.append("{");
                json.append("\"success\":false,");
                json.append("\"message\":\"상품을 찾을 수 없습니다.\"");
                json.append("}");
                
                out.print(json.toString());
                return; // 여기서 종료
            }
            
        } catch (SQLException e) {
            // 데이터베이스 오류인 경우
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"success\":false,");
            json.append("\"message\":\"데이터베이스 오류가 발생했습니다.\"");
            json.append("}");
            
            out.print(json.toString());
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
            if (conn != null) DBUtil.closeConnection(conn);
        }
    } else {
        // 잘못된 상품 ID인 경우
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\":false,");
        json.append("\"message\":\"잘못된 상품 ID입니다.\"");
        json.append("}");
        
        out.print(json.toString());
    }
%> 