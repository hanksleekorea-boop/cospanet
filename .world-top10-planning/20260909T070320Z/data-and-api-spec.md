# 데이터·API 명세

핵심 엔터티는 account, deal, source_snapshot, store, observation, ledger_expense, point_event, moderation_case다. 모든 쓰기는 owner key·멱등키·출처·확인시각을 확인하며 D1 미바인딩 시 성공을 가장하지 않고 명시적 오류를 반환한다.
