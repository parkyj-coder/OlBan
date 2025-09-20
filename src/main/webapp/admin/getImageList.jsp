<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Arrays" %>
<%
    response.setContentType("application/json; charset=UTF-8");
    response.setCharacterEncoding("UTF-8");
    
    try {
        // 이미지 디렉토리 경로
        String realPath = application.getRealPath("/");
        String imageDir = realPath + "img/products/";
        File imageDirectory = new File(imageDir);
        
        List<String> imageList = new ArrayList<>();
        
        if (imageDirectory.exists() && imageDirectory.isDirectory()) {
            File[] files = imageDirectory.listFiles((dir, name) -> {
                String lowerCase = name.toLowerCase();
                return lowerCase.endsWith(".jpg") || lowerCase.endsWith(".jpeg") || 
                       lowerCase.endsWith(".png") || lowerCase.endsWith(".gif") || 
                       lowerCase.endsWith(".webp");
            });
            
            if (files != null) {
                // 파일명으로 정렬 (최신 파일이 먼저)
                Arrays.sort(files, (a, b) -> Long.compare(b.lastModified(), a.lastModified()));
                
                for (File file : files) {
                    if (file.isFile()) {
                        // 상대 경로로 저장 (img/products/ 제외)
                        String fileName = file.getName();
                        imageList.add(fileName);
                    }
                }
            }
        }
        
        // JSON 응답 생성
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\":true,");
        json.append("\"images\":[");
        
        for (int i = 0; i < imageList.size(); i++) {
            if (i > 0) json.append(",");
            json.append("\"").append(imageList.get(i).replace("\"", "\\\"")).append("\"");
        }
        
        json.append("],");
        json.append("\"total\":").append(imageList.size());
        json.append("}");
        
        out.print(json.toString());
        
    } catch (Exception e) {
        out.print("{\"success\":false,\"error\":\"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        e.printStackTrace();
    }
%>
