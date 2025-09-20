<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>올반푸드 - 프리미엄 육류 유통</title>

    <link rel="stylesheet" href="css/main.css">
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    
    <main>
        <!-- 메인 배너 슬라이더 -->
        <section class="main-banner">
            <div class="banner-slider">
                <div class="banner-slide active" style="background-image: url('img/main/main1.jpg')">
                    <div class="banner-content">
                        <h1>프리미엄 육류 유통의 선두주자</h1>
                        <p>신선함과 신뢰를 바탕으로 최고의 품질을 제공합니다</p>
                        <a href="products.jsp" class="banner-btn">상품 보기</a>
                    </div>
                </div>
                <div class="banner-slide" style="background-image: url('img/main/main2.jpg')">
                    <div class="banner-content">
                        <h1>엄선된 최고급 육류</h1>
                        <p>품질 검증을 통과한 프리미엄 육류만을 선별하여 제공</p>
                        <a href="products.jsp" class="banner-btn">상품 보기</a>
                    </div>
                </div>
                <div class="banner-slide" style="background-image: url('img/main/main3.jpg')">
                    <div class="banner-content">
                        <h1>신속한 배송 서비스</h1>
                        <p>신선함을 유지하는 특별한 포장과 빠른 배송</p>
                        <a href="products.jsp" class="banner-btn">상품 보기</a>
                    </div>
                </div>
                <div class="banner-slide" style="background-image: url('img/main/main4.jpg')">
                    <div class="banner-content">
                        <h1>고객 만족을 위한 서비스</h1>
                        <p>최고의 품질과 서비스로 고객님의 만족을 추구합니다</p>
                        <a href="products.jsp" class="banner-btn">상품 보기</a>
                    </div>
                </div>
            </div>
            
            <!-- 슬라이더 네비게이션 -->
            <div class="banner-nav">
                <button class="nav-btn prev" onclick="changeSlide(-1)">❮</button>
                <button class="nav-btn next" onclick="changeSlide(1)">❯</button>
            </div>
            
            <!-- 슬라이더 인디케이터 -->
            <div class="banner-indicators">
                <span class="indicator active" onclick="goToSlide(1)"></span>
                <span class="indicator" onclick="goToSlide(2)"></span>
                <span class="indicator" onclick="goToSlide(3)"></span>
                <span class="indicator" onclick="goToSlide(4)"></span>
            </div>
        </section>

        <!-- 공지사항 섹션 -->
        <section class="notice-section">
            <div class="container">
                <h2 class="section-title">공지사항</h2>
                <div class="notice-slider-container">
                    <div class="notice-slider">
                        <%
                        Connection noticeConn = null;
                        PreparedStatement noticePstmt = null;
                        ResultSet noticeRs = null;
                        
                        try {
                            noticeConn = DBUtil.getConnection();
                            
                            // 최신 공지사항 6개 조회 (2개씩 3페이지)
                            String noticeSql = "SELECT id, title, created_at " +
                                             "FROM notices " +
                                             "WHERE is_active = 1 " +
                                             "ORDER BY created_at DESC " +
                                             "LIMIT 6";
                            
                            noticePstmt = noticeConn.prepareStatement(noticeSql);
                            noticeRs = noticePstmt.executeQuery();
                            
                            boolean hasNotices = false;
                            int noticeCount = 0;
                            while (noticeRs.next()) {
                                hasNotices = true;
                                int noticeId = noticeRs.getInt("id");
                                String title = noticeRs.getString("title");
                                String createdAt = noticeRs.getString("created_at");
                                
                                // 날짜 포맷팅
                                String formattedDate = createdAt;
                                if (createdAt != null && createdAt.length() > 10) {
                                    formattedDate = createdAt.substring(0, 10);
                                }
                                
                                // 2개씩 그룹화하여 슬라이드 생성
                                if (noticeCount % 2 == 0) {
                                    if (noticeCount > 0) {
                        %>
                        </div>
                        <%
                                    }
                        %>
                        <div class="notice-slide">
                        <%
                                }
                        %>
                            <div class="notice-item" onclick="viewNotice(<%= noticeId %>)">
                                <h3 class="notice-title"><%= title %></h3>
                                <span class="notice-date"><%= formattedDate %></span>
                            </div>
                        <%
                                noticeCount++;
                            }
                            
                            // 마지막 슬라이드 닫기
                            if (hasNotices && noticeCount > 0) {
                        %>
                        </div>
                        <%
                            }
                            
                            if (!hasNotices) {
                        %>
                        <div class="notice-slide">
                            <div class="notice-item">
                                <h3 class="notice-title">공지사항이 없습니다</h3>
                                <span class="notice-date">-</span>
                            </div>
                        </div>
                        <%
                            }
                        } catch (Exception e) {
                            System.out.println("공지사항 조회 실패: " + e.getMessage());
                        %>
                        <div class="notice-slide">
                            <div class="notice-item">
                                <h3 class="notice-title">시스템 점검 중</h3>
                                <span class="notice-date">-</span>
                            </div>
                        </div>
                        <%
                        } finally {
                            if (noticeRs != null) noticeRs.close();
                            if (noticePstmt != null) noticePstmt.close();
                            if (noticeConn != null) DBUtil.closeConnection(noticeConn);
                        }
                        %>
                    </div>
                    
                    <!-- 슬라이더 인디케이터 -->
                    <div class="notice-indicators">
                        <span class="notice-indicator active" onclick="goToNoticeSlide(0)"></span>
                        <span class="notice-indicator" onclick="goToNoticeSlide(1)"></span>
                        <span class="notice-indicator" onclick="goToNoticeSlide(2)"></span>
                    </div>
                </div>
                <div class="notice-more">
                    <a href="notices.jsp" class="btn btn-secondary">공지사항 더보기 +</a>
                </div>
            
        </section>

        <!-- 주요 상품 섹션 -->
        <section class="featured-products">
            <div class="container">
                <h2 class="section-title">주요 상품</h2>
                <div class="product-grid">
                    <%
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    
                    try {
                        conn = DBUtil.getConnection();
                        
                        // 활성화된 상품 중에서 랜덤으로 8개 선택
                        String sql = "SELECT p.id, p.name, p.description, p.price, p.image_url " +
                                   "FROM products p " +
                                   "WHERE p.is_active = 1 " +
                                   "ORDER BY RAND() " +
                                   "LIMIT 8";
                        
                        pstmt = conn.prepareStatement(sql);
                        rs = pstmt.executeQuery();
                        
                        while (rs.next()) {
                            int productId = rs.getInt("id");
                            String productName = rs.getString("name");
                            String description = rs.getString("description");
                            int price = rs.getInt("price");
                            String imageUrl = rs.getString("image_url");
                            
                            // 이미지 URL 처리
                            if (imageUrl == null || imageUrl.trim().isEmpty()) {
                                imageUrl = "img/products/default.png";
                            } else {
                                imageUrl = "img/products/" + imageUrl;
                            }
                    %>
                    <div class="product-card" data-product-id="<%= productId %>">
                        <div class="product-image">
                            <img src="<%= imageUrl %>" alt="<%= productName %>" onerror="this.src='img/products/default.png'">
                        </div>
                        <div class="product-info">
                            <h3 class="product-name"><%= productName %></h3>
                            <p class="product-description"><%= description != null ? description : "신선한 육류" %></p>
                            <div class="product-price">₩<%= String.format("%,d", price) %></div>
                        </div>
                    </div>
                    <%
                        }
                    } catch (Exception e) {
                        // 에러 발생 시 기본 상품들 표시
                        System.out.println("데이터베이스 연결 실패: " + e.getMessage());
                    %>
                    <div class="product-card">
                        <div class="product-image">
                            <img src="img/products/default.png" alt="돼지 목살">
                        </div>
                        <div class="product-info">
                            <h3 class="product-name">돼지 목살</h3>
                            <p class="product-description">육즙 가득, 부드러운 식감의 목살</p>
                            <div class="product-price">₩15,000</div>
                        </div>
                    </div>
                    <div class="product-card">
                        <div class="product-image">
                            <img src="img/products/default.png" alt="삼겹살">
                        </div>
                        <div class="product-info">
                            <h3 class="product-name">삼겹살</h3>
                            <p class="product-description">최상급 삼겹살, 신선한 맛과 풍미</p>
                            <div class="product-price">₩18,000</div>
                        </div>
                    </div>
                    <div class="product-card">
                        <div class="product-image">
                            <img src="img/products/default.png" alt="돼지 앞다리">
                        </div>
                        <div class="product-info">
                            <h3 class="product-name">돼지 앞다리</h3>
                            <p class="product-description">육질이 단단하고 맛있는 앞다리</p>
                            <div class="product-price">₩12,000</div>
                        </div>
                    </div>
                    <div class="product-card">
                        <div class="product-image">
                            <img src="img/products/default.png" alt="돼지 뒷다리">
                        </div>
                        <div class="product-info">
                            <h3 class="product-name">돼지 뒷다리</h3>
                            <p class="product-description">살코기가 많고 부드러운 뒷다리</p>
                            <div class="product-price">₩13,000</div>
                        </div>
                    </div>
                    <div class="product-card">
                        <div class="product-image">
                            <img src="img/products/default.png" alt="소고기">
                        </div>
                        <div class="product-info">
                            <h3 class="product-name">소고기</h3>
                            <p class="product-description">최상급 한우, 부드럽고 맛있는 소고기</p>
                            <div class="product-price">₩25,000</div>
                        </div>
                    </div>
                    <div class="product-card">
                        <div class="product-image">
                            <img src="img/products/default.png" alt="한우">
                        </div>
                        <div class="product-info">
                            <h3 class="product-name">한우</h3>
                            <p class="product-description">프리미엄 한우, 최고급 품질</p>
                            <div class="product-price">₩35,000</div>
                        </div>
                    </div>
                    <div class="product-card">
                        <div class="product-image">
                            <img src="img/products/default.png" alt="돼지 목살 2">
                        </div>
                        <div class="product-info">
                            <h3 class="product-name">돼지 목살 2</h3>
                            <p class="product-description">특선 목살, 더욱 신선한 품질</p>
                            <div class="product-price">₩16,000</div>
                        </div>
                    </div>
                    <div class="product-card">
                        <div class="product-image">
                            <img src="img/products/default.png" alt="삼겹살 2">
                        </div>
                        <div class="product-info">
                            <h3 class="product-name">삼겹살 2</h3>
                            <p class="product-description">프리미엄 삼겹살, 특별한 맛</p>
                            <div class="product-price">₩20,000</div>
                        </div>
                    </div>
                    <%
                    } finally {
                        if (rs != null) rs.close();
                        if (pstmt != null) pstmt.close();
                        if (conn != null) DBUtil.closeConnection(conn);
                    }
                    %>
                </div>
                <div class="product-more">
                    <a href="products.jsp" class="btn btn-secondary">상품 더보기 +</a>
                </div>
            </div>
        </section>

    </main>
    
    <jsp:include page="/common/footer.jsp" />
    
        <script>
        // 슬라이더 변수
        let bannerCurrentSlide = 0;
        let slideInterval;
        const bannerSlides = document.querySelectorAll('.banner-slide');
        const bannerIndicators = document.querySelectorAll('.indicator');
        const totalBannerSlides = bannerSlides.length;

        // 슬라이더 초기화
        function initBannerSlider() {
            showBannerSlide(0);
            startBannerAutoSlide();
        }

        // 슬라이드 표시
        function showBannerSlide(index) {
            // 모든 슬라이드 비활성화
            bannerSlides.forEach(slide => slide.classList.remove('active'));
            bannerIndicators.forEach(indicator => indicator.classList.remove('active'));
            
            // 현재 슬라이드 활성화
            bannerSlides[index].classList.add('active');
            bannerIndicators[index].classList.add('active');
            
            bannerCurrentSlide = index;
        }

        // 다음/이전 슬라이드로 이동
        function changeSlide(direction) {
            let newIndex = bannerCurrentSlide + direction;
            
            if (newIndex >= totalBannerSlides) {
                newIndex = 0;
            } else if (newIndex < 0) {
                newIndex = totalBannerSlides - 1;
            }
            
            showBannerSlide(newIndex);
            resetBannerAutoSlide();
        }

        // 특정 슬라이드로 이동
        function goToSlide(index) {
            showBannerSlide(index - 1);
            resetBannerAutoSlide();
        }

        // 자동 슬라이드 시작
        function startBannerAutoSlide() {
            slideInterval = setInterval(() => {
                changeSlide(1);
            }, 5000); // 5초마다 자동 전환
        }

        // 자동 슬라이드 리셋
        function resetBannerAutoSlide() {
            clearInterval(slideInterval);
            startBannerAutoSlide();
        }

        // 상품 카드 클릭 이벤트
        function setupProductCardEvents() {
            document.querySelectorAll('.product-card').forEach(card => {
                card.addEventListener('click', function(e) {
                    const productId = this.getAttribute('data-product-id');
                    if (productId) {
                        e.preventDefault();
                        window.location.href = `products.jsp?product=${productId}`;
                    }
                });
            });
        }

        // 공지사항 슬라이더 변수
        let noticeCurrentSlide = 0;
        let noticeSlideInterval;
        const noticeSlides = document.querySelectorAll('.notice-slide');
        const noticeIndicators = document.querySelectorAll('.notice-indicator');
        const totalNoticeSlides = noticeSlides.length;

        // 공지사항 슬라이더 초기화
        function initNoticeSlider() {
            if (totalNoticeSlides > 0) {
                showNoticeSlide(0);
                startNoticeAutoSlide();
            }
        }

        // 공지사항 슬라이드 표시
        function showNoticeSlide(index) {
            // 모든 슬라이드 비활성화
            noticeSlides.forEach(slide => slide.classList.remove('active'));
            noticeIndicators.forEach(indicator => indicator.classList.remove('active'));
            
            // 현재 슬라이드 활성화
            if (noticeSlides[index]) {
                noticeSlides[index].classList.add('active');
            }
            if (noticeIndicators[index]) {
                noticeIndicators[index].classList.add('active');
            }
            
            noticeCurrentSlide = index;
        }

        // 공지사항 다음 슬라이드로 이동 (아래에서 위로)
        function changeNoticeSlide() {
            let newIndex = noticeCurrentSlide + 1;
            
            if (newIndex >= totalNoticeSlides) {
                newIndex = 0;
            }
            
            showNoticeSlide(newIndex);
        }

        // 공지사항 특정 슬라이드로 이동
        function goToNoticeSlide(index) {
            showNoticeSlide(index);
            resetNoticeAutoSlide();
        }

        // 공지사항 자동 슬라이드 시작
        function startNoticeAutoSlide() {
            if (totalNoticeSlides > 1) {
                noticeSlideInterval = setInterval(() => {
                    changeNoticeSlide();
                }, 4000); // 4초마다 자동 전환
            }
        }

        // 공지사항 자동 슬라이드 리셋
        function resetNoticeAutoSlide() {
            clearInterval(noticeSlideInterval);
            startNoticeAutoSlide();
        }

        // 공지사항 상세보기 함수
        function viewNotice(noticeId) {
            // 공지사항 상세보기 페이지로 이동
            window.location.href = `notices.jsp?notice=${noticeId}`;
        }

        // DOM 로드 완료 시 초기화
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM 로드 완료');
            
            // 배너 슬라이더 초기화
            initBannerSlider();
            
            // 공지사항 슬라이더 초기화
            initNoticeSlider();
            
            // 상품 카드 클릭 이벤트 설정
            setupProductCardEvents();
        });
    </script>
</body>
</html>
