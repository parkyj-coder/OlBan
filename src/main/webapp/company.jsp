<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회사소개 - 올반푸드</title>
    <link rel="icon" type="image/x-icon" href="img/logo.png">
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="css/pages/company.css">
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    <main>
        <div class="company-container">
            
            <div class="company-header">
                <h1>회사소개</h1>
                <p>올반푸드는 신뢰와 품질을 바탕으로 프리미엄 육류 유통을 선도합니다.</p>
            </div>
            
            <div class="company-content">
                <section class="company-section">
                    <div class="section-header">
                        <h2>연혁</h2>
                        <p>올반푸드의 성장 과정을 소개합니다</p>
                    </div>
                    <div class="timeline">
                        <div class="timeline-item">
                            <div class="timeline-year">2024</div>
                            <div class="timeline-content">
                                <h3>프리미엄 브랜드 리뉴얼</h3>
                                <p>고객 중심의 새로운 브랜드 아이덴티티로 업그레이드</p>
                            </div>
                        </div>
                        <div class="timeline-item">
                            <div class="timeline-year">2022</div>
                            <div class="timeline-content">
                                <h3>전국 유통망 확장</h3>
                                <p>전국 주요 도시에 물류센터 구축 및 배송망 확대</p>
                            </div>
                        </div>
                        <div class="timeline-item">
                            <div class="timeline-year">2020</div>
                            <div class="timeline-content">
                                <h3>HACCP 인증 획득</h3>
                                <p>식품안전관리인증체계(HACCP) 인증으로 품질 관리 강화</p>
                            </div>
                        </div>
                        <div class="timeline-item">
                            <div class="timeline-year">2018</div>
                            <div class="timeline-content">
                                <h3>올반푸드 설립</h3>
                                <p>프리미엄 육류 유통 전문기업으로 시작</p>
                            </div>
                        </div>
                    </div>
                </section>
                
                <section class="company-section">
                    <div class="section-header">
                        <h2>비전</h2>
                        <p>올반푸드가 추구하는 미래</p>
                    </div>
                    <div class="vision-content">
                        <div class="vision-card">
                            <div class="vision-icon">🎯</div>
                            <h3>미션</h3>
                            <p>고객에게 최고의 신선함과 신뢰를 제공하는<br>대한민국 대표 육류 유통기업</p>
                        </div>
                        <div class="vision-card">
                            <div class="vision-icon">🌟</div>
                            <h3>핵심가치</h3>
                            <p>신뢰, 품질, 혁신, 고객만족을 바탕으로<br>지속가능한 성장을 추구합니다</p>
                        </div>
                    </div>
                </section>
                
                <section class="company-section">
                    <div class="section-header">
                        <h2>인증 및 수상</h2>
                        <p>올반푸드의 품질과 신뢰를 인정받은 성과들</p>
                    </div>
                    <div class="cert-grid">
                        <div class="cert-item">
                            <div class="cert-icon">🏆</div>
                            <h3>HACCP 인증</h3>
                            <p>식품안전관리인증체계 인증으로<br>최고 수준의 품질 관리</p>
                        </div>
                        <div class="cert-item">
                            <div class="cert-icon">⭐</div>
                            <h3>우수기업상</h3>
                            <p>2023년 식품산업협회<br>우수기업상 수상</p>
                        </div>
                        <div class="cert-item">
                            <div class="cert-icon">🔒</div>
                            <h3>ISO 9001</h3>
                            <p>국제표준 품질경영시스템<br>인증 획득</p>
                        </div>
                    </div>
                </section>
                
                <section class="company-section">
                    <div class="section-header">
                        <h2>회사 정보</h2>
                        <p>올반푸드의 기본 정보를 확인하세요</p>
                    </div>
                    <div class="company-info">
                        <div class="info-grid">
                            <div class="info-item">
                                <div class="info-label">회사명</div>
                                <div class="info-value">올반푸드(주)</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">대표이사</div>
                                <div class="info-value">김철수</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">설립일</div>
                                <div class="info-value">2018년 3월 15일</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">사업자등록번호</div>
                                <div class="info-value">123-45-67890</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">주소</div>
                                <div class="info-value">서울특별시 강남구 테헤란로 123<br>올반빌딩 8층</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">연락처</div>
                                <div class="info-value">02-1234-5678</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">이메일</div>
                                <div class="info-value">info@olbanfood.com</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">사업영역</div>
                                <div class="info-value">육류 유통 및 판매</div>
                            </div>
                        </div>
                    </div>
                </section>
            </div>
        </div>
    </main>
    <jsp:include page="/common/footer.jsp" />
</body>
</html>
