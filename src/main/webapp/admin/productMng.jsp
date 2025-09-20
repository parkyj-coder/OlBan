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
            display: flex !important;
            align-items: center !important;
            color: var(--gray-700) !important;
            font-weight: 500 !important;
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
        
        .additional-image-item {
            position: relative;
            border-radius: 8px;
            overflow: hidden;
            background: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .additional-image-preview {
            width: 100%;
            height: 120px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f0f0f0;
        }
        
        .additional-image-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
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
                grid-template-columns: 1fr 1fr !important;
                gap: 8px !important;
            }
            
            .upload-action-buttons {
                grid-template-columns: 1fr 1fr !important;
                gap: 8px !important;
            }
            
            .additional-images-list {
                grid-template-columns: repeat(2, 1fr) !important;
                gap: 8px !important;
                padding: 8px !important;
            }
            
            .additional-image-controls {
                grid-template-columns: 1fr 1fr !important;
                gap: 8px !important;
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
                display: none !important;
            }
            
            /* 데스크탑에서 버튼 레이아웃 조정 */
            .upload-buttons {
                grid-template-columns: 1fr !important;
            }
            
            .additional-image-controls {
                grid-template-columns: 1fr 1fr !important;
            }
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
        }
        
        .additional-image-item:hover {
            transform: translateY(-2px);
        }
        
        .additional-image-preview {
            position: relative;
        }
        
        .additional-image-overlay {
            position: absolute;
            top: -5px;
            right: -5px;
            background: #ff4444;
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
        }
        
        .additional-image-overlay:hover {
            background: #cc0000;
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
            background: linear-gradient(135deg, #ff6b6b, #ee5a52) !important;
            color: white !important;
            border: none !important;
            padding: 8px 16px !important;
            border-radius: 6px !important;
            font-size: 14px !important;
            font-weight: 500 !important;
            cursor: pointer !important;
            transition: all 0.3s ease !important;
            box-shadow: 0 2px 4px rgba(255, 107, 107, 0.3) !important;
            position: relative !important;
            overflow: hidden !important;
        }
        
        .admin-btn-remove:hover {
            background: linear-gradient(135deg, #ff5252, #e53935) !important;
            transform: translateY(-1px) !important;
            box-shadow: 0 4px 8px rgba(255, 107, 107, 0.4) !important;
        }
        
        .admin-btn-remove:active {
            transform: translateY(0) !important;
            box-shadow: 0 2px 4px rgba(255, 107, 107, 0.3) !important;
        }
        
        .admin-btn-remove::before {
            content: '🗑️';
            margin-right: 6px;
            font-size: 12px;
        }
        
        /* 개별 이미지 제거 버튼 스타일 */
        .remove-image-btn {
            background: linear-gradient(135deg, #ff4757, #ff3742) !important;
            color: white !important;
            border: none !important;
            border-radius: 50% !important;
            width: 24px !important;
            height: 24px !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            cursor: pointer !important;
            font-size: 14px !important;
            font-weight: bold !important;
            transition: all 0.2s ease !important;
            box-shadow: 0 2px 4px rgba(255, 71, 87, 0.3) !important;
        }
        
        .remove-image-btn:hover {
            background: linear-gradient(135deg, #ff3742, #ff2f3a) !important;
            transform: scale(1.1) !important;
            box-shadow: 0 3px 6px rgba(255, 71, 87, 0.4) !important;
        }
        
        .remove-image-btn:active {
            transform: scale(0.95) !important;
        }
        
        /* 업로드 버튼 그룹 스타일 개선 */
        .upload-buttons {
            display: flex !important;
            gap: 10px !important;
            align-items: center !important;
            flex-wrap: wrap !important;
        }
        
        .upload-buttons .admin-btn {
            flex: 1 !important;
            min-width: 120px !important;
            text-align: center !important;
            min-height: 44px !important; /* 모바일 터치 최소 크기 */
            padding: 12px 16px !important;
        }
        
        .upload-buttons .admin-btn-remove {
            flex: 1 !important;
            min-width: 140px !important;
            min-height: 44px !important; /* 모바일 터치 최소 크기 */
        }
        
        /* 모바일 반응형 스타일 */
        @media (max-width: 768px) {
            .modal-content {
                max-width: 95vw !important;
                margin: 10px !important;
                max-height: 95vh !important;
            }
            
            .upload-buttons {
                flex-direction: column !important;
                gap: 8px !important;
            }
            
            .upload-buttons .admin-btn {
                width: 100% !important;
                min-width: auto !important;
                min-height: 48px !important; /* 모바일에서 더 큰 터치 영역 */
                font-size: 16px !important; /* 모바일에서 더 큰 폰트 */
            }
            
            .form-row {
                flex-direction: column !important;
            }
            
            .form-row .form-group {
                width: 100% !important;
                margin-bottom: 15px !important;
            }
            
            .additional-image-controls {
                flex-direction: column !important;
                gap: 8px !important;
            }
            
            /* 모바일 이미지 업로드 최적화 */
            .image-upload-container {
                gap: 12px !important;
            }
            
            .image-preview {
                min-height: 150px !important;
                padding: 15px !important;
            }
            
            .image-preview img {
                max-width: 150px !important;
                max-height: 150px !important;
            }
            
            .upload-buttons {
                grid-template-columns: 1fr 1fr !important;
                gap: 8px !important;
            }
            
            .upload-action-buttons {
                grid-template-columns: 1fr 1fr !important;
                gap: 8px !important;
            }
            
            .upload-buttons .admin-btn {
                width: 100% !important;
                min-height: 48px !important;
                font-size: 16px !important;
                padding: 12px 16px !important;
            }
            
            .additional-images-list {
                grid-template-columns: repeat(2, 1fr) !important;
                gap: 10px !important;
                padding: 8px !important;
            }
            
            .additional-image-item {
                min-width: auto !important;
            }
            
            .additional-image-preview {
                height: 100px !important;
            }
            
            .additional-image-preview img {
                width: 100% !important;
                height: 100% !important;
            }
            
            .additional-image-controls {
                grid-template-columns: 1fr 1fr !important;
                gap: 8px !important;
            }
            
            .additional-image-controls .admin-btn {
                width: 100% !important;
                min-height: 48px !important;
                font-size: 16px !important;
                padding: 12px 16px !important;
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
                min-height: 120px !important;
                padding: 10px !important;
            }
            
            .image-preview img {
                max-width: 120px !important;
                max-height: 120px !important;
            }
            
            .additional-images-list {
                grid-template-columns: 1fr !important;
                gap: 8px !important;
                padding: 10px !important;
            }
            
            .additional-image-preview {
                height: 80px !important;
            }
            
            .upload-buttons {
                grid-template-columns: 1fr !important;
                gap: 8px !important;
            }
            
            .upload-action-buttons {
                grid-template-columns: 1fr !important;
                gap: 8px !important;
            }
            
            .additional-image-controls {
                grid-template-columns: 1fr 1fr !important;
                gap: 8px !important;
            }
            
            .upload-buttons {
                grid-template-columns: 1fr !important;
                gap: 8px !important;
            }
            
            .upload-action-buttons {
                grid-template-columns: 1fr !important;
                gap: 8px !important;
            }
            
            .additional-images-list {
                grid-template-columns: 1fr !important;
                gap: 8px !important;
                padding: 10px !important;
            }
            
            .image-preview {
                min-height: 120px !important;
                padding: 10px !important;
            }
            
            .image-preview img {
                max-height: 100px !important;
            }
        }
        
        @media (max-width: 360px) {
            .additional-image-controls {
                grid-template-columns: 1fr !important;
                gap: 8px !important;
            }
            
            .admin-btn {
                font-size: 12px !important;
                padding: 8px 10px !important;
            }
        }
            cursor: pointer !important;
            margin-bottom: 0 !important;
            line-height: 1.5 !important;
            width: fit-content !important;
            max-width: none !important;
            position: relative !important;
        }
        
        .admin-form .checkbox-label input[type="checkbox"] {
            margin-right: 8px !important;
            transform: scale(1.3) !important;
            margin-top: 0 !important;
            margin-bottom: 0 !important;
            flex-shrink: 0 !important;
            position: relative !important;
            z-index: 1 !important;
        }
        
        .admin-form .checkbox-label span {
            line-height: 1.5 !important;
            white-space: nowrap !important;
            flex-shrink: 0 !important;
            position: relative !important;
            z-index: 1 !important;
            margin-left: 0 !important;
            margin-right: 0 !important;
        }
        
        /* 체크박스가 있는 form-group 특별 처리 */
        .admin-form .form-group:has(.checkbox-label) {
            display: flex !important;
            justify-content: flex-start !important;
            align-items: center !important;
        }
        
        .admin-form .form-group .checkbox-label {
            margin: 0 !important;
            padding: 0 !important;
        }
        
        @media (max-width: 768px) {
            .admin-form .checkbox-label {
                align-items: flex-start !important;
                padding-top: var(--spacing-1) !important;
            }
            
            .admin-form .checkbox-label input[type="checkbox"] {
                transform: scale(1.2) !important;
                margin-top: 2px !important;
                margin-right: 8px !important;
            }
            
            .admin-form .checkbox-label span {
                line-height: 1.4 !important;
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
                                    <input type="file" id="imageFile" accept="image/jpeg,image/jpg,image/png,image/gif,image/webp" style="display: none;" capture="environment">
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
                                    <input type="file" id="additionalImageFile" accept="image/*" multiple style="display: none;" onchange="handleAdditionalImages(this)" capture="environment">
                                    <input type="file" id="additionalImageFileCamera" accept="image/*" multiple style="display: none;" onchange="handleAdditionalImages(this)" capture="camera">
                                    <button type="button" class="admin-btn admin-btn-secondary" onclick="selectAdditionalFromGallery()">
                                        <span class="desktop-text">📁 파일 선택</span>
                                        <span class="mobile-text">📁 앨범에서 선택</span>
                                    </button>
                                    <button type="button" class="admin-btn admin-btn-secondary camera-btn" onclick="selectAdditionalFromCamera()">
                                        📷 카메라로 촬영
                                    </button>
                                    <button type="button" class="admin-btn admin-btn-primary" onclick="uploadAdditionalImages()" id="uploadAdditionalBtn" disabled>
                                        ⬆️ 추가 이미지 업로드
                                    </button>
                                    <button type="button" class="admin-btn admin-btn-remove" onclick="clearAllAdditionalImages()">
                                        모두 제거
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
            document.getElementById('productModal').style.display = 'block';
            document.body.style.overflow = 'hidden';
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
                        productCategoryField.value = product.category_id || '';
                        productSubcategoryField.value = product.subcategory_id || '';
                        productImageField.value = product.image_url || '';
                        productActiveField.checked = product.is_active;
                        
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
            }
        }
        
        // 이미지 선택 함수들 (카메라/앨범 구분)
        function selectFromGallery() {
            document.getElementById('imageFile').click();
        }
        
        function selectFromCamera() {
            document.getElementById('imageFileCamera').click();
        }
        
        function selectAdditionalFromGallery() {
            document.getElementById('additionalImageFile').click();
        }
        
        function selectAdditionalFromCamera() {
            document.getElementById('additionalImageFileCamera').click();
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
                    
                    alert('메인 이미지가 성공적으로 업로드되었습니다!');
                    
                    // 2초 후 진행률 숨기기
                    setTimeout(() => {
                        progressDiv.style.display = 'none';
                        uploadBtn.disabled = false;
                    }, 2000);
                    
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
                            const imageData = {
                                id: Date.now() + Math.random(),
                                file: file,
                                preview: e.target.result,
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
            const container = document.getElementById('additionalImagesList');
            container.innerHTML = '';
            
            additionalImages.forEach((image, index) => {
                const imageDiv = document.createElement('div');
                imageDiv.className = 'additional-image-item';
                imageDiv.innerHTML = `
                    <div class="additional-image-preview">
                        <img src="${image.preview}" alt="추가 이미지 ${index + 1}" style="width: 100px; height: 100px; object-fit: cover; border-radius: 4px;">
                        <div class="additional-image-overlay">
                            <button type="button" class="remove-image-btn" onclick="removeAdditionalImage(${image.id})" title="이미지 제거">×</button>
                        </div>
                    </div>
                    <div class="additional-image-info">
                        <span class="image-name">${image.file.name}</span>
                        <span class="image-status ${image.uploaded ? 'uploaded' : 'pending'}">
                            ${image.uploaded ? '업로드됨' : '대기중'}
                        </span>
                    </div>
                `;
                container.appendChild(imageDiv);
            });
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