# v3.2 원샷 완결성 매트릭스

| 게이트 | 상태 | 사실 근거 | 다음 조건 |
|---|---|---|---|
| G0 대상·판 고정 | PASS | README·현재 정본·공개 후보 등록 | 도메인 선택 재확인 |
| G1 공용 증거 | PARTIAL | 로컬·역사·웹 공식 자료 혼합 | 현재 공개판·권리 증거 |
| G2 후보군 | PARTIAL_REUSED | 10개 역사 후보 | 800개 또는 전수 포화 |
| G3 톱10 | PASS_HISTORICAL | 10개 고정 lock | 현재성 독립 확인 |
| G4 벤치마크 | PARTIAL | 8분야·32 score seed | 1,600 원자 지표 |
| G5 갭 | PASS_DRAFT | 20개 갭·의존성 | 실제 운영 영향 검증 |
| G6 제품기획 | PASS_DRAFT | 통합 제품기획 초안 | 승인된 결정 셀 |
| G7 5단계 개발 | PASS_DRAFT | 단계·작업·시험 계약 | 64필드 카드 |
| G8 품질 | PARTIAL | 구조·ID·링크 일부 검사 | 100 negative + 10k edge |
| Readiness | BLOCKED_EXTERNAL | D1/OAuth/DNS/사람 증거 부재 | 외부 관문 수행 |

최종 상태: `X10_PARTIAL_SCOPE + PARTIAL_EVIDENCE + BLOCKED_EXTERNAL`.
