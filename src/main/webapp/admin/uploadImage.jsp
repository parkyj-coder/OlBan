<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="jakarta.servlet.http.Part" %>
<%@ page import="jakarta.servlet.annotation.MultipartConfig" %>

<%
    // JSON 응답을 위한 설정
    response.setContentType("application/json; charset=UTF-8");
    
    // POST 요청만 처리
    if (!request.getMethod().equals("POST")) {
        response.setStatus(405);
        out.print("{\"error\": \"Method not allowed\"}");
        return;
    }
    
    try {
        // 업로드 디렉토리 설정
        String realPath = application.getRealPath("/");
        String webServerDir = realPath + "img/products/";
        
        File webServerPath = new File(webServerDir);
        
        // 디렉토리가 없으면 생성
        if (!webServerPath.exists()) {
            boolean created = webServerPath.mkdirs();
            System.out.println("업로드 디렉토리 생성: " + webServerDir + " - " + (created ? "성공" : "실패"));
        }
        
        System.out.println("업로드 경로: " + webServerPath.getAbsolutePath());
        System.out.println("디렉토리 존재: " + webServerPath.exists());
        System.out.println("디렉토리 쓰기 권한: " + webServerPath.canWrite());
        
        // multipart/form-data 체크
        String contentType = request.getContentType();
        if (contentType == null || !contentType.toLowerCase().startsWith("multipart/form-data")) {
            response.setStatus(400);
            out.print("{\"error\": \"Multipart content required\"}");
            return;
        }
        
        // 파일 업로드 처리
        String uploadedFileName = null;
        
        // 모든 Part를 가져와서 파일인 것만 처리
        for (Part part : request.getParts()) {
            if (part.getSubmittedFileName() != null && !part.getSubmittedFileName().trim().isEmpty()) {
                String originalFileName = part.getSubmittedFileName();
                
                // 확장자 추출
                String extension = "";
                int lastDotIndex = originalFileName.lastIndexOf('.');
                if (lastDotIndex > 0) {
                    extension = originalFileName.substring(lastDotIndex);
                }
                
                // 고유한 파일명 생성
                String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
                String uniqueFileName = "product_" + timestamp + extension;
                File webServerFile = new File(webServerPath, uniqueFileName);
                
                // 파일 저장 (웹서버 경로에만 저장)
                try (InputStream input = part.getInputStream();
                     FileOutputStream webServerOutput = new FileOutputStream(webServerFile)) {
                    
                    byte[] buffer = new byte[8192]; // 버퍼 크기 증가
                    int bytesRead;
                    long totalBytesRead = 0;
                    
                    while ((bytesRead = input.read(buffer)) != -1) {
                        webServerOutput.write(buffer, 0, bytesRead);
                        totalBytesRead += bytesRead;
                    }
                    
                    // 모바일에서 파일 크기가 0인 경우 재검증
                    if (totalBytesRead == 0) {
                        webServerFile.delete();
                        response.setStatus(400);
                        out.print("{\"error\": \"업로드된 파일이 비어있습니다.\"}");
                        return;
                    }
                    
                    // 파일 저장 확인
                    if (!webServerFile.exists() || webServerFile.length() == 0) {
                        response.setStatus(500);
                        out.print("{\"error\": \"파일 저장에 실패했습니다.\"}");
                        return;
                    }
                }
                
                uploadedFileName = uniqueFileName;
                
                // 디버깅 정보
                System.out.println("=== 이미지 업로드 성공 ===");
                System.out.println("원본 파일명: " + originalFileName);
                System.out.println("저장된 파일명: " + uniqueFileName);
                System.out.println("저장 경로: " + webServerFile.getAbsolutePath());
                System.out.println("파일 크기: " + webServerFile.length() + " bytes");
                System.out.println("파일 존재: " + webServerFile.exists());
                System.out.println("===============================");
                
                break; // 첫 번째 파일만 처리
            }
        }
        
        // 결과 반환
        if (uploadedFileName != null) {
            out.print("{\"success\": true, \"filename\": \"" + uploadedFileName + "\", \"url\": \"" + uploadedFileName + "\"}");
        } else {
            response.setStatus(400);
            out.print("{\"error\": \"업로드할 파일을 찾을 수 없습니다.\"}");
        }
        
    } catch (Exception e) {
        response.setStatus(500);
        out.print("{\"error\": \"서버 오류: " + e.getMessage() + "\"}");
        e.printStackTrace();
    }
%> 