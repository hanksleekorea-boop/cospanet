# STAGE-2 롤백

migration은 checksum과 이전 스냅샷을 보존한 뒤 단계별로 되돌린다. OAuth secret과 D1 binding은 외부 관리자가 확인한 값만 참조하며, 불일치 시 구성 변경 없이 중단한다.
