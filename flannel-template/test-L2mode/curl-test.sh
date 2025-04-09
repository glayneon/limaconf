#!/bin/bash

# filepath: test_k8s_svc.sh

# Kubernetes 서비스의 URL
SERVICE_URL="http://192.168.104.200"

# 요청 간격 및 총 실행 시간 설정
REQUESTS_PER_SECOND=100
DURATION_SECONDS=30
TIMEOUT=1

# 성공한 요청 수를 저장할 변수
SUCCESS_COUNT=0

# 요청 루프
curl_test() {
for ((i=1; i<=DURATION_SECONDS; i++)); do
  for ((j=1; j<=REQUESTS_PER_SECOND; j++)); do
    # 비동기로 요청을 보내고 결과 확인
    echo "$(date +%T:%N) : curl -m 1 -s -o /dev/null -w '%{http_code}'.." 
    HTTP_STATUS=$(curl -m ${TIMEOUT} -s -o /dev/null -w "%{http_code}" "${SERVICE_URL}?$(date +%N)")
    if [ "$HTTP_STATUS" -eq 200 ]; then
      echo "$(date +%T:%N) : Done..."
      ((SUCCESS_COUNT++))
      HTTP_STATUS=000
    fi
  done
  echo $SUCCESS_COUNT

  # 1초 대기
  # sleep 1
done

# 모든 요청이 완료될 때까지 대기
wait

# 성공한 요청 수 출력
echo "Total successful requests: $SUCCESS_COUNT"
}

curl_test


