<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<%
    // POST 요청만 처리
    if (!request.getMethod().equals("POST")) {
        response.setStatus(405);
        out.print("Method not allowed");
        return;
    }
    
    // 파라미터 받기
    request.setCharacterEncoding("UTF-8");
    String name = request.getParameter("name");
    String description = request.getParameter("description");
    String priceStr = request.getParameter("price");
    String stockQuantityStr = request.getParameter("stock_quantity");
    String categoryIdStr = request.getParameter("category_id");
    String subcategoryIdStr = request.getParameter("subcategory_id");
    String imageUrl = request.getParameter("image_url");
    String isActiveStr = request.getParameter("is_active");
    String additionalImagesJson = request.getParameter("additional_images");
    
    // 필수 파라미터 검증
    if (name == null || name.trim().isEmpty() || 
        priceStr == null || priceStr.trim().isEmpty() ||
        stockQuantityStr == null || stockQuantityStr.trim().isEmpty()) {
        out.print("필수 파라미터가 누락되었습니다.");
        return;
    }
    
    // 숫자 형식 검증
    try {
        int price = Integer.parseInt(priceStr.trim());
        int stockQuantity = Integer.parseInt(stockQuantityStr.trim());
        
        if (price < 0 || stockQuantity < 0) {
            out.print("가격과 재고 수량은 0 이상이어야 합니다.");
            return;
        }
    } catch (NumberFormatException e) {
        out.print("가격과 재고 수량은 숫자로 입력해주세요.");
        return;
    }
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        conn = DBUtil.getConnection();
        
        // 상품 추가 쿼리 (detail_images 컬럼 포함)
        String sql = "INSERT INTO products (name, description, price, stock_quantity, category_id, subcategory_id, image_url, detail_images, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        
        pstmt.setString(1, name.trim());
        pstmt.setString(2, description != null ? description.trim() : null);
        pstmt.setInt(3, Integer.parseInt(priceStr));
        pstmt.setInt(4, Integer.parseInt(stockQuantityStr));
        
        if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
            pstmt.setInt(5, Integer.parseInt(categoryIdStr));
        } else {
            pstmt.setNull(5, Types.INTEGER);
        }
        
        if (subcategoryIdStr != null && !subcategoryIdStr.trim().isEmpty()) {
            pstmt.setInt(6, Integer.parseInt(subcategoryIdStr));
        } else {
            pstmt.setNull(6, Types.INTEGER);
        }
        
        pstmt.setString(7, imageUrl != null ? imageUrl.trim() : null);
        
        // detail_images 컬럼에 추가 이미지 JSON 저장
        pstmt.setString(8, additionalImagesJson != null ? additionalImagesJson.trim() : null);
        
        pstmt.setBoolean(9, isActiveStr != null && isActiveStr.equals("on"));
        
        int result = pstmt.executeUpdate();
        
        if (result > 0) {
            out.print("success");
        } else {
            out.print("상품 추가에 실패했습니다.");
        }
        
    } catch (SQLException e) {
        out.print("데이터베이스 오류: " + e.getMessage());
        e.printStackTrace();
    } catch (NumberFormatException e) {
        out.print("잘못된 숫자 형식입니다.");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
        if (conn != null) try { conn.close(); } catch (SQLException e) { }
    }
%> 