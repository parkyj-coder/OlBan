<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<jsp:include page="../common/adminCheck.jsp" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 관리 - 올반푸드</title>
    <link rel="icon" type="image/x-icon" href="../img/logo.png">
    <link rel="stylesheet" href="../css/main.css">
    <link rel="stylesheet" href="css/admin.css">
    <style>
        /* 체크박스 스타일 우선 적용 */
        .admin-form .checkbox-label {
            display: flex ;
            align-items: center ;
            color: var(--gray-700) ;
            font-weight: 500 ;
        }
        
        /* 이미지 업로드 컨테이너 스타일 */
        .image-upload-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
            width: 100%;
        }
        
        .image-preview {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 200px;
            border: 2px dashed #ddd;
            border-radius: 12px;
            background-color: #f8f9fa;
            padding: 20px;
            width: 100%;
            box-sizing: border-box;
        }
        
        .image-preview img {
            max-width: 100%;
            max-height: 180px;
            object-fit: cover;
            border-radius: 8px;
        }
        
        .image-upload-controls {
            display: flex;
            flex-direction: column;
            gap: 16px;
            width: 100%;
        }
        
        .upload-buttons {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            width: 100%;
        }
        
        .upload-action-buttons {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            width: 100%;
        }
        
        /* 추가 이미지 관리 스타일 */
        .additional-images-container {
            margin-top: 16px;
            width: 100%;
        }
        
        .additional-images-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 12px;
            margin-bottom: 16px;
            min-height: 60px;
            padding: 16px;
            border: 2px dashed #ddd;
            border-radius: 12px;
            background-color: #f8f9fa;
            width: 100%;
            box-sizing: border-box;
        }
        
        .additional-images-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            min-height: 100px;
        }
        
        .additional-image-item {
            position: relative;
            display: flex;
            flex-direction: column;
            align-items: center;
            background: white;
            border-radius: 8px;
            padding: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: transform 0.2s;
            min-width: 120px;
        }
        
        .additional-image-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        
        .additional-image-preview {
            position: relative;
            width: 100%;
            height: 100px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f0f0f0;
            border-radius: 6px;
            overflow: hidden;
        }
        
        .additional-image-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 6px;
        }
        
        .additional-image-overlay {
            position: absolute;
            top: 5px;
            right: 5px;
            background: #ff4444;
            color: white;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            transition: background 0.2s;
        }
        
        .additional-image-info {
            margin-top: 8px;
            text-align: center;
            width: 100%;
        }
        
        .image-name {
            display: block;
            font-size: 12px;
            color: #666;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            margin-bottom: 4px;
        }
        
        .image-status {
            display: block;
            font-size: 11px;
            padding: 2px 6px;
            border-radius: 10px;
            font-weight: bold;
        }
        
        .image-status.uploaded {
            background: #d4edda;
            color: #155724;
        }
        
        .image-status.pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .additional-image-remove {
            position: absolute;
            top: 5px;
            right: 5px;
            background: rgba(220, 38, 38, 0.9);
            color: white;
            border: none;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 12px;
        }
        
        .additional-image-status {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: rgba(0,0,0,0.7);
            color: white;
            text-align: center;
            padding: 4px;
            font-size: 11px;
        }
        
        .additional-image-controls {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr 1fr;
            gap: 12px;
            width: 100%;
        }
        
        .image-path-input {
            width: 100%;
            padding: 10px 12px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 14px;
            background-color: #f8f9fa;
            color: #6c757d;
            margin-bottom: 12px;
        }
        
        .image-path-input:focus {
            outline: none;
            border-color: var(--primary-color);
            background-color: white;
            color: var(--gray-700);
        }
        
        /* 모달 레이아웃 개선 */
        .product-modal-content {
            max-width: 700px;
            max-height: 90vh;
            overflow-y: auto;
            margin: 20px auto;
        }
        
        .product-form {
            display: flex;
            flex-direction: column;
            gap: 24px;
            width: 100%;
        }
        
        /* 섹션 스타일 */
        .form-section {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 24px;
            border: 1px solid #e9ecef;
            width: 100%;
            box-sizing: border-box;
        }
        
        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--gray-800);
            margin: 0 0 20px 0;
            padding-bottom: 8px;
            border-bottom: 2px solid var(--primary-color);
            text-align: left;
        }
        
        /* 이미지 섹션 스타일 */
        .image-section {
            margin-bottom: 24px;
            width: 100%;
        }
        
        .image-section:last-child {
            margin-bottom: 0;
        }
        
        .image-section-title {
            font-size: 16px;
            font-weight: 500;
            color: var(--gray-700);
            margin: 0 0 16px 0;
            text-align: left;
        }
        
        /* 폼 그룹 정렬 개선 */
        .form-group {
            margin-bottom: 20px;
            width: 100%;
        }
        
        .form-group:last-child {
            margin-bottom: 0;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--gray-700);
            text-align: left;
        }
        
        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 14px;
            box-sizing: border-box;
        }
        
        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--primary-color);
        }
        
        /* 폼 행 정렬 */
        .form-row {
            display: flex;
            gap: 16px;
            width: 100%;
        }
        
        .form-col {
            flex: 1;
            min-width: 0;
        }
        
        /* 버튼 중앙 정렬 */
        .admin-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 12px 16px;
            border-radius: 8px;
            font-weight: 500;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s ease;
            border: none;
            min-height: 44px;
            box-sizing: border-box;
        }
        
        .admin-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
        
        .admin-btn:active {
            transform: translateY(0);
        }
        
        /* 모달 푸터 정렬 */
        .modal-footer {
            display: flex;
            justify-content: center;
            gap: 16px;
            padding: 20px 24px;
            border-top: 1px solid #e9ecef;
            background: white;
            border-radius: 0 0 12px 12px;
        }
        
        .modal-btn {
            min-width: 120px;
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 500;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s ease;
            border: none;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .modal-btn-primary {
            background: var(--primary-color);
            color: white;
        }
        
        .modal-btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
        
        .modal-btn-secondary {
            background: var(--gray-200);
            color: var(--gray-700);
        }
        
        .modal-btn-secondary:hover {
            background: var(--gray-300);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        
        /* 데스크탑과 모바일 텍스트 구분 */
        .desktop-text {
            display: inline;
        }
        
        .mobile-text {
            display: none;
        }
        
        /* 모바일에서 텍스트 표시 */
        @media (max-width: 768px) {
            .desktop-text {
                display: none;
            }
            
            .mobile-text {
                display: inline;
            }
        }
        
        /* 데스크탑에서 카메라 버튼 숨기기 */
        .camera-btn {
            display: inline-block;
        }
        
        /* 모바일 최적화 */
        @media (max-width: 768px) {
            .product-modal-content {
                max-width: 95vw;
                margin: 5px;
                max-height: 95vh;
                padding: 0;
            }
            
            .form-section {
                padding: 15px;
            }
            
            .section-title {
                font-size: 16px;
                margin-bottom: 16px;
            }
            
            .form-group {
                margin-bottom: 16px;
            }
            
            .form-row {
                flex-direction: column;
                gap: 0;
            }
            
            .form-col {
                margin-bottom: 16px;
            }
            
            .form-col:last-child {
                margin-bottom: 0;
            }
            
            .image-preview {
                min-height: 150px;
                padding: 16px;
            }
            
            .image-preview img {
                max-height: 120px;
            }
            
            .upload-buttons {
                grid-template-columns: 1fr 1fr ;
                gap: 8px ;
            }
            
            .upload-action-buttons {
                grid-template-columns: 1fr 1fr ;
                gap: 8px ;
            }
            
            .additional-images-list {
                grid-template-columns: repeat(2, 1fr) ;
                gap: 8px ;
                padding: 8px ;
            }
            
            .additional-image-controls {
                grid-template-columns: 1fr 1fr ;
                gap: 8px ;
            }
            
            .modal-footer {
                flex-direction: column;
                gap: 12px;
                padding: 16px 20px;
            }
            
            .modal-btn {
                width: 100%;
                min-width: auto;
            }
            
            /* 모바일에서 텍스트 변경 */
            .desktop-text {
                display: none;
            }
            
            .mobile-text {
                display: inline;
            }
        }
        
        /* 데스크탑에서 카메라 버튼 숨기기 */
        @media (min-width: 769px) {
            .camera-btn {
                display: none ;
            }
            
            /* 데스크탑에서 버튼 레이아웃 조정 */
            .upload-buttons {
                grid-template-columns: 1fr ;
            }
            
            .additional-image-controls {
                grid-template-columns: 1fr 1fr ;
            }
        }
        
        
        /* 이미지 갤러리 스타일 */
        .image-gallery-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
            gap: 15px;
            padding: 10px;
        }
        
        .gallery-image-item {
            position: relative;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            cursor: pointer;
            border: 2px solid transparent;
        }
        
        .gallery-image-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 16px rgba(0,0,0,0.2);
            border-color: #007bff;
        }
        
        .gallery-image-item.selected {
            border-color: #28a745;
            background: #f8fff9;
        }
        
        .gallery-image-preview {
            width: 100%;
            height: 120px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f8f9fa;
            overflow: hidden;
        }
        
        .gallery-image-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        
        .gallery-image-item:hover .gallery-image-preview img {
            transform: scale(1.05);
        }
        
        .gallery-image-info {
            padding: 8px;
            text-align: center;
        }
        
        .gallery-image-name {
            font-size: 12px;
            color: #666;
            word-break: break-all;
            line-height: 1.2;
        }
        
        .gallery-image-actions {
            position: absolute;
            top: 5px;
            right: 5px;
            display: flex;
            gap: 5px;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .gallery-image-item:hover .gallery-image-actions {
            opacity: 1;
        }
        
        .gallery-action-btn {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: bold;
            transition: all 0.2s ease;
        }
        
        .gallery-select-btn {
            background: #28a745;
            color: white;
        }
        
        .gallery-select-btn:hover {
            background: #218838;
        }
        
        .gallery-select-btn.selected {
            background: #dc3545;
        }
        
        .gallery-select-btn.selected:hover {
            background: #c82333;
        }
        
        .additional-image-info {
            margin-top: 5px;
            text-align: center;
            font-size: 12px;
        }
        
        .image-name {
            display: block;
            color: #666;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 100px;
        }
        
        .image-status {
            display: block;
            margin-top: 2px;
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 10px;
            font-weight: bold;
        }
        
        .image-status.pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .image-status.uploaded {
            background: #d4edda;
            color: #155724;
        }
        
        .additional-image-controls {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .additional-image-controls button {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.2s;
        }
        
        .additional-image-controls .admin-btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .additional-image-controls .admin-btn-secondary:hover {
            background: #545b62;
        }
        
        .additional-image-controls .admin-btn-danger {
            background: #dc3545;
            color: white;
        }
        
        .additional-image-controls .admin-btn-danger:hover {
            background: #c82333;
        }
        
        /* 이미지 제거 버튼 스타일 */
        .admin-btn-remove {
            background: linear-gradient(135deg, #ff6b6b, #ee5a52) ;
            color: white ;
            border: none ;
            padding: 8px 16px ;
            border-radius: 6px ;
            font-size: 14px ;
            font-weight: 500 ;
            cursor: pointer ;
            transition: all 0.3s ease ;
            box-shadow: 0 2px 4px rgba(255, 107, 107, 0.3) ;
            position: relative ;
            overflow: hidden ;
        }
        
        .admin-btn-remove:hover {
            background: linear-gradient(135deg, #ff5252, #e53935) ;
            transform: translateY(-1px) ;
            box-shadow: 0 4px 8px rgba(255, 107, 107, 0.4) ;
        }
        
        .admin-btn-remove:active {
            transform: translateY(0) ;
            box-shadow: 0 2px 4px rgba(255, 107, 107, 0.3) ;
        }
        
        .admin-btn-remove::before {
            content: '🗑️';
            margin-right: 6px;
            font-size: 12px;
        }
        
        /* 개별 이미지 제거 버튼 스타일 */
        .remove-image-btn {
            background: linear-gradient(135deg, #ff4757, #ff3742) ;
            color: white ;
            border: none ;
            border-radius: 50% ;
            width: 24px ;
            height: 24px ;
            display: flex ;
            align-items: center ;
            justify-content: center ;
            cursor: pointer ;
            font-size: 14px ;
            font-weight: bold ;
            transition: all 0.2s ease ;
            box-shadow: 0 2px 4px rgba(255, 71, 87, 0.3) ;
        }
        
        .remove-image-btn:hover {
            background: linear-gradient(135deg, #ff3742, #ff2f3a) ;
            transform: scale(1.1) ;
            box-shadow: 0 3px 6px rgba(255, 71, 87, 0.4) ;
        }
        
        .remove-image-btn:active {
            transform: scale(0.95) ;
        }
        
        /* 업로드 버튼 그룹 스타일 개선 */
        .upload-buttons {
            display: flex ;
            gap: 10px ;
            align-items: center ;
            flex-wrap: wrap ;
        }
        
        .upload-buttons .admin-btn {
            flex: 1;
            min-width: 120px;
            text-align: center;
            min-height: 44px; /* 모바일 터치 최소 크기 */
            padding: 12px 16px;
        }
        
        .upload-buttons .admin-btn-remove {
            flex: 1;
            min-width: 140px;
            min-height: 44px; /* 모바일 터치 최소 크기 */
        }
        
        /* 모바일 반응형 스타일 */
        @media (max-width: 768px) {
            .modal-content {
                max-width: 95vw ;
                margin: 10px ;
                max-height: 95vh ;
            }
            
            .upload-buttons {
                flex-direction: column;
                gap: 8px;
            }
            
            .upload-buttons .admin-btn {
                width: 100%;
                min-width: auto;
                min-height: 48px; /* 모바일에서 더 큰 터치 영역 */
                font-size: 16px; /* 모바일에서 더 큰 폰트 */
            }
            
            .form-row {
                flex-direction: column;
            }
            
            .form-row .form-group {
                width: 100%;
                margin-bottom: 15px;
            }
            
            .additional-image-controls {
                flex-direction: column;
                gap: 8px;
            }
            
            /* 모바일 이미지 업로드 최적화 */
            .image-upload-container {
                gap: 12px;
            }
            
            .image-preview {
                min-height: 150px;
                padding: 15px;
            }
            
            .image-preview img {
                max-width: 150px;
                max-height: 150px;
            }
            
            .upload-buttons {
                grid-template-columns: 1fr 1fr ;
                gap: 8px ;
            }
            
            .upload-action-buttons {
                grid-template-columns: 1fr 1fr ;
                gap: 8px ;
            }
            
            
            .additional-images-list {
                grid-template-columns: repeat(2, 1fr) ;
                gap: 10px ;
                padding: 8px ;
            }
            
            .additional-image-item {
                min-width: auto ;
            }
            
            .additional-image-preview {
                height: 100px ;
            }
            
            .additional-image-preview img {
                width: 100% ;
                height: 100% ;
            }
            
            .additional-image-controls {
                grid-template-columns: 1fr 1fr ;
                gap: 8px ;
            }
            
            .additional-image-controls .admin-btn {
                width: 100%;
                min-height: 48px;
                font-size: 16px;
                padding: 12px 16px;
            }
            
            /* 상품 목록 테이블 모바일 최적화 */
            .admin-table {
                overflow-x: auto;
                -webkit-overflow-scrolling: touch;
            }
            
            .admin-table table {
                min-width: 700px;
                width: 100%;
                border-collapse: collapse;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            
            .admin-table th,
            .admin-table td {
                padding: 8px 4px;
                font-size: 14px;
                white-space: nowrap;
                border: 1px solid #dee2e6;
                text-align: center;
                vertical-align: middle;
            }
            
            .admin-table th {
                text-align: center;
                font-weight: 600;
                background-color: #f8f9fa;
                border-bottom: 2px solid #dee2e6;
            }
            
            .admin-table tbody tr:nth-child(even) {
                background-color: #f8f9fa;
            }
            
            .admin-table tbody tr:hover {
                background-color: #e9ecef;
                transition: background-color 0.2s;
            }
            
            .admin-table th:nth-child(1),
            .admin-table td:nth-child(1) {
                width: 50px;
                min-width: 50px;
            }
            
            .admin-table th:nth-child(2),
            .admin-table td:nth-child(2) {
                width: 80px;
                min-width: 80px;
            }
            
            .admin-table th:nth-child(3),
            .admin-table td:nth-child(3) {
                width: 180px;
                min-width: 180px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                max-width: 180px;
                text-align: center;
            }
            
            .admin-table th:nth-child(4),
            .admin-table td:nth-child(4) {
                width: 80px;
                min-width: 80px;
                white-space: nowrap;
                text-align: center;
            }
            
            .admin-table th:nth-child(5),
            .admin-table td:nth-child(5) {
                width: 100px;
                min-width: 100px;
                white-space: nowrap;
                text-align: center;
            }
            
            .admin-table th:nth-child(6),
            .admin-table td:nth-child(6) {
                width: 60px;
                min-width: 60px;
                white-space: nowrap;
                text-align: center;
            }
            
            .admin-table th:nth-child(7),
            .admin-table td:nth-child(7) {
                width: 100px;
                min-width: 100px;
                white-space: nowrap;
            }
            
            .product-image {
                width: 60px;
                height: 60px;
                object-fit: cover;
                border-radius: 4px;
            }
            
            .action-buttons {
                display: flex;
                flex-direction: column;
                gap: 4px;
            }
            
            .action-buttons a {
                padding: 4px 8px;
                font-size: 12px;
                text-align: center;
                border-radius: 4px;
                text-decoration: none;
                display: block;
            }
            
            .edit-btn {
                background-color: #007bff;
                color: white;
            }
            
            .delete-btn {
                background-color: #dc3545;
                color: white;
            }
            
            .status-active {
                background-color: #28a745;
                color: white;
                padding: 2px 6px;
                border-radius: 12px;
                font-size: 11px;
            }
            
            .status-inactive {
                background-color: #6c757d;
                color: white;
                padding: 2px 6px;
                border-radius: 12px;
                font-size: 11px;
            }
        }
        
        /* 더 작은 화면 (480px 이하) */
        @media (max-width: 480px) {
            .admin-table table {
                min-width: 600px;
                border-radius: 6px;
            }
            
            .admin-table th,
            .admin-table td {
                padding: 6px 2px;
                font-size: 12px;
                border: 1px solid #dee2e6;
            }
            
            .admin-table th:nth-child(3),
            .admin-table td:nth-child(3) {
                width: 150px;
                min-width: 150px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                max-width: 150px;
                text-align: center;
            }
            
            .product-image {
                width: 50px;
                height: 50px;
            }
            
            /* 480px 이하 화면 이미지 업로드 최적화 */
            .image-preview {
                min-height: 120px ;
                padding: 10px ;
            }
            
            .image-preview img {
                max-width: 120px ;
                max-height: 120px ;
            }
            
            .additional-images-list {
                grid-template-columns: 1fr ;
                gap: 8px ;
                padding: 10px ;
            }
            
            .additional-image-preview {
                height: 80px ;
            }
            
            .upload-buttons {
                grid-template-columns: 1fr ;
                gap: 8px ;
            }
            
            .upload-action-buttons {
                grid-template-columns: 1fr ;
                gap: 8px ;
            }
            
            .additional-image-controls {
                grid-template-columns: 1fr 1fr ;
                gap: 8px ;
            }
            
            .upload-buttons {
                grid-template-columns: 1fr ;
                gap: 8px ;
            }
            
            .upload-action-buttons {
                grid-template-columns: 1fr ;
                gap: 8px ;
            }
            
            .additional-images-list {
                grid-template-columns: 1fr ;
                gap: 8px ;
                padding: 10px ;
            }
            
            .image-preview {
                min-height: 120px ;
                padding: 10px ;
            }
            
            .image-preview img {
                max-height: 100px ;
            }
        }
        
        @media (max-width: 360px) {
            .additional-image-controls {
                grid-template-columns: 1fr ;
                gap: 8px ;
            }
            
            .admin-btn {
                font-size: 12px ;
                padding: 8px 10px ;
            }
        }
            cursor: pointer ;
            margin-bottom: 0 ;
            line-height: 1.5 ;
            width: fit-content ;
            max-width: none ;
            position: relative ;
        }
        
        .admin-form .checkbox-label input[type="checkbox"] {
            margin-right: 8px ;
            transform: scale(1.3) ;
            margin-top: 0 ;
            margin-bottom: 0 ;
            flex-shrink: 0 ;
            position: relative ;
            z-index: 1 ;
        }
        
        .admin-form .checkbox-label span {
            line-height: 1.5 ;
            white-space: nowrap ;
            flex-shrink: 0 ;
            position: relative ;
            z-index: 1 ;
            margin-left: 0 ;
            margin-right: 0 ;
        }
        
        /* 체크박스가 있는 form-group 특별 처리 */
        .admin-form .form-group:has(.checkbox-label) {
            display: flex ;
            justify-content: flex-start ;
            align-items: center ;
        }
        
        .admin-form .form-group .checkbox-label {
            margin: 0 ;
            padding: 0 ;
        }
        
        @media (max-width: 768px) {
            .admin-form .checkbox-label {
                align-items: flex-start ;
                padding-top: var(--spacing-1) ;
            }
            
            .admin-form .checkbox-label input[type="checkbox"] {
                transform: scale(1.2) ;
                margin-top: 2px ;
                margin-right: 8px ;
            }
            
            .admin-form .checkbox-label span {
                line-height: 1.4 ;
            }
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <!-- 관리자 헤더 -->
        <jsp:include page="common/adminHeader.jsp" />

        <main class="admin-main">
            <div class="page-header">
                <h1>상품 관리</h1>
                <p>등록된 상품들을 관리할 수 있습니다.</p>
            </div>
            
            <!-- 검색 및 필터 -->
            <div class="search-filter">
                <div class="search-filter-content">
                    <div class="search-group">
                        <label for="searchInput">상품 검색</label>
                        <input type="text" id="searchInput" placeholder="상품명으로 검색...">
                    </div>
                    <div class="filter-group">
                        <select id="categoryFilter">
                            <option value="">전체 카테고리</option>
                            <option value="1">국산</option>
                            <option value="2">수입</option>
                        </select>
                        <select id="subcategoryFilter">
                            <option value="">전체 하위분류</option>
                        </select>
                        <button class="admin-btn admin-btn-primary" onclick="searchProducts()">검색</button>
                        <button class="admin-btn admin-btn-secondary" onclick="resetSearch()">초기화</button>
                        <button class="admin-btn admin-btn-product" onclick="showAddProductForm()">+ 새 상품 추가</button>
                    </div>
                </div>
            </div>
            
            <!-- 상품 목록 테이블 -->
            <div class="admin-table">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>이미지</th>
                            <th>상품명</th>
                            <th>카테고리</th>
                            <th>가격</th>
                            <th>재고</th>
                            <th>상태</th>
                            <th>등록일</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody id="productTableBody">
                        <%
                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;
                        
                        try {
                            conn = DBUtil.getConnection();
                            
                            // 상품 목록 조회
                            String sql = "SELECT p.id, p.name, p.description, p.price, p.stock_quantity, p.image_url, p.is_active, p.created_at, p.subcategory_id, c.name as category_name " +
                                       "FROM products p " +
                                       "LEFT JOIN categories c ON p.category_id = c.id " +
                                       "ORDER BY p.created_at DESC";
                            
                            pstmt = conn.prepareStatement(sql);
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
                                
                                // 상품명 길이 제한 (모바일 최적화)
                                String displayProductName = productName;
                                if (productName != null && productName.length() > 12) {
                                    displayProductName = productName.substring(0, 12) + "...";
                                }
                                
                                // 이미지 URL 처리 - 간단하고 확실한 방식
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
                                System.out.println("=== 이미지 URL 디버깅 ===");
                                System.out.println("상품 ID: " + productId);
                                System.out.println("상품명: " + productName);
                                System.out.println("원본 imageUrl: " + rs.getString("image_url"));
                                System.out.println("변환된 imageUrl: " + imageUrl);
                                System.out.println("===============================");
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
                                    상품 정보를 불러오는 중 오류가 발생했습니다.
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
                    </tbody>
                </table>
            </div>
        </main>
    </div>
    
    <!-- 상품 추가/수정 모달 -->
    <div id="productModal" class="custom-modal">
        <div class="modal-content product-modal-content">
            <div class="modal-header">
                <h3 id="productModalTitle">새 상품 추가</h3>
                <button class="modal-close" onclick="closeProductModal()">&times;</button>
            </div>
            <div class="modal-body">
                <form id="productForm" class="admin-form product-form">
                    <input type="hidden" id="productId" name="id">
                    
                    <!-- 기본 정보 섹션 -->
                    <div class="form-section">
                        <h4 class="section-title">📝 기본 정보</h4>
                        <div class="form-group">
                            <label for="productName">상품명 *</label>
                            <input type="text" id="productName" name="name" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="productDescription">상품 설명</label>
                            <textarea id="productDescription" name="description" rows="3"></textarea>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="productPrice">가격 *</label>
                                    <input type="number" id="productPrice" name="price" min="0" step="1" required 
                                           oninput="validateNumber(this)" placeholder="숫자만 입력" 
                                           inputmode="numeric" pattern="[0-9]*">
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="productStock">재고 수량 *</label>
                                    <input type="number" id="productStock" name="stock_quantity" min="0" step="1" required 
                                           oninput="validateNumber(this)" placeholder="숫자만 입력"
                                           inputmode="numeric" pattern="[0-9]*">
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="productCategory">상위 카테고리</label>
                                    <select id="productCategory" name="category_id" onchange="updateSubcategory()">
                                        <option value="">카테고리 선택</option>
                                        <option value="1">국산</option>
                                        <option value="2">수입</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="productSubcategory">하위 카테고리</label>
                                    <select id="productSubcategory" name="subcategory_id">
                                        <option value="">하위분류 선택</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- 이미지 섹션 -->
                    <div class="form-section">
                        <h4 class="section-title">🖼️ 이미지 관리</h4>
                        
                        <!-- 메인 이미지 -->
                        <div class="image-section">
                            <h5 class="image-section-title">📷 메인 이미지</h5>
                            <div class="image-upload-container">
                                <div class="image-preview" id="imagePreview">
                                    <img id="previewImg" src="../img/products/default.png" alt="상품 이미지 미리보기">
                                </div>
                                <div class="image-upload-controls">
                                <input type="file" id="imageFile" accept="image/jpeg,image/jpg,image/png,image/gif,image/webp" style="display: none;">
                                <input type="file" id="imageFileCamera" accept="image/jpeg,image/jpg,image/png,image/gif,image/webp" style="display: none;" capture="camera">
                                    <input type="text" id="productImage" name="image_url" placeholder="img/products/상품명.png" class="image-path-input">
                                    <div class="upload-buttons">
                                        <button type="button" class="admin-btn admin-btn-secondary" onclick="selectFromGallery()">
                                            <span class="desktop-text">📁 파일 선택</span>
                                            <span class="mobile-text">📁 앨범에서 선택</span>
                                        </button>
                                        <button type="button" class="admin-btn admin-btn-secondary camera-btn" onclick="selectFromCamera()">
                                            📷 카메라로 촬영
                                        </button>
                                        <button type="button" class="admin-btn admin-btn-secondary" onclick="openImageGallery('main')">
                                            <span class="desktop-text">🗂️ 서버 이미지</span>
                                            <span class="mobile-text">🗂️ 서버 이미지</span>
                                        </button>
                                    </div>
                                    <div class="upload-action-buttons">
                                        <button type="button" class="admin-btn admin-btn-primary" onclick="uploadMainImage()" id="uploadMainBtn" disabled>
                                            ⬆️ 메인 이미지 업로드
                                        </button>
                                        <button type="button" class="admin-btn admin-btn-remove" onclick="clearImage()">
                                            제거
                                        </button>
                                    </div>
                                    <div id="uploadProgress" style="display: none; margin-top: 10px;">
                                        <div class="progress-bar">
                                            <div class="progress-fill" id="progressFill"></div>
                                        </div>
                                        <div id="uploadStatus">업로드 중...</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- 추가 이미지 -->
                        <div class="image-section">
                            <h5 class="image-section-title">🖼️ 추가 이미지 (최대 5개)</h5>
                            <div class="additional-images-container">
                                <div id="additionalImagesList" class="additional-images-list">
                                    <!-- 추가 이미지들이 여기에 동적으로 추가됩니다 -->
                                </div>
                                <div class="additional-image-controls">
                                    <input type="file" id="additionalImageFile" accept="image/*" multiple style="display: none;" onchange="handleAdditionalImages(this)">
                                    <input type="file" id="additionalImageFileCamera" accept="image/*" multiple style="display: none;" onchange="handleAdditionalImages(this)" capture="camera">
                                    <button type="button" class="admin-btn admin-btn-secondary" onclick="selectAdditionalFromGallery()">
                                        <span class="desktop-text">📁 파일 선택</span>
                                        <span class="mobile-text">📁 앨범에서 선택</span>
                                    </button>
                                    <button type="button" class="admin-btn admin-btn-secondary camera-btn" onclick="selectAdditionalFromCamera()">
                                        📷 카메라로 촬영
                                    </button>
                                    <button type="button" class="admin-btn admin-btn-secondary" onclick="openImageGallery('additional')" style="background: #6c757d;">
                                        <span class="desktop-text">🗂️ 서버 이미지</span>
                                        <span class="mobile-text">🗂️ 서버 이미지</span>
                                    </button>
                                    <button type="button" class="admin-btn admin-btn-primary" onclick="uploadAdditionalImages()" id="uploadAdditionalBtn" disabled>
                                        ⬆️ 추가 이미지 업로드
                                    </button>
                                    <button type="button" class="admin-btn admin-btn-remove" onclick="clearAllAdditionalImages()">
                                        모두 제거
                                    </button>
                                    <button type="button" class="admin-btn admin-btn-secondary" onclick="testAdditionalImages()" style="background: #28a745;">
                                        테스트 이미지
                                    </button>
                                    <button type="button" class="admin-btn admin-btn-secondary" onclick="debugAdditionalImages()" style="background: #17a2b8;">
                                        디버깅
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- 설정 섹션 -->
                    <div class="form-section">
                        <h4 class="section-title">⚙️ 설정</h4>
                        <div class="form-group">
                            <label class="checkbox-label">
                                <input type="checkbox" id="productActive" name="is_active" checked>
                                <span>활성 상태</span>
                            </label>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="modal-btn modal-btn-primary" onclick="saveProduct()">저장</button>
                <button class="modal-btn modal-btn-secondary" onclick="closeProductModal()">취소</button>
            </div>
    </div>
</div>

<!-- 이미지 갤러리 모달 -->
<div id="imageGalleryModal" class="modal" style="display: none;">
    <div class="modal-content" style="max-width: 90%; max-height: 90%; overflow-y: auto;">
        <div class="modal-header">
            <h3>서버 이미지 갤러리</h3>
            <span class="close" onclick="closeImageGallery()">&times;</span>
        </div>
        <div class="modal-body">
            <div style="margin-bottom: 20px;">
                <button onclick="refreshImageGallery()" class="btn btn-secondary">새로고침</button>
                <button onclick="applySelectedImages()" class="btn btn-primary" style="margin-left: 10px;">선택한 이미지 적용</button>
                <span id="imageCount" style="margin-left: 10px; color: #666;"></span>
            </div>
            <div id="imageGalleryGrid" class="image-gallery-grid">
                <!-- 이미지들이 여기에 동적으로 로드됩니다 -->
            </div>
        </div>
    </div>
</div>

<script>
        // 상품 목록 로드 (전체 목록)
        function loadProducts() {
            // AJAX로 전체 상품 목록 가져오기
            fetch('productSearch.jsp')
                .then(response => response.text())
                .then(html => {
                    document.getElementById('productTableBody').innerHTML = html;
                })
                .catch(error => {
                    console.error('상품 목록 로드 오류:', error);
                    alert('상품 목록을 불러오는 중 오류가 발생했습니다.');
                });
        }
        
        // 상품 검색
        function searchProducts() {
            const searchTerm = document.getElementById('searchInput').value.trim();
            const categoryFilter = document.getElementById('categoryFilter').value;
            const subcategoryFilter = document.getElementById('subcategoryFilter').value;
            
            // AJAX로 검색 결과 가져오기
            fetch('productSearch.jsp?search=' + encodeURIComponent(searchTerm) + '&category=' + categoryFilter + '&subcategory=' + subcategoryFilter)
                .then(response => response.text())
                .then(html => {
                    document.getElementById('productTableBody').innerHTML = html;
                })
                .catch(error => {
                    console.error('검색 오류:', error);
                    alert('검색 중 오류가 발생했습니다.');
                });
        }
        
        // 검색 초기화
        function resetSearch() {
            document.getElementById('searchInput').value = '';
            document.getElementById('categoryFilter').value = '';
            document.getElementById('subcategoryFilter').value = '';
            loadProducts(); // 전체 목록 다시 로드
        }
        
        // 새 상품 추가 폼 표시
        function showAddProductForm() {
            document.getElementById('productModalTitle').textContent = '새 상품 추가';
            document.getElementById('productForm').reset();
            document.getElementById('productId').value = '';
            
            // 추가 이미지 배열 초기화
            additionalImages = [];
            renderAdditionalImages();
            
            // 이미지 미리보기 초기화
            document.getElementById('previewImg').src = '../img/products/default.png';
            
            document.getElementById('productModal').style.display = 'block';
            document.body.style.overflow = 'hidden';
        }
        
        // 테스트용 함수 - 추가 이미지 미리보기 테스트
        function testAdditionalImages() {
            console.log('테스트 이미지 추가 시작');
            const testImages = [
                {
                    id: Date.now(),
                    file: null,
                    preview: '../img/products/default.png',
                    url: 'default.png',
                    uploaded: true
                },
                {
                    id: Date.now() + 1,
                    file: null,
                    preview: 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAwIiBoZWlnaHQ9IjEwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMTAwIiBoZWlnaHQ9IjEwMCIgZmlsbD0iIzAwN2JmZiIvPjx0ZXh0IHg9IjUwIiB5PSI1NSIgZm9udC1mYW1pbHk9IkFyaWFsIiBmb250LXNpemU9IjE0IiBmaWxsPSJ3aGl0ZSIgdGV4dC1hbmNob3I9Im1pZGRsZSI+VGVzdDwvdGV4dD48L3N2Zz4=',
                    url: 'test.svg',
                    uploaded: false
                },
                {
                    id: Date.now() + 2,
                    file: null,
                    preview: 'nonexistent.jpg', // 존재하지 않는 이미지 테스트
                    url: 'nonexistent.jpg',
                    uploaded: true
                }
            ];
            
            additionalImages = testImages;
            renderAdditionalImages();
            console.log('테스트 이미지 추가 완료');
        }
        
        // 추가 이미지 디버깅 함수
        function debugAdditionalImages() {
            console.log('=== 추가 이미지 디버깅 정보 ===');
            console.log('추가 이미지 개수:', additionalImages.length);
            additionalImages.forEach((img, index) => {
                console.log(`이미지 ${index + 1}:`, {
                    id: img.id,
                    preview: img.preview,
                    url: img.url,
                    uploaded: img.uploaded,
                    file: img.file ? img.file.name : '없음'
                });
            });
            console.log('===============================');
        }
        
        // 이미지 로드 에러 핸들링 함수
        function handleImageLoadError(imgElement, originalSrc, imageId) {
            console.error('❌ 이미지 로드 실패:', originalSrc);
            
            // 대체 경로들 시도
            const alternatives = [
                '../img/products/default.png',
                'img/products/default.png',
                '../img/products/' + originalSrc.split('/').pop(),
                'img/products/' + originalSrc.split('/').pop()
            ];
            
            let currentIndex = 0;
            
            function tryNextAlternative() {
                if (currentIndex >= alternatives.length) {
                    console.error('모든 대체 경로 실패, 기본 이미지로 설정');
                    imgElement.src = '../img/products/default.png';
                    imgElement.alt = '이미지를 불러올 수 없습니다';
                    return;
                }
                
                const altPath = alternatives[currentIndex];
                console.log(`대체 경로 ${currentIndex + 1} 시도:`, altPath);
                
                const testImg = new Image();
                testImg.onload = function() {
                    console.log('✅ 대체 경로 성공:', altPath);
                    imgElement.src = altPath;
                };
                testImg.onerror = function() {
                    console.log('❌ 대체 경로 실패:', altPath);
                    currentIndex++;
                    tryNextAlternative();
                };
                testImg.src = altPath;
            }
            
            tryNextAlternative();
        }
        
        // 이미지 경로 확인 함수
        function checkImagePath(imagePath) {
            const img = new Image();
            img.onload = function() {
                console.log('✅ 이미지 로드 성공:', imagePath);
            };
            img.onerror = function() {
                console.error('❌ 이미지 로드 실패:', imagePath);
                // 대체 경로들 시도
                const alternatives = [
                    '../img/products/' + imagePath,
                    'img/products/' + imagePath,
                    '../' + imagePath,
                    imagePath
                ];
                
                alternatives.forEach((alt, index) => {
                    const testImg = new Image();
                    testImg.onload = function() {
                        console.log(`✅ 대체 경로 ${index + 1} 성공:`, alt);
                    };
                    testImg.onerror = function() {
                        console.log(`❌ 대체 경로 ${index + 1} 실패:`, alt);
                    };
                    testImg.src = alt;
                });
            };
            img.src = imagePath;
        }
        
        // 이미지 갤러리 관련 변수
        let currentImageType = ''; // 'main' 또는 'additional'
        let selectedGalleryImages = new Set();
        
        // 이미지 갤러리 열기
        function openImageGallery(type) {
            currentImageType = type;
            selectedGalleryImages.clear();
            loadImageGallery();
            document.getElementById('imageGalleryModal').style.display = 'block';
            document.body.style.overflow = 'hidden';
        }
        
        // 이미지 갤러리 닫기
        function closeImageGallery() {
            document.getElementById('imageGalleryModal').style.display = 'none';
            document.body.style.overflow = 'auto';
            selectedGalleryImages.clear();
        }
        
        // 이미지 갤러리 로드
        async function loadImageGallery() {
            try {
                const response = await fetch('getImageList.jsp');
                const data = await response.json();
                
                if (data.success) {
                    renderImageGallery(data.images);
                    document.getElementById('imageCount').textContent = `총 ${data.total}개의 이미지`;
                } else {
                    console.error('이미지 목록 로드 실패:', data.error);
                    alert('이미지 목록을 불러오는데 실패했습니다.');
                }
            } catch (error) {
                console.error('이미지 갤러리 로드 오류:', error);
                alert('이미지 목록을 불러오는데 실패했습니다.');
            }
        }
        
        // 이미지 갤러리 새로고침
        function refreshImageGallery() {
            loadImageGallery();
        }
        
        // 이미지 갤러리 렌더링
        function renderImageGallery(images) {
            const container = document.getElementById('imageGalleryGrid');
            container.innerHTML = '';
            
            if (images.length === 0) {
                container.innerHTML = '<p style="text-align: center; color: #666; padding: 40px;">저장된 이미지가 없습니다.</p>';
                return;
            }
            
            images.forEach((imageName, index) => {
                const imageDiv = document.createElement('div');
                imageDiv.className = 'gallery-image-item';
                imageDiv.dataset.imageName = imageName;
                
                const imageUrl = '../img/products/' + imageName;
                
                imageDiv.innerHTML = `
                    <div class="gallery-image-preview">
                        <img src="${imageUrl}" alt="${imageName}" 
                             onerror="this.src='../img/products/default.png'">
                    </div>
                    <div class="gallery-image-info">
                        <div class="gallery-image-name">${imageName}</div>
                    </div>
                    <div class="gallery-image-actions">
                        <button class="gallery-action-btn gallery-select-btn" 
                                onclick="toggleImageSelection('${imageName}')" 
                                title="선택/해제">✓</button>
                    </div>
                `;
                
                container.appendChild(imageDiv);
            });
        }
        
        // 이미지 선택 토글
        function toggleImageSelection(imageName) {
            const imageItem = document.querySelector(`[data-image-name="${imageName}"]`);
            const selectBtn = imageItem.querySelector('.gallery-select-btn');
            
            if (selectedGalleryImages.has(imageName)) {
                // 선택 해제
                selectedGalleryImages.delete(imageName);
                imageItem.classList.remove('selected');
                selectBtn.textContent = '✓';
                selectBtn.classList.remove('selected');
            } else {
                // 선택 추가
                if (currentImageType === 'main') {
                    // 메인 이미지는 1개만 선택 가능
                    selectedGalleryImages.clear();
                    // 모든 선택 해제
                    document.querySelectorAll('.gallery-image-item').forEach(item => {
                        item.classList.remove('selected');
                        item.querySelector('.gallery-select-btn').classList.remove('selected');
                    });
                } else if (currentImageType === 'additional') {
                    // 추가 이미지는 최대 5개
                    if (selectedGalleryImages.size >= 5) {
                        alert('최대 5개의 이미지만 선택할 수 있습니다.');
                        return;
                    }
                }
                
                selectedGalleryImages.add(imageName);
                imageItem.classList.add('selected');
                selectBtn.textContent = '✕';
                selectBtn.classList.add('selected');
            }
        }
        
        // 선택된 이미지 적용
        function applySelectedImages() {
            if (selectedGalleryImages.size === 0) {
                alert('이미지를 선택해주세요.');
                return;
            }
            
            if (currentImageType === 'main') {
                // 메인 이미지 적용
                const imageName = Array.from(selectedGalleryImages)[0];
                document.getElementById('productImage').value = 'img/products/' + imageName;
                document.getElementById('previewImg').src = '../img/products/' + imageName;
                closeImageGallery();
            } else if (currentImageType === 'additional') {
                // 추가 이미지 적용
                const imageNames = Array.from(selectedGalleryImages);
                
                // 최대 개수 확인
                if (additionalImages.length + imageNames.length > maxAdditionalImages) {
                    alert(`최대 ${maxAdditionalImages}개의 추가 이미지만 업로드할 수 있습니다.`);
                    return;
                }
                
                imageNames.forEach((imageName, index) => {
                    // 이미지 경로 정규화
                    let imagePath = imageName;
                    if (imagePath && !imagePath.includes('img/products/')) {
                        imagePath = '../img/products/' + imagePath;
                    }
                    
                    const imageData = {
                        id: Date.now() + index,
                        file: null,
                        preview: imagePath,
                        url: imageName, // 원본 파일명 유지
                        uploaded: true // 서버에 이미 존재
                    };
                    
                    console.log('갤러리에서 선택한 이미지:', {
                        원본파일명: imageName,
                        처리된경로: imagePath
                    });
                    
                    additionalImages.push(imageData);
                });
                
                renderAdditionalImages();
                closeImageGallery();
            }
        }
        
        // 상품 수정
        function editProduct(productId) {
            console.log('editProduct 함수 호출됨, productId:', productId);
            
            // 모달 요소 존재 확인
            const modal = document.getElementById('productModal');
            if (!modal) {
                console.error('productModal 요소를 찾을 수 없습니다!');
                alert('모달 요소를 찾을 수 없습니다. 페이지를 새로고침해주세요.');
                return;
            }
            
            console.log('getProductInfo.jsp 요청 시작...');
            fetch('../getProductInfo.jsp?id=' + productId)
                .then(response => {
                    console.log('응답 상태:', response.status);
                    if (!response.ok) {
                        throw new Error('HTTP ' + response.status);
                    }
                    return response.text();
                })
                .then(data => {
                    console.log('받은 데이터:', data);
                    try {
                        const product = JSON.parse(data);
                        console.log('파싱된 상품 데이터:', product);
                        
                        // 에러 응답 체크
                        if (product.error) {
                            throw new Error(product.error);
                        }
                        
                        // 모달 요소들 존재 확인
                        const modalTitle = document.getElementById('productModalTitle');
                        const productIdField = document.getElementById('productId');
                        const productNameField = document.getElementById('productName');
                        const productDescriptionField = document.getElementById('productDescription');
                        const productPriceField = document.getElementById('productPrice');
                        const productStockField = document.getElementById('productStock');
                        const productCategoryField = document.getElementById('productCategory');
                        const productSubcategoryField = document.getElementById('productSubcategory');
                        const productImageField = document.getElementById('productImage');
                        const productActiveField = document.getElementById('productActive');
                        
                        if (!modalTitle || !productIdField || !productNameField || !productDescriptionField || 
                            !productPriceField || !productStockField || !productCategoryField || 
                            !productSubcategoryField || !productImageField || !productActiveField) {
                            throw new Error('모달 폼 요소를 찾을 수 없습니다.');
                        }
                        
                        modalTitle.textContent = '상품 수정';
                        productIdField.value = product.id;
                        productNameField.value = product.name;
                        productDescriptionField.value = product.description || '';
                        productPriceField.value = product.price;
                        productStockField.value = product.stock_quantity;
                        // 카테고리 먼저 설정
                        productCategoryField.value = product.category_id || '';
                        
                        // 하위 카테고리 업데이트 (옵션 생성) - 기존 값 보존
                        const savedSubcategoryValue = product.subcategory_id || '';
                        updateSubcategory();
                        productSubcategoryField.value = savedSubcategoryValue;
                        
                        productImageField.value = product.image_url || '';
                        productActiveField.checked = product.is_active === true || product.is_active === 'true';
                        
                        // 이미지 미리보기 설정
                        const previewImg = document.getElementById('previewImg');
                        if (product.image_url && product.image_url !== 'img/products/default.png') {
                            previewImg.src = '../' + product.image_url;
                        } else {
                            previewImg.src = '../img/products/default.png';
                        }
                        
                        // 추가 이미지 처리
                        console.log('원본 detail_images:', product.detail_images);
                        if (product.detail_images && product.detail_images !== 'null' && product.detail_images !== null) {
                            try {
                                // JSON 문자열인지 확인
                                let detailImages;
                                if (typeof product.detail_images === 'string') {
                                    detailImages = JSON.parse(product.detail_images);
                                } else {
                                    detailImages = product.detail_images;
                                }
                                
                                console.log('파싱된 추가 이미지 데이터:', detailImages);
                                if (Array.isArray(detailImages) && detailImages.length > 0) {
                                    additionalImages = detailImages.map((img, index) => {
                                        // 이미지 경로 정규화
                                        let imagePath = img;
                                        
                                        // 경로 정규화 로직 개선
                                        if (imagePath) {
                                            // 이미 완전한 경로인지 확인
                                            if (!imagePath.startsWith('http') && !imagePath.startsWith('/') && !imagePath.startsWith('../') && !imagePath.startsWith('data:')) {
                                                // 파일명만 있는 경우
                                                if (!imagePath.includes('img/products/')) {
                                                    imagePath = '../img/products/' + imagePath;
                                                }
                                            }
                                        } else {
                                            imagePath = '../img/products/default.png';
                                        }
                                        
                                        console.log(`이미지 ${index + 1} 경로 처리:`, {
                                            원본: img,
                                            처리됨: imagePath
                                        });
                                        
                                        return {
                                            id: Date.now() + index,
                                            file: null, // 기존 이미지는 파일 객체가 없음
                                            preview: imagePath,
                                            url: img, // 원본 파일명 유지
                                            uploaded: true // 이미 업로드된 상태
                                        };
                                    });
                                    console.log('생성된 추가 이미지 배열:', additionalImages);
                                    
                                    // 각 이미지 경로 테스트
                                    additionalImages.forEach((img, index) => {
                                        console.log(`이미지 ${index + 1} 경로 테스트:`, img.preview);
                                        checkImagePath(img.preview);
                                    });
                                    
                                    renderAdditionalImages();
                                } else {
                                    console.log('추가 이미지 배열이 비어있음');
                                    additionalImages = [];
                                    renderAdditionalImages();
                                }
                            } catch (e) {
                                console.error('추가 이미지 파싱 오류:', e);
                                console.error('파싱할 데이터:', product.detail_images);
                                additionalImages = [];
                                renderAdditionalImages();
                            }
                        } else {
                            console.log('추가 이미지 데이터 없음');
                            additionalImages = [];
                            renderAdditionalImages();
                        }
                        
                        console.log('모달 표시 중...');
                        modal.style.display = 'block';
                        document.body.style.overflow = 'hidden';
                        console.log('모달 표시 완료');
                        console.log('모달 display 스타일:', modal.style.display);
                        console.log('모달 z-index:', window.getComputedStyle(modal).zIndex);
                        console.log('모달 위치:', modal.getBoundingClientRect());
                    } catch (parseError) {
                        console.error('JSON 파싱 오류:', parseError);
                        console.error('받은 데이터:', data);
                        alert('상품 정보를 파싱하는 중 오류가 발생했습니다: ' + parseError.message);
                    }
                })
                .catch(error => {
                    console.error('상품 정보 가져오기 오류:', error);
                    alert('상품 정보를 가져오는 중 오류가 발생했습니다: ' + error.message);
                });
        }
        
        // 숫자 유효성 검사
        function validateNumber(input) {
            const value = input.value;
            if (value && !/^\d+$/.test(value)) {
                input.setCustomValidity('숫자만 입력해주세요.');
                input.reportValidity();
            } else {
                input.setCustomValidity('');
            }
        }
        
        // 상품 저장
        function saveProduct() {
            const form = document.getElementById('productForm');
            const productId = document.getElementById('productId').value;
            const url = productId ? 'updateProduct.jsp' : 'addProduct.jsp';
            
            // 클라이언트 측 유효성 검사
            const price = document.getElementById('productPrice').value;
            const stockQuantity = document.getElementById('productStock').value;
            
            if (!price || !stockQuantity) {
                alert('가격과 재고 수량을 입력해주세요.');
                return;
            }
            
            if (!/^\d+$/.test(price) || !/^\d+$/.test(stockQuantity)) {
                alert('가격과 재고 수량은 숫자만 입력해주세요.');
                return;
            }
            
            if (parseInt(price) < 0 || parseInt(stockQuantity) < 0) {
                alert('가격과 재고 수량은 0 이상이어야 합니다.');
                return;
            }
            
            // FormData 대신 URLSearchParams 사용
            const formData = new URLSearchParams();
            formData.append('id', document.getElementById('productId').value);
            formData.append('name', document.getElementById('productName').value);
            formData.append('description', document.getElementById('productDescription').value);
            formData.append('price', document.getElementById('productPrice').value);
            formData.append('stock_quantity', document.getElementById('productStock').value);
            formData.append('category_id', document.getElementById('productCategory').value);
            formData.append('subcategory_id', document.getElementById('productSubcategory').value);
            formData.append('image_url', document.getElementById('productImage').value);
            formData.append('is_active', document.getElementById('productActive').checked ? 'on' : 'off');
            
            // 디버깅: 전송할 데이터 확인
            console.log('전송할 데이터:');
            for (let [key, value] of formData.entries()) {
                console.log(key + ': ' + value);
            }
            
            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: formData.toString()
            })
            .then(response => {
                const status = response.status;
                return response.text().then(text => ({ status, text }));
            })
            .then(data => {
                console.log('응답 상태:', data.status);
                console.log('응답 내용:', data.text);
                
                if (data.status === 200 && data.text.trim() === 'success') {
                    alert(productId ? '상품이 수정되었습니다.' : '상품이 추가되었습니다.');
                    closeProductModal();
                    location.reload();
                } else {
                    alert('상품 저장 중 오류가 발생했습니다.\n상태: ' + data.status + '\n오류: ' + data.text);
                }
            })
            .catch(error => {
                console.error('저장 오류:', error);
                alert('상품 저장 중 오류가 발생했습니다: ' + error.message);
            });
        }
        
        // 상품 삭제
        function deleteProduct(productId) {
            // data-product-name 속성에서 상품명 가져오기
            const button = event.target;
            const productName = button.getAttribute('data-product-name') || '이 상품';
            
            if (confirm('정말로 "' + productName + '" 상품을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.')) {
                console.log('삭제 요청 시작 - 상품 ID:', productId, '상품명:', productName);
                
                fetch('deleteProduct.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'id=' + productId
                })
                .then(response => {
                    console.log('삭제 응답 상태:', response.status);
                    return response.text().then(text => ({ status: response.status, text: text }));
                })
                .then(data => {
                    console.log('삭제 응답 데이터:', data);
                    
                    if (data.status === 200 && data.text.trim() === 'success') {
                        alert('상품이 삭제되었습니다.');
                        location.reload();
                    } else {
                        alert('상품 삭제 중 오류가 발생했습니다.\n상태: ' + data.status + '\n오류: ' + data.text);
                    }
                })
                .catch(error => {
                    console.error('삭제 오류:', error);
                    alert('상품 삭제 중 오류가 발생했습니다: ' + error.message);
                });
            }
        }
        
        // 모달 닫기
        function closeProductModal() {
            document.getElementById('productModal').style.display = 'none';
            document.body.style.overflow = 'auto';
        }
        
        // 모달 외부 클릭 시 닫기
        document.getElementById('productModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeProductModal();
            }
        });
        
        // ESC 키로 모달 닫기
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeProductModal();
            }
        });
        
        // 엔터 키로 검색
        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchProducts();
            }
        });
        
         // 하위분류 옵션 로드
         function loadSubcategoryOptions() {
             const subcategoryFilter = document.getElementById('subcategoryFilter');
             if (subcategoryFilter) {
                 subcategoryFilter.innerHTML = '<option value="">전체 하위분류</option>' +
                     '<option value="1">돼지고기</option>' +
                     '<option value="2">소고기</option>';
             }
         }
        
        // 페이지 로드 시 디버깅 정보 출력
        console.log('상품관리 페이지 로드 완료');
        console.log('editProduct 함수 존재 여부:', typeof editProduct);
        console.log('productModal 요소 존재 여부:', !!document.getElementById('productModal'));
        
        // 페이지 로드 시 하위분류 옵션 로드
        document.addEventListener('DOMContentLoaded', function() {
            loadSubcategoryOptions();
        });
        
        // 테스트용 버튼 추가

        
        // 이미지 파일 선택 이벤트 (앨범에서 선택)
        document.getElementById('imageFile').addEventListener('change', function(e) {
            handleImageFileSelect(e);
        });
        
        // 이미지 파일 선택 이벤트 (카메라로 촬영)
        document.getElementById('imageFileCamera').addEventListener('change', function(e) {
            handleImageFileSelect(e);
        });
        
        // 공통 이미지 파일 선택 처리 함수
        function handleImageFileSelect(e) {
            const file = e.target.files[0];
            if (file) {
                // 파일 미리보기
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('previewImg').src = e.target.result;
                };
                reader.readAsDataURL(file);
                
                // 메인 이미지 업로드 버튼 활성화
                document.getElementById('uploadMainBtn').disabled = false;
            }
        }
        
        // 이미지 제거 함수
        function clearImage() {
            document.getElementById('imageFile').value = '';
            document.getElementById('imageFileCamera').value = '';
            document.getElementById('previewImg').src = '../img/products/default.png';
            document.getElementById('productImage').value = '';
            document.getElementById('uploadBtn').disabled = true;
            document.getElementById('uploadProgress').style.display = 'none';
        }
        
        // 카테고리 변경 시 하위 카테고리 업데이트
        function updateSubcategory() {
            const categorySelect = document.getElementById('productCategory');
            const subcategorySelect = document.getElementById('productSubcategory');
            const selectedCategory = categorySelect.value;
            
            // 현재 선택된 하위 카테고리 값 보존
            const currentSubcategoryValue = subcategorySelect.value;
            
            // 하위 카테고리 초기화
            subcategorySelect.innerHTML = '<option value="">하위분류 선택</option>';
            
            if (selectedCategory === '1' || selectedCategory === '2') { // 국산 또는 수입
                const options = [
                    { value: '1', text: '돼지고기' },
                    { value: '2', text: '소고기' }
                ];
                options.forEach(option => {
                    const optionElement = document.createElement('option');
                    optionElement.value = option.value;
                    optionElement.textContent = option.text;
                    subcategorySelect.appendChild(optionElement);
                });
                
                // 기존 값이 있으면 복원
                if (currentSubcategoryValue && currentSubcategoryValue !== '') {
                    subcategorySelect.value = currentSubcategoryValue;
                }
            }
        }
        
        // 이미지 선택 함수들 (카메라/앨범 구분)
        function selectFromGallery() {
            // 앨범 선택 - capture 속성 없음
            const fileInput = document.getElementById('imageFile');
            fileInput.click();
        }
        
        function selectFromCamera() {
            // 카메라 선택 - capture="camera"
            const fileInput = document.getElementById('imageFileCamera');
            fileInput.click();
        }
        
        function selectAdditionalFromGallery() {
            // 앨범 선택 - capture 속성 없음
            const fileInput = document.getElementById('additionalImageFile');
            fileInput.click();
        }
        
        function selectAdditionalFromCamera() {
            // 카메라 선택 - capture="camera"
            const fileInput = document.getElementById('additionalImageFileCamera');
            fileInput.click();
        }
        
        // 메인 이미지 업로드 함수
        async function uploadMainImage() {
            const fileInput = document.getElementById('imageFile');
            const fileInputCamera = document.getElementById('imageFileCamera');
            let file = fileInput.files[0] || fileInputCamera.files[0];
            
            if (!file) {
                alert('업로드할 파일을 선택해주세요.');
                return;
            }
            
            // 모바일에서 파일 크기가 0인 경우 체크
            if (file.size === 0) {
                alert('파일 크기가 0입니다. 파일을 다시 선택해주세요.');
                return;
            }
            
            // 모바일에서 파일 타입 재확인
            if (!file.type.startsWith('image/')) {
                alert('이미지 파일만 업로드 가능합니다.');
                return;
            }
            
            // 파일 크기 확인 (10MB 제한)
            if (file.size > 10 * 1024 * 1024) {
                alert('파일 크기가 너무 큽니다. (최대 10MB)');
                return;
            }
            
            // 업로드 진행률 표시
            const progressDiv = document.getElementById('uploadProgress');
            const progressFill = document.getElementById('progressFill');
            const uploadStatus = document.getElementById('uploadStatus');
            const uploadBtn = document.getElementById('uploadMainBtn');
            
            progressDiv.style.display = 'block';
            uploadBtn.disabled = true;
            uploadStatus.textContent = '메인 이미지 업로드 중...';
            
            try {
                // 메인 이미지 업로드
                const formData = new FormData();
                formData.append('image', file);
                
                // 모바일에서 타임아웃 설정
                const controller = new AbortController();
                const timeoutId = setTimeout(() => controller.abort(), 30000); // 30초 타임아웃
                
                const response = await fetch('uploadImage.jsp', {
                    method: 'POST',
                    body: formData,
                    signal: controller.signal
                });
                
                clearTimeout(timeoutId);
                
                if (!response.ok) {
                    const errorText = await response.text();
                    throw new Error(`업로드 실패 (${response.status}): ${errorText}`);
                }
                
                const data = await response.json();
                
                if (data.success) {
                    // 메인 이미지 업로드 성공
                    document.getElementById('productImage').value = data.url;
                    progressFill.style.width = '100%';
                    uploadStatus.textContent = '메인 이미지 업로드 완료!';
                    
                    console.log('업로드 성공:', data);
                    
                    // 파일이 실제로 존재하는지 확인
                    const testImg = new Image();
                    testImg.onload = function() {
                        alert('메인 이미지가 성공적으로 업로드되었습니다!');
                        
                        // 2초 후 진행률 숨기기
                        setTimeout(() => {
                            progressDiv.style.display = 'none';
                            uploadBtn.disabled = false;
                        }, 2000);
                    };
                    testImg.onerror = function() {
                        console.error('업로드된 이미지를 불러올 수 없습니다:', data.url);
                        alert('이미지 업로드는 완료되었지만 파일을 확인할 수 없습니다. 서버 로그를 확인해주세요.');
                        
                        setTimeout(() => {
                            progressDiv.style.display = 'none';
                            uploadBtn.disabled = false;
                        }, 2000);
                    };
                    testImg.src = '../img/products/' + data.url;
                    
                } else {
                    throw new Error(data.error || '메인 이미지 업로드 실패');
                }
                
            } catch (error) {
                progressDiv.style.display = 'none';
                uploadBtn.disabled = false;
                uploadStatus.textContent = '업로드 실패';
                
                console.error('Upload error:', error);
                
                // 모바일에서 자주 발생하는 에러 메시지 개선
                let errorMessage = '업로드 중 오류가 발생했습니다.';
                if (error.message.includes('NetworkError') || error.message.includes('Failed to fetch')) {
                    errorMessage = '네트워크 연결을 확인해주세요.';
                } else if (error.message.includes('413')) {
                    errorMessage = '파일 크기가 너무 큽니다.';
                } else if (error.message.includes('415')) {
                    errorMessage = '지원하지 않는 파일 형식입니다.';
                } else {
                    errorMessage = '업로드 중 오류가 발생했습니다: ' + error.message;
                }
                
                alert(errorMessage);
            }
        }
        
        // 추가 이미지 관리 변수
        let additionalImages = [];
        const maxAdditionalImages = 5;
        
        // 추가 이미지 처리 함수 (모바일 호환성 개선)
        function handleAdditionalImages(input) {
            try {
                const files = Array.from(input.files);
                
                // 최대 개수 확인
                if (additionalImages.length + files.length > maxAdditionalImages) {
                    alert(`최대 ${maxAdditionalImages}개의 추가 이미지만 업로드할 수 있습니다.`);
                    return;
                }
                
                // 파일 크기 확인 (모바일에서 큰 이미지 처리)
                const maxFileSize = 5 * 1024 * 1024; // 5MB
                const validFiles = files.filter(file => {
                    if (!file.type.startsWith('image/')) {
                        alert(`${file.name}은(는) 이미지 파일이 아닙니다.`);
                        return false;
                    }
                    if (file.size > maxFileSize) {
                        alert(`${file.name}은(는) 5MB를 초과합니다.`);
                        return false;
                    }
                    return true;
                });
                
                validFiles.forEach(file => {
                    // 모바일에서 파일 크기가 0인 경우 체크
                    if (file.size === 0) {
                        alert(`${file.name}의 파일 크기가 0입니다. 파일을 다시 선택해주세요.`);
                        return;
                    }
                    
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        try {
                            // 이미지 경로 정규화
                            let previewPath = e.target.result;
                            console.log('추가 이미지 미리보기 경로:', previewPath);
                            
                            const imageData = {
                                id: Date.now() + Math.random(),
                                file: file,
                                preview: previewPath,
                                uploaded: false,
                                url: null
                            };
                        
                            additionalImages.push(imageData);
                            renderAdditionalImages();
                            
                            // 추가 이미지 업로드 버튼 활성화
                            const uploadBtn = document.getElementById('uploadAdditionalBtn');
                            if (uploadBtn) {
                                uploadBtn.disabled = false;
                            }
                        } catch (error) {
                            console.error('이미지 데이터 생성 오류:', error);
                            alert('이미지 처리 중 오류가 발생했습니다: ' + file.name);
                        }
                    };
                    
                    reader.onerror = function() {
                        console.error('파일 읽기 오류:', file.name);
                        alert(`${file.name} 파일을 읽는 중 오류가 발생했습니다.`);
                    };
                    
                    reader.readAsDataURL(file);
                });
                
                // 파일 입력 초기화
                input.value = '';
            } catch (error) {
                console.error('파일 처리 오류:', error);
                alert('파일 처리 중 오류가 발생했습니다.');
            }
        }
        
        // 추가 이미지 렌더링 함수
        function renderAdditionalImages() {
            console.log('renderAdditionalImages 호출됨, 이미지 개수:', additionalImages.length);
            const container = document.getElementById('additionalImagesList');
            
            if (!container) {
                console.error('additionalImagesList 컨테이너를 찾을 수 없습니다!');
                return;
            }
            
            container.innerHTML = '';
            
            if (additionalImages.length === 0) {
                console.log('추가 이미지가 없어서 컨테이너를 비웠습니다.');
                return;
            }
            
            additionalImages.forEach((image, index) => {
                console.log(`이미지 ${index + 1} 렌더링:`, {
                    id: image.id,
                    preview: image.preview,
                    uploaded: image.uploaded,
                    fileName: image.file ? image.file.name : '기존 이미지'
                });
                
                const imageDiv = document.createElement('div');
                imageDiv.className = 'additional-image-item';
                
                // 이미지 경로 확인 및 수정
                let imageSrc = image.preview;
                if (!imageSrc) {
                    console.warn(`이미지 ${index + 1}의 preview가 없습니다.`);
                    imageSrc = '../img/products/default.png';
                }
                
                // 이미지 경로 정규화
                if (imageSrc && !imageSrc.startsWith('http') && !imageSrc.startsWith('/') && !imageSrc.startsWith('../') && !imageSrc.startsWith('data:')) {
                    // 파일명만 있는 경우 경로 추가
                    if (!imageSrc.includes('img/products/')) {
                        imageSrc = '../img/products/' + imageSrc;
                    }
                }
                
                // 이미지 경로 디버깅
                console.log(`이미지 ${index + 1} 렌더링 경로:`, imageSrc);
                
                imageDiv.innerHTML = `
                    <div class="additional-image-preview">
                        <img src="${imageSrc}" alt="추가 이미지 ${index + 1}" 
                             onload="console.log('✅ 이미지 로드 성공:', this.src)"
                             onerror="handleImageLoadError(this, '${imageSrc}', ${image.id})">
                        <div class="additional-image-overlay" onclick="removeAdditionalImage(${image.id})" title="이미지 제거">×</div>
                    </div>
                    <div class="additional-image-info">
                        <span class="image-name">${image.file ? image.file.name : '기존 이미지'}</span>
                        <span class="image-status ${image.uploaded ? 'uploaded' : 'pending'}">
                            ${image.uploaded ? '업로드됨' : '대기중'}
                        </span>
                    </div>
                `;
                container.appendChild(imageDiv);
            });
            
            console.log('추가 이미지 렌더링 완료');
        }
        
        // 추가 이미지 제거 함수
        function removeAdditionalImage(imageId) {
            additionalImages = additionalImages.filter(img => img.id !== imageId);
            renderAdditionalImages();
        }
        
        // 모든 추가 이미지 제거 함수
        function clearAllAdditionalImages() {
            if (additionalImages.length > 0) {
                if (confirm('모든 추가 이미지를 제거하시겠습니까?')) {
                    additionalImages = [];
                    document.getElementById('additionalImageFile').value = '';
                    document.getElementById('additionalImageFileCamera').value = '';
                    renderAdditionalImages();
                }
            }
        }
        
        // 추가 이미지 업로드 함수 (UI 버튼용)
        async function uploadAdditionalImages() {
            const pendingImages = additionalImages.filter(img => !img.uploaded);
            
            if (pendingImages.length === 0) {
                alert('업로드할 추가 이미지가 없습니다.');
                return;
            }
            
            const uploadBtn = document.getElementById('uploadAdditionalBtn');
            uploadBtn.disabled = true;
            uploadBtn.textContent = '업로드 중...';
            
            try {
                for (let i = 0; i < pendingImages.length; i++) {
                    const image = pendingImages[i];
                    try {
                        const formData = new FormData();
                        formData.append('image', image.file);
                        
                        const response = await fetch('uploadImage.jsp', {
                            method: 'POST',
                            body: formData
                        });
                        
                        if (!response.ok) {
                            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                        }
                        
                        const result = await response.json();
                        
                        if (result.success) {
                            image.uploaded = true;
                            image.url = result.filename;
                        } else {
                            console.error('Upload failed for image:', image.file.name, result.error);
                        }
                    } catch (error) {
                        console.error('Upload error for image:', image.file.name, error);
                        
                        // 모바일에서 자주 발생하는 에러 메시지 개선
                        let errorMessage = '이미지 업로드 중 오류가 발생했습니다.';
                        if (error.message.includes('NetworkError') || error.message.includes('Failed to fetch')) {
                            errorMessage = '네트워크 연결을 확인해주세요.';
                        } else if (error.message.includes('413')) {
                            errorMessage = '파일 크기가 너무 큽니다.';
                        } else if (error.message.includes('415')) {
                            errorMessage = '지원하지 않는 파일 형식입니다.';
                        }
                        
                        console.error(errorMessage + ' - ' + image.file.name);
                    }
                }
                
                renderAdditionalImages();
                alert('추가 이미지 업로드가 완료되었습니다!');
                
            } finally {
                uploadBtn.disabled = false;
                uploadBtn.textContent = '⬆️ 추가 이미지 업로드';
            }
            
            return additionalImages.filter(img => img.uploaded).map(img => img.url);
        }
        
        // 추가 이미지 업로드 함수 (상품 저장 시 사용)
        async function uploadAdditionalImagesForSave() {
            const pendingImages = additionalImages.filter(img => !img.uploaded);
            
            for (let image of pendingImages) {
                try {
                    const formData = new FormData();
                    formData.append('image', image.file);
                    
                    const response = await fetch('uploadImage.jsp', {
                        method: 'POST',
                        body: formData
                    });
                    
                    if (!response.ok) {
                        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                    }
                    
                    const result = await response.json();
                    
                    if (result.success) {
                        image.uploaded = true;
                        image.url = result.filename;
                    } else {
                        console.error('Upload failed for image:', image.file.name, result.error);
                    }
                } catch (error) {
                    console.error('Upload error for image:', image.file.name, error);
                    
                    // 모바일에서 자주 발생하는 에러 메시지 개선
                    let errorMessage = '이미지 업로드 중 오류가 발생했습니다.';
                    if (error.message.includes('NetworkError') || error.message.includes('Failed to fetch')) {
                        errorMessage = '네트워크 연결을 확인해주세요.';
                    } else if (error.message.includes('413')) {
                        errorMessage = '파일 크기가 너무 큽니다.';
                    } else if (error.message.includes('415')) {
                        errorMessage = '지원하지 않는 파일 형식입니다.';
                    }
                    
                    console.error(errorMessage + ' - ' + image.file.name);
                }
            }
            
            renderAdditionalImages();
            return additionalImages.filter(img => img.uploaded).map(img => img.url);
        }
        
        // 상품 저장 함수 수정 (추가 이미지 포함, 모바일 호환성 개선)
        async function saveProduct() {
            try {
                const form = document.getElementById('productForm');
                const productId = document.getElementById('productId').value;
                const url = productId ? 'updateProduct.jsp' : 'addProduct.jsp';
                
                // 클라이언트 측 유효성 검사
                const price = document.getElementById('productPrice').value;
                const stockQuantity = document.getElementById('productStock').value;
                const productName = document.getElementById('productName').value;
                
                if (!productName || productName.trim() === '') {
                    alert('상품명을 입력해주세요.');
                    return;
                }
                
                if (!price || !stockQuantity) {
                    alert('가격과 재고 수량을 입력해주세요.');
                    return;
                }
                
                if (!/^\d+$/.test(price) || !/^\d+$/.test(stockQuantity)) {
                    alert('가격과 재고 수량은 숫자만 입력해주세요.');
                    return;
                }
                
                if (parseInt(price) < 0 || parseInt(stockQuantity) < 0) {
                    alert('가격과 재고 수량은 0 이상이어야 합니다.');
                    return;
                }
                
                // 로딩 상태 표시
                const saveBtn = document.querySelector('.modal-footer button[type="button"]');
                if (saveBtn) {
                    saveBtn.disabled = true;
                    saveBtn.textContent = '저장 중...';
                }
                
                // 추가 이미지 업로드
                let additionalImageUrls = [];
                try {
                    additionalImageUrls = await uploadAdditionalImagesForSave();
                } catch (error) {
                    console.warn('추가 이미지 업로드 실패:', error);
                    // 추가 이미지 업로드 실패해도 상품 저장은 계속 진행
                }
                
                // FormData 구성
                const formData = new URLSearchParams();
                formData.append('id', document.getElementById('productId').value);
                formData.append('name', document.getElementById('productName').value.trim());
                formData.append('description', document.getElementById('productDescription').value.trim());
                formData.append('price', document.getElementById('productPrice').value);
                formData.append('stock_quantity', document.getElementById('productStock').value);
                formData.append('category_id', document.getElementById('productCategory').value);
                formData.append('subcategory_id', document.getElementById('productSubcategory').value);
                formData.append('image_url', document.getElementById('productImage').value);
                formData.append('is_active', document.getElementById('productActive').checked ? 'on' : 'off');
                
                // detail_images 컬럼에 추가 이미지 URL들을 JSON 형태로 전송
                if (additionalImageUrls.length > 0) {
                    formData.append('additional_images', JSON.stringify(additionalImageUrls));
                }
                
                // 서버로 전송
                const response = await fetch(url, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: formData
                });
                
                const result = await response.text();
                console.log('Server response:', result);
                console.log('Response status:', response.status);
                console.log('Response ok:', response.ok);
                
                // 응답 내용을 기준으로 성공/실패 판단
                if (result.trim() === 'success') {
                    alert(productId ? '상품이 수정되었습니다.' : '상품이 추가되었습니다.');
                    closeProductModal();
                    loadProducts(); // 상품 목록 새로고침
                } else {
                    // HTTP 상태 코드가 200이 아니거나 응답이 'success'가 아닌 경우
                    if (!response.ok) {
                        alert('서버 오류가 발생했습니다. (HTTP ' + response.status + '): ' + result);
                    } else {
                        alert('오류: ' + result);
                    }
                }
            } catch (error) {
                console.error('Save error:', error);
                alert('저장 중 오류가 발생했습니다: ' + error.message);
            } finally {
                // 로딩 상태 해제
                const saveBtn = document.querySelector('.modal-footer button[type="button"]');
                if (saveBtn) {
                    saveBtn.disabled = false;
                    saveBtn.textContent = productId ? '수정' : '저장';
                }
            }
        }
    </script>
</body>
</html> 