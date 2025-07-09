#!/bin/bash

# 배포된 애플리케이션 경로로 이동
cd /home/ec2-user/app/

# 환경 변수 파일 경로
ENV_FILE="/home/ec2-user/app/.env"

# 1. imagedefinitions.json 파일에서 이미지 URI 추출
# 이 파일은 CodeBuild 아티팩트로부터 CodeDeploy가 이 위치에 복사해 줍니다.
IMAGE_URI=$(cat imagedefinitions.json | jq -r '.[0].imageUri')

# 2. 기존에 실행 중인 컨테이너가 있으면 중지 및 제거
CONTAINER_NAME="tp-admin-api"
if [ $(docker ps -q -f name=$CONTAINER_NAME) ]; then
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
fi

# 3. 최신 이미지로 새 컨테이너 실행
# --env-file 옵션으로 환경 변수 파일을 지정합니다.
if [ -f "$ENV_FILE" ]; then
    docker run -d --name $CONTAINER_NAME -p 8081:8081 --env-file $ENV_FILE $IMAGE_URI
else
    docker run -d --name $CONTAINER_NAME -p 8081:8081 $IMAGE_URI
fi

# 4. 오래된 미사용 이미지 정리 (선택 사항)
docker image prune -f