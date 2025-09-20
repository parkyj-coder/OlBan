# CSS 폴더 구조 및 관리 가이드

## 📁 폴더 구조

```
css/
├── main.css              # 메인 공통 스타일
├── pages/                # 페이지별 전용 스타일
│   ├── login.css         # 로그인 페이지
│   ├── join.css          # 회원가입 페이지
│   ├── products.css      # 상품 목록 페이지
│   ├── productDetail.css # 상품 상세 페이지
│   ├── cart.css          # 장바구니 페이지
│   ├── company.css       # 회사소개 페이지
│   ├── inquiry.css       # 문의사항 페이지
│   ├── notices.css       # 공지사항 페이지
│   ├── admin.css         # 관리자 페이지 공통
│   └── admin-notice.css  # 관리자 공지사항 관리
├── components/           # 재사용 가능한 컴포넌트
│   └── slider.css        # 슬라이더 컴포넌트
└── README.md            # 이 파일
```

## 🎨 스타일 관리 원칙

### 1. **모듈화된 구조**
- 각 페이지별로 독립적인 CSS 파일 관리
- 공통 스타일은 `main.css`에 정의
- 재사용 가능한 컴포넌트는 `components/` 폴더에 배치

### 2. **네이밍 컨벤션**
- 클래스명: kebab-case 사용 (예: `notice-item`, `page-header`)
- 페이지별 접두사: 페이지명으로 시작 (예: `.notices-page`, `.admin-header`)
- 상태 클래스: `-active`, `-inactive`, `-disabled` 등 사용

### 3. **반응형 디자인**
- 모든 페이지에서 모바일 우선 접근법 적용
- 미디어 쿼리: `@media (max-width: 768px)` 사용
- 유연한 그리드 시스템 활용

## 📱 페이지별 스타일 가이드

### 공지사항 페이지 (`notices.css`)
```css
/* 주요 클래스 */
.notices-page          # 페이지 컨테이너
.notices-container     # 콘텐츠 래퍼
.search-section        # 검색 영역
.notices-list          # 공지사항 목록
.notice-item           # 개별 공지사항
.pagination           # 페이지네이션
```

### 관리자 페이지 (`admin.css`, `admin-notice.css`)
```css
/* 주요 클래스 */
.admin-container      # 관리자 레이아웃
.admin-header         # 관리자 헤더
.admin-nav           # 관리자 네비게이션
.notice-management    # 공지사항 관리 영역
.notice-table        # 공지사항 테이블
.add-notice-form     # 공지사항 추가 폼
```

## 🔧 유지보수 가이드

### 새 페이지 추가 시
1. `pages/` 폴더에 새로운 CSS 파일 생성
2. JSP 파일에서 외부 CSS 파일 연결
3. 인라인 스타일 제거
4. README 파일 업데이트

### 스타일 수정 시
1. 해당 페이지의 CSS 파일만 수정
2. 다른 페이지에 영향이 없는지 확인
3. 반응형 디자인 테스트

### 공통 스타일 변경 시
1. `main.css`에서 수정
2. 모든 페이지에서 일관성 확인
3. 브레이킹 체인지 검토

## 🎯 색상 팔레트

```css
/* 주요 색상 */
--primary-color: #007bff;      # 메인 블루
--secondary-color: #6c757d;    # 그레이
--success-color: #28a745;      # 그린
--danger-color: #dc3545;       # 레드
--warning-color: #ffc107;      # 옐로우
--info-color: #17a2b8;         # 시안

/* 텍스트 색상 */
--text-primary: #2c3e50;       # 주요 텍스트
--text-secondary: #64748b;     # 보조 텍스트
--text-muted: #94a3b8;         # 흐린 텍스트
```

## 📐 레이아웃 시스템

### 컨테이너
```css
.container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 20px;
}
```

### 그리드 시스템
```css
.grid {
    display: grid;
    gap: 20px;
}

.grid-2 { grid-template-columns: repeat(2, 1fr); }
.grid-3 { grid-template-columns: repeat(3, 1fr); }
.grid-4 { grid-template-columns: repeat(4, 1fr); }
```

### 반응형 그리드
```css
@media (max-width: 768px) {
    .grid-2, .grid-3, .grid-4 {
        grid-template-columns: 1fr;
    }
}
```

## 🚀 성능 최적화

### CSS 최적화 팁
1. **불필요한 스타일 제거**: 사용하지 않는 CSS 클래스 정리
2. **중복 스타일 통합**: 동일한 스타일은 공통 클래스로 분리
3. **캐싱 활용**: 브라우저 캐싱을 위한 파일명 관리
4. **압축**: 프로덕션 환경에서 CSS 압축 적용

### 로딩 최적화
```html
<!-- 페이지별 CSS 로딩 -->
<link rel="stylesheet" href="css/main.css">
<link rel="stylesheet" href="css/pages/notices.css">
```

## 📋 체크리스트

### 새 페이지 개발 시
- [ ] 페이지별 CSS 파일 생성
- [ ] 인라인 스타일 제거
- [ ] 반응형 디자인 적용
- [ ] 접근성 고려
- [ ] 브라우저 호환성 테스트

### 스타일 수정 시
- [ ] 영향 범위 확인
- [ ] 반응형 테스트
- [ ] 크로스 브라우저 테스트
- [ ] 성능 영향 검토

---

**마지막 업데이트**: 2024년 1월
**담당자**: 개발팀 