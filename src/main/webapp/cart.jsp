<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>장바구니 - 올반푸드</title>
    <link rel="icon" type="image/x-icon" href="img/logo.png">
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="css/pages/cart.css">
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    
    <main>
        <div class="cart-container">
            
            <div class="cart-header">
                <h1>장바구니</h1>
                <p>선택하신 상품들을 확인하고 주문해보세요</p>
            </div>
            
            <div class="cart-layout">
                <!-- 빈 장바구니 상태 -->
                <div class="empty-cart" id="emptyCart">
                    <div class="empty-cart-icon">
                        <div class="fallback-icon">🛒</div>
                    </div>
                    <h3>장바구니가 비어있습니다</h3>
                    <p>상품을 추가해보세요</p>
                    <a href="products.jsp" class="continue-shopping">쇼핑 계속하기</a>
                </div>
                
                <div class="cart-content" id="cartContent" style="display: none;">
                    <div class="cart-items" id="cartItems">
                        <!-- 동적으로 추가되는 장바구니 아이템들이 여기에 표시됩니다 -->
                    </div>
                </div>
                
                <!-- 주문 요약 -->
                <div class="cart-summary" id="cartSummary">
                    <div class="summary-header">
                        <h3>주문 요약</h3>
                    </div>
                    <div class="summary-item">
                        <span>상품 금액</span>
                        <span id="subtotal">₩0</span>
                    </div>
                    <div class="summary-item">
                        <span>배송비</span>
                        <span id="shipping">₩0</span>
                    </div>
                    <div class="summary-item total">
                        <span>총 결제금액</span>
                        <span id="total">₩0</span>
                    </div>
                    <button class="checkout-btn" onclick="checkout()">주문하기</button>
                    <button class="clear-cart-btn" onclick="clearCart()">장바구니 비우기</button>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="/common/footer.jsp" />
    
    <!-- 커스텀 모달 -->
    <div id="customModal" class="custom-modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle">알림</h3>
                <button class="modal-close" onclick="closeModal()">&times;</button>
            </div>
            <div class="modal-body">
                <p id="modalMessage">메시지가 여기에 표시됩니다.</p>
            </div>
            <div class="modal-footer">
                <button id="modalConfirmBtn" class="modal-btn modal-btn-primary" onclick="closeModal()">확인</button>
                <button id="modalCancelBtn" class="modal-btn modal-btn-secondary" onclick="closeModal()" style="display: none;">취소</button>
            </div>
        </div>
    </div>
    
    <script>
        // 장바구니 초기화
        document.addEventListener('DOMContentLoaded', function() {
            console.log('장바구니 초기화 시작');
            
            // 초기 상태 설정
            const emptyCart = document.getElementById('emptyCart');
            const cartContent = document.getElementById('cartContent');
            const cartSummary = document.getElementById('cartSummary');
            
            // 기본적으로 빈 장바구니 상태로 시작
            if (emptyCart) emptyCart.style.display = 'block';
            if (cartContent) cartContent.style.display = 'none';
            if (cartSummary) cartSummary.style.display = 'none';
            
            // 로딩 상태 표시
            showLoading();
            
            // localStorage에서 장바구니 데이터 로드
            loadCartFromStorage();
            
            // 빈 장바구니 상태 확인
            checkEmptyCart();
            
            // 총액 업데이트
            updateTotal();
            
            // 로딩 상태 숨김
            hideLoading();
            
            console.log('장바구니 초기화 완료');
        });
        
        function showLoading() {
            const cartContainer = document.querySelector('.cart-container');
            if (cartContainer) {
                cartContainer.style.opacity = '0.6';
                cartContainer.style.pointerEvents = 'none';
            }
        }
        
        function hideLoading() {
            const cartContainer = document.querySelector('.cart-container');
            if (cartContainer) {
                cartContainer.style.opacity = '1';
                cartContainer.style.pointerEvents = 'auto';
            }
        }
        
        // localStorage에서 장바구니 데이터 로드
        function loadCartFromStorage() {
            const cartData = JSON.parse(localStorage.getItem('cart') || '[]');
            const cartItems = document.getElementById('cartItems');
            
            console.log('로드된 장바구니 데이터:', cartData);
            
            // 기존 아이템들 제거
            cartItems.innerHTML = '';
            
            if (cartData.length === 0) {
                console.log('장바구니가 비어있습니다');
                checkEmptyCart();
                return;
            }
            
            // 각 상품을 장바구니에 추가
            cartData.forEach((item, index) => {
                const cartItem = document.createElement('div');
                cartItem.className = 'cart-item';
                cartItem.dataset.price = item.price;
                cartItem.dataset.id = item.id;
                cartItem.dataset.name = item.name; // 상품 이름을 data 속성으로 저장
                

                cartItem.innerHTML = 
                    '<img src="' + item.image + '" alt="' + item.name + '" class="item-image">' +
                    '<div class="item-details">' +
                        '<h3>' + item.name + '</h3>' +
                        '<p class="item-category">' + (item.category || '분류 정보 없음') + '</p>' +
                        '<div class="item-unit-price">₩' + formatPrice(item.price) + ' / 개</div>' +
                    '</div>' +
                    '<div class="item-price" id="item-price-' + index + '">₩' + formatPrice(item.price * item.quantity) + '</div>' +
                    '<div class="item-quantity">' +
                        '<button class="quantity-btn" onclick="changeQuantity(' + index + ', -1)">-</button>' +
                        '<input type="number" class="quantity-input" value="' + item.quantity + '" min="1" onchange="updateQuantity(' + index + ', this.value)">' +
                        '<button class="quantity-btn" onclick="changeQuantity(' + index + ', 1)">+</button>' +
                    '</div>' +
                    '<button class="remove-btn" onclick="removeItem(' + index + ')">삭제</button>';
                
                cartItems.appendChild(cartItem);
                console.log('상품 추가됨: ' + item.name + ', 수량: ' + item.quantity);
            });
            
            // 장바구니 상태 확인
            checkEmptyCart();
        }
        
        function changeQuantity(index, change) {
            const cartItems = document.querySelectorAll('.cart-item');
            if (index >= cartItems.length) return;
            
            const item = cartItems[index];
            const input = item.querySelector('.quantity-input');
            if (!input) return;
            
            let value = parseInt(input.value) + change;
            if (value < 1) value = 1;
            input.value = value;
            
            // localStorage 업데이트
            updateCartInStorage(index, value);
            
            updateItemPrice(index);
            updateTotal();
            updateCartCount();
        }
        
        function updateQuantity(index, value) {
            const cartItems = document.querySelectorAll('.cart-item');
            if (index >= cartItems.length) return;
            
            const item = cartItems[index];
            const input = item.querySelector('.quantity-input');
            if (!input) return;
            
            if (value < 1) value = 1;
            input.value = value;
            
            // localStorage 업데이트
            updateCartInStorage(index, value);
            
            updateItemPrice(index);
            updateTotal();
            updateCartCount();
        }
        
        // 가격 포맷팅 함수
        function formatPrice(price) {
            return price.toLocaleString();
        }
        
        function updateItemPrice(index) {
            const cartItems = document.querySelectorAll('.cart-item');
            if (index >= cartItems.length) return;
            
            const cartItem = cartItems[index];
            const price = parseInt(cartItem.dataset.price);
            const quantityInput = cartItem.querySelector('.quantity-input');
            const quantity = quantityInput ? parseInt(quantityInput.value) : 1;
            const totalPrice = price * quantity;
            
            const priceElement = cartItem.querySelector('.item-price');
            if (priceElement) {
                priceElement.textContent = '₩' + formatPrice(totalPrice);
            }
        }
        
        function removeItem(index) {
            console.log('=== removeItem 함수 시작 ===');
            console.log('삭제 요청된 index:', index);
            
            // localStorage에서 직접 상품 정보 가져오기
            const cartData = JSON.parse(localStorage.getItem('cart') || '[]');
            console.log('전체 장바구니 데이터:', cartData);
            
            if (index >= cartData.length) {
                console.error('인덱스가 범위를 벗어남:', index, '>=', cartData.length);
                return;
            }
            
            const itemToRemove = cartData[index];
            console.log('삭제할 상품 정보:', itemToRemove);
            
            if (!itemToRemove) {
                console.error('삭제할 상품 정보가 없음');
                return;
            }
            
            const productName = itemToRemove.name || '상품';
            console.log('최종 상품명:', productName);
            
            // DOM 요소 찾기
            const cartItems = document.querySelectorAll('.cart-item');
            const cartItem = cartItems[index];
            
            if (!cartItem) {
                console.error('DOM 요소를 찾을 수 없음');
                return;
            }
            
            showModal(
                '상품 삭제',
                '"' + productName + '"을(를) 장바구니에서 삭제하시겠습니까?',
                true,
                function() {
                    console.log('삭제 확인됨');
                    
                    if (cartItem) {
                        cartItem.style.opacity = '0';
                        cartItem.style.transform = 'translateX(-100%)';
                        
                        setTimeout(() => {
                            // localStorage에서 제거
                            removeFromStorage(index);
                            
                            cartItem.remove();
                            updateTotal();
                            checkEmptyCart();
                            updateCartCount();
                            console.log('상품 삭제 완료');
                        }, 300);
                    }
                }
            );
        }
        
        // localStorage 업데이트 함수들
        function updateCartInStorage(index, quantity) {
            const cartData = JSON.parse(localStorage.getItem('cart') || '[]');
            if (cartData[index]) {
                cartData[index].quantity = quantity;
                localStorage.setItem('cart', JSON.stringify(cartData));
                console.log('localStorage 업데이트:', cartData);
            }
        }
        
        function removeFromStorage(index) {
            const cartData = JSON.parse(localStorage.getItem('cart') || '[]');
            cartData.splice(index, 1);
            localStorage.setItem('cart', JSON.stringify(cartData));
            console.log('localStorage에서 제거됨:', cartData);
        }
        
        function updateTotal() {
            const cartItems = document.querySelectorAll('.cart-item');
            let subtotal = 0;
            
            console.log('updateTotal 함수 실행, 장바구니 아이템 수:', cartItems.length);
            
            cartItems.forEach((item, index) => {
                const price = parseInt(item.dataset.price);
                const quantityInput = item.querySelector('.quantity-input');
                const quantity = quantityInput ? parseInt(quantityInput.value) : 1;
                const itemTotal = price * quantity;
                subtotal += itemTotal;
                
                console.log(`아이템 ${index}: 가격=${price}, 수량=${quantity}, 소계=${itemTotal}`);
            });
            
            const shipping = subtotal > 50000 ? 0 : 3000; // 5만원 이상 무료배송
            const total = subtotal + shipping;
            
            // ID를 사용하여 요소 업데이트
            const subtotalElement = document.getElementById('subtotal');
            const shippingElement = document.getElementById('shipping');
            const totalElement = document.getElementById('total');
            
            console.log('요소 찾기 결과:', {
                subtotalElement: !!subtotalElement,
                shippingElement: !!shippingElement,
                totalElement: !!totalElement
            });
            
            if (subtotalElement) {
                subtotalElement.textContent = '₩' + formatPrice(subtotal);
                console.log('상품 금액 업데이트:', '₩' + formatPrice(subtotal));
            } else {
                console.error('subtotal 요소를 찾을 수 없습니다');
            }
            
            if (shippingElement) {
                shippingElement.textContent = '₩' + formatPrice(shipping);
                console.log('배송비 업데이트:', '₩' + formatPrice(shipping));
            } else {
                console.error('shipping 요소를 찾을 수 없습니다');
            }
            
            if (totalElement) {
                totalElement.textContent = '₩' + formatPrice(total);
                console.log('총 결제금액 업데이트:', '₩' + formatPrice(total));
            } else {
                console.error('total 요소를 찾을 수 없습니다');
            }
            
            console.log('총액 업데이트 완료:', { subtotal, shipping, total, itemCount: cartItems.length });
        }
        
        function checkEmptyCart() {
            const cartItems = document.querySelectorAll('.cart-item');
            const cartContent = document.getElementById('cartContent');
            const emptyCart = document.getElementById('emptyCart');
            const cartSummary = document.getElementById('cartSummary');
            
            console.log('checkEmptyCart 실행, 장바구니 아이템 수:', cartItems.length);
            
            if (cartItems.length === 0) {
                // 빈 장바구니 상태
                cartContent.style.display = 'none';
                emptyCart.style.display = 'block';
                if (cartSummary) {
                    cartSummary.style.display = 'none';
                }
                console.log('빈 장바구니 상태로 설정');
            } else {
                // 상품이 있는 상태
                cartContent.style.display = 'block';
                emptyCart.style.display = 'none';
                if (cartSummary) {
                    cartSummary.style.display = 'block';
                }
                console.log('상품이 있는 상태로 설정');
            }
        }
        
        function checkout() {
            const cartItems = document.querySelectorAll('.cart-item');
            if (cartItems.length === 0) {
                showModal('알림', '장바구니가 비어있습니다.');
                return;
            }
            
            // 주문 정보 수집
            const orderItems = [];
            cartItems.forEach((item, index) => {
                const name = item.querySelector('h3').textContent;
                const quantity = parseInt(document.querySelectorAll('.quantity-input')[index].value);
                const price = parseInt(item.dataset.price);
                const totalPrice = price * quantity;
                
                orderItems.push({
                    name: name,
                    quantity: quantity,
                    price: price,
                    totalPrice: totalPrice
                });
            });
            
            // 주문 확인
            const totalElement = document.getElementById('total');
            const total = totalElement ? totalElement.textContent : '₩0';
            
            showModal(
                '주문 확인',
                '주문을 확인합니다.\n\n총 결제금액: ' + total + '\n\n계속하시겠습니까?',
                true,
                function() {
                    showModal('주문 완료', '주문이 완료되었습니다!\n감사합니다.');
                    // 여기에 실제 주문 처리 로직을 추가할 수 있습니다
                }
            );
        }
        
        // 커스텀 모달 함수들
        function showModal(title, message, showCancel = false, onConfirm = null) {
            const modal = document.getElementById('customModal');
            const modalTitle = document.getElementById('modalTitle');
            const modalMessage = document.getElementById('modalMessage');
            const confirmBtn = document.getElementById('modalConfirmBtn');
            const cancelBtn = document.getElementById('modalCancelBtn');
            
            modalTitle.textContent = title;
            modalMessage.textContent = message;
            
            if (showCancel) {
                cancelBtn.style.display = 'block';
                confirmBtn.textContent = '확인';
                confirmBtn.onclick = function() {
                    closeModal();
                    if (onConfirm) onConfirm();
                };
            } else {
                cancelBtn.style.display = 'none';
                confirmBtn.textContent = '확인';
                confirmBtn.onclick = closeModal;
            }
            
            modal.style.display = 'block';
            document.body.style.overflow = 'hidden';
        }
        
        function closeModal() {
            const modal = document.getElementById('customModal');
            modal.style.display = 'none';
            document.body.style.overflow = 'auto';
        }
        
        // 모달 외부 클릭 시 닫기
        document.getElementById('customModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeModal();
            }
        });
        
        // ESC 키로 모달 닫기
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeModal();
            }
        });
        
        // 장바구니 초기화 함수
        function clearCart() {
            showModal(
                '장바구니 비우기',
                '장바구니의 모든 상품을 삭제하시겠습니까?',
                true,
                function() {
                    localStorage.removeItem('cart');
                    loadCartFromStorage();
                    checkEmptyCart();
                    updateTotal();
                    updateCartCount();
                    console.log('장바구니가 초기화되었습니다');
                }
            );
        }
    </script>
</body>
</html> 