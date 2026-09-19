# 5단계 위험·롤백 등록부

| 위험 | 조기 신호 | 중단 | 롤백 순서 |
|---|---|---|---|
| D1 binding 오류 | 503·타 계정 자료 | 즉시 중단 | binding 제거→migration 보존→로그 확인 |
| OAuth 오설정 | state/nonce 실패·redirect mismatch | 로그인 노출 금지 | secret 참조 제거→callback 원복 |
| DNS 오연결 | TLS/404/다른 서비스 | 공개 인수 중단 | route 비활성→DNS 원복 |
| 권리 없는 콘텐츠 | source_rights 미확인 | 자동공개 false | 항목 격리→철회 전파 |
| 운영자 부재 | 문의 미수신 | 출시 중단 | 지원 배너 비활성→사건 보존 |
| Android 미승인 | adb unauthorized | 기기 조작 중단 | 연결 해제 요청→다른 기기 조작 금지 |
| 광고 동의 누락 | opt-out 후 광고 요청 | 광고 OFF | CMP 정책 롤백→로그 보존 |
| 복구 불일치 | checksum mismatch | 복원 중단 | 원본 백업 보존→수동 검토 |

제품 코드의 실제 롤백 명령은 해당 작업카드가 파일·기호·권한을 확인한 뒤에만 추가한다. 추측 명령을 제공하지 않는다.
