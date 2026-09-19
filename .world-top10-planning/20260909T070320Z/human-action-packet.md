# 외부·사람 행동 패킷

이 문서는 사용자가 직접 결정하거나 외부 계정·사람이 수행해야 하는 작업만 모은다. 자동화가 대신 실행하지 않았다.

1. **Google Cloud 관리자**: WeSaver 프로젝트의 OAuth client ID, 허용 origin, callback URL, secret 참조를 확인하고 비밀값 원문은 채팅·Git에 남기지 않는다.
2. **Cloudflare 관리자**: 기존 D1을 재사용할지 계정 한도 내 안전한 대체 경로를 결정하고 `kospanet` Worker에 binding을 추가한다.
3. **Cloudflare DNS 관리자**: `kospanet.scanners.cc` zone과 Worker route/TLS를 연결하고 공개 HTTPS 응답을 확인한다.
4. **운영 책임자**: 법적 운영 주체, 문의 채널, 신고·이의·삭제 SLA, 콘텐츠 권리 승인자를 확정한다.
5. **콘텐츠 운영자**: 실제 일본 출처·점포의 사용권과 확인 시각을 등록하고 만료·철회 절차를 훈련한다.
6. **사용자**: 연결된 두 기기 중 승인된 유휴 Android 한 대만 지정한다. 다른 기기는 조작하지 않는다.
7. **QA/법무**: TalkBack/Narrator, 삭제·복구, 광고 CMP, 개인정보 보존·파기 정책을 사람 증거로 남긴다.

재개 순서는 `D1 → OAuth → DNS → A/B 계정 종단 → 실제 콘텐츠/운영 → Android/접근성 → 광고·법률 → 공개 인수`다.
