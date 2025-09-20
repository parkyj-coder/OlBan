<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="util.DBUtil" %>
<%
    // POST 요청만 처리
    if (!request.getMethod().equals("POST")) {
        response.setStatus(405);
        out.print("Method not allowed");
        return;
    }
    
    // 파라미터 받기
    String idStr = request.getParameter("id");
    
    // 필수 파라미터 검증
    if (idStr == null || idStr.trim().isEmpty()) {
        response.setStatus(400);
        out.print("상품 ID가 필요합니다.");
        return;
    }
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        conn = DBUtil.getConnection();
        
        // 먼저 상품 정보와 이미지 파일명 조회
        String selectSql = "SELECT image_url FROM products WHERE id = ?";
        pstmt = conn.prepareStatement(selectSql);
        pstmt.setInt(1, Integer.parseInt(idStr));
        rs = pstmt.executeQuery();
        
        String imageUrl = null;
        if (rs.next()) {
            imageUrl = rs.getString("image_url");
        }
        
        // 상품 삭제 쿼리
        String deleteSql = "DELETE FROM products WHERE id = ?";
        pstmt = conn.prepareStatement(deleteSql);
        pstmt.setInt(1, Integer.parseInt(idStr));
        
        int result = pstmt.executeUpdate();
        
        if (result > 0) {
            // 상품 삭제 성공 시 이미지 파일도 삭제
            if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                try {
                    // 웹 서버 배포 폴더와 프로젝트 폴더 경로 설정
                    String realPath = application.getRealPath("/");
                    String webServerDir = realPath + "img/products/";
                    String projectDir = realPath.substring(0, realPath.indexOf(".metadata")) + "OlBanFood\\src\\main\\webapp\\img\\products\\";
                    
                    // 웹 서버의 이미지 파일 삭제
                    File webServerFile = new File(webServerDir, imageUrl);
                    if (webServerFile.exists()) {
                        boolean webServerDeleted = webServerFile.delete();
                        System.out.println("웹 서버 이미지 파일 삭제: " + imageUrl + " - " + (webServerDeleted ? "성공" : "실패"));
                    }
                    
                    // 프로젝트 폴더의 이미지 파일 삭제
                    File projectFile = new File(projectDir, imageUrl);
                    if (projectFile.exists()) {
                        boolean projectDeleted = projectFile.delete();
                        System.out.println("프로젝트 이미지 파일 삭제: " + imageUrl + " - " + (projectDeleted ? "성공" : "실패"));
                    }
                    
                    System.out.println("=== 상품 삭제 완료 ===");
                    System.out.println("상품 ID: " + idStr);
                    System.out.println("이미지 파일: " + imageUrl);
                    System.out.println("===============================");
                    
                } catch (Exception e) {
                    System.err.println("이미지 파일 삭제 중 오류: " + e.getMessage());
                    // 이미지 파일 삭제 실패해도 상품 삭제는 성공으로 처리
                }
            }
            
            out.print("success");
        } else {
            response.setStatus(404);
            out.print("상품을 찾을 수 없습니다.");
        }
        
    } catch (SQLException e) {
        response.setStatus(500);
        out.print("데이터베이스 오류: " + e.getMessage());
        e.printStackTrace();
    } catch (NumberFormatException e) {
        response.setStatus(400);
        out.print("잘못된 상품 ID입니다.");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
        if (conn != null) try { conn.close(); } catch (SQLException e) { }
    }
%> 