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
    
    // 디버깅: 모든 파라미터 출력
    System.out.println("=== updateProduct.jsp 파라미터 디버깅 ===");
    java.util.Enumeration<String> paramNames = request.getParameterNames();
    while (paramNames.hasMoreElements()) {
        String paramName = paramNames.nextElement();
        String paramValue = request.getParameter(paramName);
        System.out.println(paramName + ": " + paramValue);
    }
    System.out.println("=====================================");
    
    String idStr = request.getParameter("id");
    String name = request.getParameter("name");
    String description = request.getParameter("description");
    String priceStr = request.getParameter("price");
    String stockQuantityStr = request.getParameter("stock_quantity");
    String categoryIdStr = request.getParameter("category_id");
    String subcategoryIdStr = request.getParameter("subcategory_id");
    String imageUrl = request.getParameter("image_url");
    String additionalImagesJson = request.getParameter("additional_images");
    String isActiveStr = request.getParameter("is_active");
    
    // 필수 파라미터 검증
    if (idStr == null || idStr.trim().isEmpty() ||
        name == null || name.trim().isEmpty() || 
        priceStr == null || priceStr.trim().isEmpty() ||
        stockQuantityStr == null || stockQuantityStr.trim().isEmpty()) {
        out.print("필수 파라미터가 누락되었습니다. (id: " + idStr + ", name: " + name + ", price: " + priceStr + ", stock: " + stockQuantityStr + ")");
        return;
    }
    
    // 숫자 형식 검증
    try {
        int id = Integer.parseInt(idStr.trim());
        int price = Integer.parseInt(priceStr.trim());
        int stockQuantity = Integer.parseInt(stockQuantityStr.trim());
        
        if (id <= 0) {
            out.print("유효하지 않은 상품 ID입니다.");
            return;
        }
        
        if (price < 0 || stockQuantity < 0) {
            out.print("가격과 재고 수량은 0 이상이어야 합니다.");
            return;
        }
    } catch (NumberFormatException e) {
        out.print("ID, 가격, 재고 수량은 숫자로 입력해주세요.");
        return;
    }
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        conn = DBUtil.getConnection();
        
        // 상품 수정 쿼리 (detail_images 컬럼 포함)
        String sql = "UPDATE products SET name=?, description=?, price=?, stock_quantity=?, category_id=?, subcategory_id=?, image_url=?, detail_images=?, is_active=? WHERE id=?";
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
        
        // is_active 처리: 체크박스가 체크되지 않으면 null이므로 false로 처리
        boolean isActive = false;
        if (isActiveStr != null && (isActiveStr.equals("on") || isActiveStr.equals("true"))) {
            isActive = true;
        }
        pstmt.setBoolean(9, isActive);
        pstmt.setInt(10, Integer.parseInt(idStr));
        
        int result = pstmt.executeUpdate();
        
        if (result > 0) {
            out.print("success");
        } else {
            out.print("상품을 찾을 수 없습니다.");
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