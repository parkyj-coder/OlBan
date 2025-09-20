<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품리스트 - 올반푸드</title>
    <link rel="icon" type="image/x-icon" href="img/logo.png">
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="css/pages/products.css">
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    
    <main>
        <div class="products-container">
            
            <div class="products-header">
                <h1>상품리스트</h1>
                <p>올반푸드의 신선하고 다양한 프리미엄 육류를 만나보세요</p>
            </div>
            
            <div class="category-filter">
                <button class="category-btn active" data-category="all">전체</button>
                <button class="category-btn" data-category="domestic">국산</button>
                <button class="category-btn" data-category="imported">수입</button>
            </div>
            
            <div class="subcategory-filter" id="subcategoryFilter">
                <button class="subcategory-btn active" data-subcategory="all">전체</button>
                <button class="subcategory-btn" data-subcategory="pork">돼지고기</button>
                <button class="subcategory-btn" data-subcategory="beef">소고기</button>
            </div>
            
            <div class="products-grid">
                <%
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                
                try {
                    conn = DBUtil.getConnection();
                    
                    // 상품과 카테고리 정보를 함께 조회 (소분류 포함)
                    String sql = "SELECT p.id, p.name, p.description, p.price, p.image_url, p.stock_quantity, p.subcategory_id, c.name as category_name " +
                               "FROM products p " +
                               "LEFT JOIN categories c ON p.category_id = c.id " +
                               "WHERE p.is_active = 1 " +
                               "ORDER BY p.id";
                    
                    pstmt = conn.prepareStatement(sql);
                    rs = pstmt.executeQuery();
                    
                    while (rs.next()) {
                        int productId = rs.getInt("id");
                        String productName = rs.getString("name");
                        String description = rs.getString("description");
                        int price = rs.getInt("price");
                        String imageUrl = rs.getString("image_url");
                        int stockQuantity = rs.getInt("stock_quantity");
                        int subcategoryId = rs.getInt("subcategory_id");
                        String categoryName = rs.getString("category_name");
                        
                        // 카테고리별 CSS 클래스 매핑 (subcategory_id 기반)
                        String categoryClass = "domestic_all"; // 기본값
                        String subcategoryClass = "all";
                        
                        // subcategory_id를 기반으로 소분류 결정
                        switch (subcategoryId) {
                            case 1: subcategoryClass = "pork"; break;    // 돼지고기
                            case 2: subcategoryClass = "beef"; break;    // 소고기
                            default: subcategoryClass = "all"; break;
                        }
                        
                        // 카테고리명을 기반으로 국산/수입 구분
                        if (categoryName != null && categoryName.indexOf("수입") != -1) {
                            categoryClass = "imported_" + subcategoryClass;
                        } else {
                            categoryClass = "domestic_" + subcategoryClass;
                        }
                        
                        // 이미지 URL 처리
                        if (imageUrl == null || imageUrl.trim().isEmpty()) {
                            imageUrl = "img/products/default.png";
                        } else {
                            // 파일명만 추출하여 경로 구성
                            String fileName = imageUrl;
                            if (imageUrl.indexOf("/") != -1) {
                                fileName = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);
                            }
                            imageUrl = "img/products/" + fileName;
                        }
                        %>
                        <div class="product-card" data-category="<%= categoryClass %>" data-product-id="<%= productId %>" onclick="goToProductDetail(<%= productId %>)">
                            <div class="product-image">
                                <img src="<%= imageUrl %>" alt="<%= productName %>">
                            </div>
                            <div class="product-info">
                                <h3><%= productName %></h3>
                                <p><%= description != null ? description : "" %></p>
                                <div class="product-meta">
                                    <span class="price">₩<%= String.format("%,d", price) %></span>
                                    <button class="add-to-cart-btn" onclick="event.stopPropagation(); addToCart(<%= productId %>)">장바구니</button>
                                </div>
                                <% if (stockQuantity <= 0) { %>
                                    <div class="out-of-stock">품절</div>
                                <% } %>
                            </div>
                        </div>
                        <%
                    }
                    
                } catch (SQLException e) {
                    // 데이터베이스 오류 시 기본 상품들 표시
                    %>
                    <div class="error-message">
                        <p>상품 정보를 불러오는 중 오류가 발생했습니다.</p>
                        <p>잠시 후 다시 시도해주세요.</p>
                    </div>
                    <%
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { }
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
                    if (conn != null) DBUtil.closeConnection(conn);
                }
                %>
            </div>
        </div>
    </main>
    
    <jsp:include page="/common/footer.jsp" />
    
    <!-- 커스텀 모달 -->
    <div id="productModal" class="custom-modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>알림</h3>
                <button class="modal-close" onclick="closeProductModal()">&times;</button>
            </div>
            <div class="modal-body">
                <p id="productModalMessage">메시지가 여기에 표시됩니다.</p>
            </div>
            <div class="modal-footer">
                <button class="modal-btn modal-btn-primary" onclick="closeProductModal()">확인</button>
            </div>
        </div>
    </div>
    
    <script>
        // 페이지 로드 시 초기 상태 설정
        document.addEventListener('DOMContentLoaded', function() {
            // 초기에 중분류 필터 숨기기
            const subcategoryFilter = document.getElementById('subcategoryFilter');
            subcategoryFilter.classList.remove('show');
        });
        
        // 카테고리 필터링
        document.querySelectorAll('.category-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                // 활성 버튼 변경
                document.querySelectorAll('.category-btn').forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                
                // 하위 카테고리 필터 표시/숨김
                const category = this.dataset.category;
                const subcategoryFilter = document.getElementById('subcategoryFilter');
                
                if (category === 'all') {
                    subcategoryFilter.classList.remove('show');
                    // 모든 상품 표시
                    document.querySelectorAll('.product-card').forEach(product => {
                        product.style.display = 'block';
                    });
                } else {
                    subcategoryFilter.classList.add('show');
                    // 하위 카테고리 필터 초기화
                    document.querySelectorAll('.subcategory-btn').forEach(b => b.classList.remove('active'));
                    document.querySelector('.subcategory-btn[data-subcategory="all"]').classList.add('active');
                    
                    // 선택된 상위 카테고리의 상품만 표시
                    filterProducts(category, 'all');
                }
            });
        });
        
        // 하위 카테고리 필터링
        document.querySelectorAll('.subcategory-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                // 활성 버튼 변경
                document.querySelectorAll('.subcategory-btn').forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                
                // 현재 선택된 상위 카테고리 가져오기
                const activeCategory = document.querySelector('.category-btn.active').dataset.category;
                const subcategory = this.dataset.subcategory;
                
                // 상품 필터링
                filterProducts(activeCategory, subcategory);
            });
        });
        
        // 상품 필터링 함수
        function filterProducts(category, subcategory) {
            const products = document.querySelectorAll('.product-card');
            
            products.forEach(product => {
                const productCategory = product.dataset.category;
                let shouldShow = false;
                
                if (category === 'all') {
                    shouldShow = true;
                } else if (subcategory === 'all') {
                    // 상위 카테고리만 확인
                    shouldShow = productCategory.startsWith(category);
                } else {
                    // 상위 카테고리와 하위 카테고리 모두 확인
                    shouldShow = productCategory === category + '_' + subcategory;
                }
                
                product.style.display = shouldShow ? 'block' : 'none';
            });
        }
        
        
        // 장바구니 추가 기능 (AJAX로 상품 정보 가져오기)
        function addToCart(productId) {
            // 상품 정보를 서버에서 가져오기
            fetch('getProductInfo.jsp?id=' + productId)
                .then(response => response.json())
                .then(product => {
                    if (!product) {
                        showProductModal('상품 정보를 찾을 수 없습니다.');
                        return;
                    }
                    
                    // 현재 장바구니 가져오기
                    let cart = JSON.parse(localStorage.getItem('cart') || '[]');
                    
                    // 이미 있는 상품인지 확인
                    const existingItem = cart.find(item => item.id === productId);
                    
                    if (existingItem) {
                        // 수량 증가
                        existingItem.quantity += 1;
                    } else {
                        // 새 상품 추가
                        cart.push({
                            id: productId,
                            name: product.name,
                            price: product.price,
                            image: product.image_url,
                            category: product.category_name + " > " + product.subcategory_name,
                            quantity: 1
                        });
                    }
                    
                    // 장바구니 저장
                    localStorage.setItem('cart', JSON.stringify(cart));
                    
                    // 헤더의 장바구니 카운트 업데이트
                    if (typeof updateCartCount === 'function') {
                        updateCartCount();
                    }
                    
                    // 성공 메시지
                    showProductModal(product.name + '이(가) 장바구니에 추가되었습니다!');
                    
                    console.log('장바구니 업데이트:', cart);
                })
                .catch(error => {
                    console.error('상품 정보 가져오기 실패:', error);
                    showProductModal('상품 정보를 가져오는 중 오류가 발생했습니다.');
                });
        }
        
        // 상품 페이지 모달 함수들
        function showProductModal(message) {
            const modal = document.getElementById('productModal');
            const modalMessage = document.getElementById('productModalMessage');
            
            modalMessage.textContent = message;
            modal.style.display = 'block';
            document.body.style.overflow = 'hidden';
        }
        
        function closeProductModal() {
            const modal = document.getElementById('productModal');
            modal.style.display = 'none';
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

        // 상품 상세 페이지로 이동하는 함수
        function goToProductDetail(productId) {
            window.location.href = 'productDetail.jsp?id=' + productId;
        }
    </script>
</body>
</html>
