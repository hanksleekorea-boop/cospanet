# 5단계 의존성 그래프

`STAGE-1-BASELINE → STAGE-2-FOUNDATION → STAGE-3-CORE → STAGE-4-QUALITY → STAGE-5-RELEASE`의 단일 순서다. 각 단계는 앞 단계 종료 조건을 모두 받아야 진입한다.

## 핵심 작업 의존

`DISCOVERY-001(현재 정본·기호 확인) → TASK-1-001(D1) → TASK-1-002(OAuth) → TASK-1-003(DNS) → TASK-2-001(계정·권한) → TASK-3-001(굿딜 핵심) → TASK-4-001(성능·접근성·보안) → TASK-5-001(공개 인수)`.

병렬 가능: 문서 인벤토리, 정적 보안 검사, UI 상태 목록, 시험 fixture 설계. 절대 순차: 비밀값 등록 전 OAuth 왕복, D1 binding 전 계정 저장, 실제 운영자 확정 전 삭제·문의 인수, 지정 DNS 확인 전 공개 URL 인수.
