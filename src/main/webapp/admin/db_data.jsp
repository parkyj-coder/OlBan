<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<%
// 관리자 권한 확인
String adminId = (String) session.getAttribute("adminId");
if (adminId == null) {
    out.println("<div style='color: red; text-align: center; padding: 40px;'>관리자 권한이 필요합니다.</div>");
    return;
}

// 테이블명 파라미터 받기
String tableName = request.getParameter("table");
if (tableName == null || tableName.trim().isEmpty()) {
    out.println("<div style='color: red; text-align: center; padding: 40px;'>테이블명이 지정되지 않았습니다.</div>");
    return;
}

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
ResultSetMetaData metaData = null;

try {
            conn = DBUtil.getConnection();
    
    // 테이블명에 따른 SQL 쿼리 생성
    String sql = "";
    String tableTitle = "";
    
    switch (tableName) {
        case "members":
            sql = "SELECT id, username, name, email, phone, representative_name, business_name, business_number, address, created_at, is_admin FROM members ORDER BY id DESC";
            tableTitle = "회원 테이블";
            break;
        case "products":
            sql = "SELECT p.id, p.name, p.description, p.price, p.stock_quantity, p.image_url, p.is_active, " +
                  "c.name as category_name, p.subcategory_id, p.created_at " +
                  "FROM products p " +
                  "LEFT JOIN categories c ON p.category_id = c.id " +
                  "ORDER BY p.id DESC";
            tableTitle = "상품 테이블";
            break;
        case "categories":
            sql = "SELECT id, name, description, created_at FROM categories ORDER BY id";
            tableTitle = "카테고리 테이블";
            break;
        case "subcategories":
            sql = "SELECT sc.id, sc.name, sc.description, c.name as category_name, sc.created_at " +
                  "FROM subcategories sc " +
                  "LEFT JOIN categories c ON sc.category_id = c.id " +
                  "ORDER BY sc.id";
            tableTitle = "서브카테고리 테이블";
            break;
        case "orders":
            sql = "SELECT o.id, o.member_id, m.name as member_name, o.total_amount, o.status, o.order_date, o.delivery_address " +
                  "FROM orders o " +
                  "LEFT JOIN members m ON o.member_id = m.id " +
                  "ORDER BY o.id DESC";
            tableTitle = "주문 테이블";
            break;
        case "order_items":
            sql = "SELECT oi.id, oi.order_id, oi.product_id, p.name as product_name, oi.quantity, oi.price, oi.total_price " +
                  "FROM order_items oi " +
                  "LEFT JOIN products p ON oi.product_id = p.id " +
                  "ORDER BY oi.order_id DESC, oi.id";
            tableTitle = "주문 상품 테이블";
            break;
        case "inquiries":
            sql = "SELECT i.id, i.member_id, m.name as member_name, i.subject, i.content, i.status, i.created_at " +
                  "FROM inquiries i " +
                  "LEFT JOIN members m ON i.member_id = m.id " +
                  "ORDER BY i.id DESC";
            tableTitle = "문의 테이블";
            break;
        default:
            out.println("<div style='color: red; text-align: center; padding: 40px;'>지원하지 않는 테이블입니다: " + tableName + "</div>");
            return;
    }
    
    pstmt = conn.prepareStatement(sql);
    rs = pstmt.executeQuery();
    metaData = rs.getMetaData();
    int columnCount = metaData.getColumnCount();
    
    // 테이블 헤더 출력
    out.println("<div class='data-table'>");
    out.println("<h3>" + tableTitle + "</h3>");
    out.println("<div class='table-container'>");
    out.println("<table>");
    
    // 컬럼 헤더 출력
    out.println("<thead><tr>");
    for (int i = 1; i <= columnCount; i++) {
        String columnName = metaData.getColumnName(i);
        String displayName = getDisplayName(columnName);
        out.println("<th>" + displayName + "</th>");
    }
    out.println("</tr></thead>");
    
    // 데이터 행 출력
    out.println("<tbody>");
    boolean hasData = false;
    while (rs.next()) {
        hasData = true;
        out.println("<tr>");
        for (int i = 1; i <= columnCount; i++) {
            String columnName = metaData.getColumnName(i);
            String value = rs.getString(i);
            
            // 특별한 컬럼 처리
            if (columnName.equals("is_active") || columnName.equals("is_admin")) {
                if ("1".equals(value) || "true".equals(value)) {
                    out.println("<td><span class='status-active'>활성</span></td>");
                } else {
                    out.println("<td><span class='status-inactive'>비활성</span></td>");
                }
            } else if (columnName.equals("image_url") && value != null && !value.trim().isEmpty()) {
                out.println("<td><img src='../img/products/" + value + "' alt='상품 이미지' class='image-preview'></td>");
            } else if (columnName.equals("price") || columnName.equals("total_amount") || columnName.equals("total_price")) {
                if (value != null && !value.trim().isEmpty()) {
                    try {
                        int price = Integer.parseInt(value);
                        out.println("<td>₩" + String.format("%,d", price) + "</td>");
                    } catch (NumberFormatException e) {
                        out.println("<td>" + value + "</td>");
                    }
                } else {
                    out.println("<td>-</td>");
                }
            } else if (columnName.equals("created_at") || columnName.equals("order_date")) {
                if (value != null && !value.trim().isEmpty()) {
                    out.println("<td>" + value.substring(0, 19) + "</td>");
                } else {
                    out.println("<td>-</td>");
                }
            } else {
                out.println("<td>" + (value != null ? value : "-") + "</td>");
            }
        }
        out.println("</tr>");
    }
    
    if (!hasData) {
        out.println("<tr><td colspan='" + columnCount + "' class='no-data'>데이터가 없습니다.</td></tr>");
    }
    
    out.println("</tbody>");
    out.println("</table>");
    out.println("</div>");
    out.println("</div>");
    
} catch (Exception e) {
    out.println("<div style='color: red; text-align: center; padding: 40px;'>데이터 조회 중 오류 발생: " + e.getMessage() + "</div>");
} finally {
    if (rs != null) rs.close();
    if (pstmt != null) pstmt.close();
    if (conn != null) conn.close();
}

// 컬럼명을 한글로 변환하는 함수
%>
<%!
private String getDisplayName(String columnName) {
    switch (columnName) {
        case "id": return "ID";
        case "username": return "아이디";
        case "name": return "이름";
        case "email": return "이메일";
        case "phone": return "전화번호";
        case "representative_name": return "대표자명";
        case "business_name": return "사업자명";
        case "business_number": return "사업자번호";
        case "address": return "주소";
        case "created_at": return "생성일";
        case "is_admin": return "관리자";
        case "description": return "설명";
        case "price": return "가격";
        case "stock_quantity": return "재고수량";
        case "image_url": return "이미지";
        case "is_active": return "상태";
        case "category_name": return "카테고리";
        case "subcategory_name": return "서브카테고리";
        case "member_id": return "회원ID";
        case "member_name": return "회원명";
        case "total_amount": return "총 금액";
        case "status": return "상태";
        case "order_date": return "주문일";
        case "delivery_address": return "배송주소";
        case "order_id": return "주문ID";
        case "product_id": return "상품ID";
        case "product_name": return "상품명";
        case "quantity": return "수량";
        case "total_price": return "총 가격";
        case "subject": return "제목";
        case "content": return "내용";
        default: return columnName;
    }
}
%> 