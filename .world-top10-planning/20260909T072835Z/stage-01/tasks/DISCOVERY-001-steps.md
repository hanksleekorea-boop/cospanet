# DISCOVERY-001 미세 단계

STEP-01 — 현재 workspace 절대경로를 확인한다.
- 왜 하는가: 다른 프로젝트를 읽지 않기 위해서다.
- 확인: `Get-Location`과 workspace 비교.

STEP-02 — AGENTS.md와 HANDOFF 지문을 확인한다.
- 왜 하는가: 규칙·정본을 먼저 고정하기 위해서다.
- 확인: 파일 존재·SHA-256.

STEP-03 — STATE·HISTORY·TEST_EVIDENCE를 읽는다.
- 왜 하는가: 다음 행동과 과거 증거를 구분하기 위해서다.
- 확인: 최신 항목 날짜.

STEP-04 — `git status --short --branch`를 읽는다.
- 왜 하는가: 사용자 변경을 보존하기 위해서다.
- 확인: 상태를 새 분석 증거에 기록.

STEP-05 — D1 binding 후보 이름만 검색한다.
- 왜 하는가: 비밀값 없이 저장소 위치를 찾기 위해서다.
- 금지: 토큰·secret 출력.

STEP-06 — OAuth callback·origin 후보를 검색한다.
- 왜 하는가: WeSaver 연결 지점을 찾기 위해서다.
- 확인: 값은 존재/부재만 기록.

STEP-07 — `kospanet.scanners.cc` DNS·route 후보를 확인한다.
- 왜 하는가: 지정 공개 주소의 선행조건을 찾기 위해서다.
- 확인: 해석/미해석 상태.

STEP-08 — 공개 URL의 HTTP 상태만 확인한다.
- 왜 하는가: 200을 OAuth·D1 성공으로 오인하지 않기 위해서다.
- 확인: 경로·시각·상태.

STEP-09 — 결과를 `stage-01/evidence/discovery-001.md`에 쓴다.
- 왜 하는가: 다음 카드가 동일한 값을 재현하도록 하기 위해서다.
- 확인: 비밀값 없음.

STEP-10 — 미확인 항목마다 DISCOVERY-ID와 다음 명령을 붙인다.
- 왜 하는가: “알아서”를 없애기 위해서다.
- 확인: 빈 unknown 0.

STEP-11 — 이 카드 상태를 READY로 승격할 수 있는지 판정한다.
- 왜 하는가: 외부 관문 전 구현을 시작하지 않기 위해서다.
- 확인: `ready=false` 유지.

STEP-12 — TASK-1-001~003 인계값을 작성한다.
- 왜 하는가: 다음 AI가 재기획하지 않고 이어가기 위해서다.
- 확인: handoff 파일과 traceability 일치.

주의: 한 단계에서 제품 코드·배포·외부 설정을 수정하지 않는다. 실패 시 새 시도를 반복하지 말고 실패 원인·재개 조건만 기록한다.
