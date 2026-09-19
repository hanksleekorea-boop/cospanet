# STAGE-2-FOUNDATION — 구조·데이터·권한·공통 UI 기반

1. 쉬운 말 한 문장 목표: 다음 기능들이 안전하게 얹힐 공통 바닥을 만든다.
2. 사용자에게 보이는 단계 완료 모습: 로그인 전·후, 저장·오류·로딩 상태가 같은 규칙으로 보인다.
3. 포함 범위: 계정 키, D1 스키마, OAuth 계약, API 오류, 공통 화면 상태, 모바일/PC 토큰.
4. 명시적 제외 범위와 이유: 실제 OAuth secret·D1 binding은 외부 관리자 확인 전 제외.
5. 진입 조건 체크리스트: STAGE-1 기준선과 Discovery 결과 완료.
6. 이전 단계에서 받는 입력: 정본 지문, API 목록, 개인정보 경계, 상태 명세.
7. 산출물 파일 목록: 스키마·API 명세, 공통 UI 상태, 권한 테스트 fixture.
8. 요구사항·격차·결정 ID 목록: REQ-001, REQ-003, GAP-001·002, DEC-0001·0002.
9. 작업 의존 관계와 실행 순서: owner key→schema→auth contract→error states→UI tokens.
10. 병렬 실행 가능 작업: API 계약, 화면 상태, 보안 정적검사, 테스트 fixture.
11. 절대 순차 실행 작업: OAuth callback 확정 전 secret 연결 금지; D1 migration 전 API 성공 금지.
12. 예상 변경 파일·기호·설정: `db/schema.ts`, `server/worker.js`, `apps/shared/*`는 후보로만 기록.
13. 데이터·API·UI 계약 변화: account/deal/source_snapshot 타입과 401/403/503 오류 계약.
14. 정상 흐름: 계약 fixture→권한 검증→상태 렌더→로컬 회귀.
15. 빈·로딩·부분 성공 흐름: D1 없음·OAuth 대기·부분 페이지를 명시적 상태로 표시.
16. 실패·권한 거부·오프라인·복구 흐름: 타 계정 403, 네트워크 재시도, 중복 멱등, 로컬 큐.
17. 접근성·다국어·모바일·PC 조건: 포커스 순서·일본어 라벨·360/390/1280/1920 폭.
18. 보안·개인정보·권한 조건: owner filter, CSRF/state/nonce, 가계부 원문 분리.
19. 성능·용량·비용 예산: API timeout·payload 상한·D1 query 예산을 명시하고 측정 전 확정하지 않는다.
20. 자동 시험 묶음: 타입·계약·권한·중복·XSS·URL 차단·기존 회귀.
21. 수동·실기기·외부 서비스 시험 묶음: OAuth 콘솔·D1 binding·두 계정 종단(외부 대기).
22. 중단 신호와 되돌리는 순서: 타 계정 데이터 노출·secret 로그면 즉시 중단→fixture 폐기→원본 보존.
23. 종료 조건과 필요한 증거: schema/API/UI 계약 시험 통과와 실제 binding·callback 증거 슬롯.
24. 다음 단계 인계 체크리스트: 계정·권한 계약, 오류 상태, migration checksum, STAGE-3 fixture.
