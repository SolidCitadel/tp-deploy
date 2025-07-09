#!/bin/bash

# 변수 설정
DOMAIN="sldctd-tp-admin-api.kro.kr"
BASE_PATH="/home/ec2-user/app"
LE_PATH="/etc/letsencrypt/live"
CERT_PATH="${BASE_PATH}/nginx/certs"

# 인증서 복사
cp "${LE_PATH}/${DOMAIN}/fullchain.pem" "${CERT_PATH}/fullchain.pem"
cp "${LE_PATH}/${DOMAIN}/privkey.pem" "${CERT_PATH}/privkey.pem"

# 복사된 파일에 모든 사용자가 읽을 수 있는 권한 부여
chmod 644 "${CERT_PATH}/fullchain.pem"
chmod 644 "${CERT_PATH}/privkey.pem"

# (선택 사항) Nginx 컨테이너 리로드하여 새 인증서 적용
# docker-compose.yml이 있는 경로에서 실행해야 함
docker exec reverse-proxy nginx -s reload