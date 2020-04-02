#!/usr/bin/env bash

ABSPATH=$(readlink -f $0)
ABSDIR=$(dirname $ABSPATH)
# shellcheck disable=SC1090
source ${ABSDIR}/profile.sh
# shellcheck disable=SC1090
source ${ABSDIR}/switch.sh

IDLE_PORT=$(find_idle_port)

echo "> Health Check start!!"
echo "> IDLE_PORT: $IDLE_PORT"
echo "> curl -s http://localhost:$IDLE_PORT/profile"
sleep 10

for RETRY_COUNT in {1..10}
do
  RESPONSE=$(curl -s http://localhost:${IDLE_PORT}/profile)
  UP_COUNT=$(echo ${RESPONSE} | grep 'real' | wc -l)

  if [ ${UP_COUNT} -ge 1 ]
  then # 문자열 검증
    echo "> Health Check success!!"
    switch_proxy
    break
  else
    echo "> Health Check의 응답을 알 수 없거나 혹은 실행 상태가 아닙니다."
    echo "> Health Check: ${RESPONSE}"
  fi

  echo "> Health Check 연결 실패. 재시도..."
  sleep 10
done


