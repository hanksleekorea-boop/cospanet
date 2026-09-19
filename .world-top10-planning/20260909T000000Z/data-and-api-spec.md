# 데이터·API 명세

필수 엔터티는 `Account`, `Deal`, `DealRevision`, `Evidence`, `Observation`, `Comment`, `ModerationCase`, `NotificationEvent`, `BudgetEntry`, `PointLedger`다. 서버가 ID·작성자·시각·권한을 생성한다. 동일 요청은 idempotency key로 중복을 막고, 개인 자료와 공개 자료는 저장소·캐시·삭제 경계를 분리한다.
