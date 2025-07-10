#!/bin/bash

# 1. 배포된 애플리케이션 경로로 이동
cd /home/ec2-user/app/

# 2. 환경 변수 확인
if [ ! -f .env.host ]; then
  echo "Error: .env.host file not found."
  exit 1
fi

# 3. docker-compose로 애플리케이션 실행
#    'up' 명령어는 변경된 서비스(예: 이미지가 바뀐 spring-app)만 지능적으로 다시 생성합니다.
#    Nginx는 변경사항이 없으므로 건드리지 않습니다.
#    -d: 백그라운드에서 실행
docker-compose up --env-file .env.host -d

# 4. 오래된 미사용 이미지 정리
docker image prune -f -a