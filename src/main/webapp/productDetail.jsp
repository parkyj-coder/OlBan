<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="util.DBUtil"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>상품 상세 - 올반푸드</title>
<link rel="icon" type="image/x-icon" href="img/logo.png">
<link rel="stylesheet" href="css/main.css">
<link rel="stylesheet" href="css/pages/productDetail.css">
</head>
<body>
	<jsp:include page="/common/header.jsp" />

	<main>
		<div class="pd-container">
			<%
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

			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				conn = DBUtil.getConnection();

				// 상품 상세 정보 조회 (detail_images 컬럼 포함)
				String sql = "SELECT p.id, p.name, p.description, p.price, p.image_url, p.stock_quantity, "
				+ "p.subcategory_id, c.name as category_name, p.detail_images, p.created_at, p.updated_at " + "FROM products p "
				+ "LEFT JOIN categories c ON p.category_id = c.id " + "WHERE p.id = ? AND p.is_active = 1";

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
					Timestamp createdAt = rs.getTimestamp("created_at");
					Timestamp updatedAt = rs.getTimestamp("updated_at");

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
				case 1 :
					subcategoryName = "돼지고기";
					break;
				case 2 :
					subcategoryName = "소고기";
					break;
				default :
					subcategoryName = "기타";
					break;
					}
					
					// detail_images 컬럼에서 추가 이미지 조회
					java.util.List<String> additionalImages = new java.util.ArrayList<>();
					String detailImagesJson = rs.getString("detail_images");
					
					if (detailImagesJson != null && !detailImagesJson.trim().isEmpty()) {
						try {
							// JSON 배열 파싱 (간단한 문자열 배열로 가정)
							String cleanJson = detailImagesJson.replace("[", "").replace("]", "").replace("\"", "");
							String[] imageUrls = cleanJson.split(",");
							
							for (String additionalImageUrl : imageUrls) {
								String trimmedUrl = additionalImageUrl.trim();
								if (!trimmedUrl.isEmpty()) {
									// 이미지 URL 처리
									String fileName = trimmedUrl;
									if (trimmedUrl.indexOf("/") != -1) {
										fileName = trimmedUrl.substring(trimmedUrl.lastIndexOf("/") + 1);
									}
									additionalImages.add("img/products/" + fileName);
								}
							}
						} catch (Exception e) {
							// JSON 파싱 오류 시 무시
							e.printStackTrace();
						}
					}
			%>

			<!-- 브레드크럼 네비게이션 -->
			<nav class="pd-breadcrumb">
				<a href="index.jsp">홈</a> <span class="pd-separator">></span> <a
					href="products.jsp">상품리스트</a> <span class="pd-separator">></span> <span
					class="pd-current"><%=productName%></span>
			</nav>

			<div class="pd-content">
				<!-- 상품 이미지 섹션 -->
				<div class="pd-image-section">
					<div class="pd-main-image">
						<img src="<%=imageUrl%>" alt="<%=productName%>"
							id="mainProductImage">
					</div>
					<div class="pd-thumbnails">
						<div class="pd-thumbnail pd-active"
							onclick="changeMainImage('<%=imageUrl%>')">
							<img src="<%=imageUrl%>" alt="<%=productName%>">
						</div>
						<!-- 추가 이미지 표시 -->
						<%
						for (int i = 0; i < additionalImages.size(); i++) {
							String additionalImageUrl = additionalImages.get(i);
						%>
						<div class="pd-thumbnail"
							onclick="changeMainImage('<%=additionalImageUrl%>')">
							<img src="<%=additionalImageUrl%>" alt="<%=productName%> 추가 이미지 <%=i+1%>">
						</div>
						<%
						}
						%>
					</div>
				</div>

				<!-- 상품 정보 섹션 -->
				<div class="pd-info-section">
					<div class="pd-header">
						<div class="pd-title-section">
							<h1 class="pd-title"><%=productName%></h1>
							<div class="pd-category">
								<span class="pd-category-tag pd-category-main"><%=categoryName != null ? categoryName : "기본"%></span>
								<span class="pd-category-tag pd-category-sub"><%=subcategoryName%></span>
							</div>
						</div>
						<div class="pd-price">
							<span class="pd-price-amount">₩<%=String.format("%,d", price)%></span>
							<span class="pd-price-unit">/ 1kg</span>
						</div>
					</div>

					<div class="pd-description">
						<h3>상품 설명</h3>
						<p><%=description != null ? description : "상품에 대한 자세한 설명이 없습니다."%></p>
					</div>

					<div class="pd-purchase-section">
						<div class="pd-top-row">
							<div class="pd-quantity">
								<label for="quantity">수량:</label>
								<div class="pd-quantity-controls">
									<button type="button" onclick="changeQuantity(-1)"
										class="pd-quantity-btn">-</button>
									<input type="number" id="quantity" value="1" min="1"
										max="<%=stockQuantity%>" class="pd-quantity-input">
									<button type="button" onclick="changeQuantity(1)"
										class="pd-quantity-btn">+</button>
								</div>
							</div>

							<div class="pd-stock">
								<%
								if (stockQuantity > 0) {
								%>
								<span class="pd-stock-in">재고: <%=stockQuantity%>개
								</span>
								<%
								} else {
								%>
								<span class="pd-stock-out">품절</span>
								<%
								}
								%>
							</div>
						</div>

						<div class="pd-actions">
							<%
							if (stockQuantity > 0) {
							%>
							<button class="pd-btn pd-btn-cart"
								onclick="addToCart(<%=productId%>)">
								<span class="pd-btn-icon">🛒</span> 장바구니
							</button>
							<button class="pd-btn pd-btn-buy"
								onclick="buyNow(<%=productId%>)">
								<span class="pd-btn-icon">💳</span> 바로구매
							</button>
							<%
							} else {
							%>
							<button class="pd-btn pd-btn-disabled" disabled>품절</button>
							<%
							}
							%>
						</div>
					</div>
				</div>
			</div>

			<!-- 관련 상품 섹션 -->
			<div class="pd-related">
				<h2>관련 상품</h2>
				<div class="pd-related-grid">
					<%
					// 같은 카테고리의 다른 상품들 조회
					String relatedSql = "SELECT p.id, p.name, p.price, p.image_url, p.stock_quantity " + "FROM products p "
							+ "LEFT JOIN categories c ON p.category_id = c.id " + "WHERE p.is_active = 1 AND p.id != ? "
							+ "AND p.subcategory_id = ? " + "ORDER BY RAND() LIMIT 4";

					PreparedStatement relatedStmt = conn.prepareStatement(relatedSql);
					relatedStmt.setInt(1, productId);
					relatedStmt.setInt(2, subcategoryId);
					ResultSet relatedRs = relatedStmt.executeQuery();

					while (relatedRs.next()) {
						int relatedId = relatedRs.getInt("id");
						String relatedName = relatedRs.getString("name");
						int relatedPrice = relatedRs.getInt("price");
						String relatedImageUrl = relatedRs.getString("image_url");
						int relatedStock = relatedRs.getInt("stock_quantity");

						// 이미지 URL 처리
						if (relatedImageUrl == null || relatedImageUrl.trim().isEmpty()) {
							relatedImageUrl = "img/products/default.png";
						} else {
							String fileName = relatedImageUrl;
							if (relatedImageUrl.indexOf("/") != -1) {
						fileName = relatedImageUrl.substring(relatedImageUrl.lastIndexOf("/") + 1);
							}
							relatedImageUrl = "img/products/" + fileName;
						}
					%>
					<div class="pd-related-card"
						onclick="goToProductDetail(<%=relatedId%>)">
						<div class="pd-related-image">
							<img src="<%=relatedImageUrl%>" alt="<%=relatedName%>">
						</div>
						<div class="pd-related-info">
							<h4 class="pd-related-title"><%=relatedName%></h4>
							<p class="pd-related-price">
								₩<%=String.format("%,d", relatedPrice)%></p>
							<%
							if (relatedStock <= 0) {
							%>
							<span class="pd-related-out">품절</span>
							<%
							}
							%>
						</div>
					</div>
					<%
					}
					relatedRs.close();
					relatedStmt.close();
					%>
				</div>
			</div>

			<%
			} else {
			// 상품을 찾을 수 없는 경우
			%>
			<div class="pd-not-found">
				<div class="not-found-content">
					<h2>상품을 찾을 수 없습니다</h2>
					<p>요청하신 상품이 존재하지 않거나 삭제되었습니다.</p>
					<a href="products.jsp" class="pd-btn pd-btn-cart">상품 목록으로 돌아가기</a>
				</div>
			</div>
			<%
			}

			} catch (SQLException e) {
			%>
			<div class="pd-error">
				<h2>오류가 발생했습니다</h2>
				<p>상품 정보를 불러오는 중 오류가 발생했습니다.</p>
				<a href="products.jsp" class="pd-btn pd-btn-cart">상품 목록으로 돌아가기</a>
			</div>
			<%
			e.printStackTrace();
			} finally {
			if (rs != null)
				try {
					rs.close();
				} catch (SQLException e) {
				}
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (SQLException e) {
				}
			if (conn != null)
				DBUtil.closeConnection(conn);
			}
			%>
		</div>
	</main>

	<jsp:include page="/common/footer.jsp" />

	<!-- 커스텀 모달 -->
	<div id="productModal" class="pd-modal">
		<div class="pd-modal-content">
			<div class="pd-modal-header">
				<h3>알림</h3>
				<button class="pd-modal-close" onclick="closeProductModal()">&times;</button>
			</div>
			<div class="pd-modal-body">
				<p id="productModalMessage">메시지가 여기에 표시됩니다.</p>
			</div>
			<div class="pd-modal-footer">
				<button class="pd-modal-btn" onclick="closeProductModal()">확인</button>
			</div>
		</div>
	</div>

	<script>
        // 수량 변경 함수
        function changeQuantity(delta) {
            const quantityInput = document.getElementById('quantity');
            const currentQuantity = parseInt(quantityInput.value);
            const maxQuantity = parseInt(quantityInput.max);
            const newQuantity = currentQuantity + delta;
            
            if (newQuantity >= 1 && newQuantity <= maxQuantity) {
                quantityInput.value = newQuantity;
            }
        }
        
                 // 메인 이미지 변경 함수
         function changeMainImage(imageUrl) {
             document.getElementById('mainProductImage').src = imageUrl;
             
             // 썸네일 활성화 상태 변경
             document.querySelectorAll('.pd-thumbnail').forEach(thumb => {
                 thumb.classList.remove('pd-active');
             });
             event.target.closest('.pd-thumbnail').classList.add('pd-active');
         }
        
        // 장바구니에 추가
        function addToCart(productId) {
            const quantity = parseInt(document.getElementById('quantity').value);
            
            // 상품 정보 가져오기
            fetch('getProductInfo.jsp?id=' + productId)
                .then(response => response.json())
                .then(result => {
                    if (result.success) {
                        const cartItem = {
                            id: productId,
                            name: result.name,
                            price: result.price,
                            image: result.image_url,
                            category: result.category_name + " > " + result.subcategory_name,
                            quantity: quantity
                        };
                        
                        // 기존 장바구니 가져오기
                        let cart = JSON.parse(localStorage.getItem('cart') || '[]');
                        
                        // 같은 상품이 있는지 확인
                        const existingItemIndex = cart.findIndex(item => item.id === productId);
                        
                        if (existingItemIndex !== -1) {
                            // 기존 상품 수량 증가
                            cart[existingItemIndex].quantity += quantity;
                        } else {
                            // 새 상품 추가
                            cart.push(cartItem);
                        }
                        
                        // 장바구니 저장
                        localStorage.setItem('cart', JSON.stringify(cart));
                        
                        // 헤더의 장바구니 카운트 업데이트
                        if (typeof updateCartCount === 'function') {
                            updateCartCount();
                        }
                        
                        showProductModal('상품이 장바구니에 추가되었습니다!');
                    } else {
                        showProductModal('상품 정보를 가져오는데 실패했습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showProductModal('오류가 발생했습니다.');
                });
        }
        
        // 바로구매
        function buyNow(productId) {
            const quantity = parseInt(document.getElementById('quantity').value);
            
            // 장바구니에 추가 후 결제 페이지로 이동
            addToCart(productId);
            
            // 잠시 후 결제 페이지로 이동
            setTimeout(() => {
                window.location.href = 'cart.jsp';
            }, 1000);
        }
        
        // 상품 상세 페이지로 이동
        function goToProductDetail(productId) {
            window.location.href = 'productDetail.jsp?id=' + productId;
        }
        
        // 모달 관련 함수들
        function showProductModal(message) {
            document.getElementById('productModalMessage').textContent = message;
            document.getElementById('productModal').style.display = 'flex';
        }
        
        function closeProductModal() {
            document.getElementById('productModal').style.display = 'none';
        }
        
        // 모달 외부 클릭 시 닫기
        window.onclick = function(event) {
            const modal = document.getElementById('productModal');
            if (event.target === modal) {
                modal.style.display = 'none';
            }
        }
        
        // 관련상품 그리드 크기 조정
        function adjustRelatedGrid() {
            const relatedGrid = document.querySelector('.pd-related-grid');
            if (relatedGrid) {
                const items = relatedGrid.querySelectorAll('.pd-related-card');
                const itemCount = items.length;
                
                console.log('관련상품 개수:', itemCount);
                console.log('기존 클래스:', relatedGrid.className);
                
                // 기존 클래스 제거
                relatedGrid.classList.remove('single-item', 'two-items', 'three-items');
                
                // 상품 개수에 따라 클래스 추가
                if (itemCount === 1) {
                    relatedGrid.classList.add('single-item');
                    console.log('single-item 클래스 추가됨');
                } else if (itemCount === 2) {
                    relatedGrid.classList.add('two-items');
                    console.log('two-items 클래스 추가됨');
                } else if (itemCount === 3) {
                    relatedGrid.classList.add('three-items');
                    console.log('three-items 클래스 추가됨');
                }
                
                console.log('최종 클래스:', relatedGrid.className);
            } else {
                console.log('관련상품 그리드를 찾을 수 없습니다.');
            }
        }
        
        // 페이지 로드 시 실행
        document.addEventListener('DOMContentLoaded', adjustRelatedGrid);
    </script>
</body>
</html>
