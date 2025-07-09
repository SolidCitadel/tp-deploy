#!/bin/bash

# 배포된 애플리케이션 경로로 이동
cd /home/ec2-user/app/

# 1. imagedefinitions.json 파일에서 최신 이미지 URI 추출
IMAGE_URI=$(cat imagedefinitions.json | jq -r '.[0].imageUri')

# 2. 추출한 이미지 URI를 환경 변수로 내보내기(export)
#    이렇게 해야 docker-compose.yml 파일이 ${SPRING_APP_IMAGE_URI} 변수를 읽을 수 있습니다.
export SPRING_APP_IMAGE_URI=$IMAGE_URI

# 3. docker-compose로 애플리케이션 실행
#    'up' 명령어는 변경된 서비스(예: 이미지가 바뀐 spring-app)만 지능적으로 다시 생성합니다.
#    Nginx는 변경사항이 없으므로 건드리지 않습니다.
#    -d: 백그라운드에서 실행
docker-compose up -d

# 4. 오래된 미사용 이미지 정리 (선택 사항)
docker image prune -f