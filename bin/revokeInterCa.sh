#!/bin/bash
#
#   DB=InterCa失効処理
#
#   $1:証明書ファイル名(PATH固定)
set -e

cd $(dirname "$0");
cd ..

#設定読み込み
source setting.cnf

if [[ -a "${DIR_SERVER}/${DIR_CERT}/$1" ]] ; then
    REVOKE_FILE="${DIR_SERVER}/${DIR_CERT}/$1"
elif [[ -a "${DIR_CLIENT}/${DIR_CERT}/$1" ]] ; then
    REVOKE_FILE="${DIR_CLIENT}/${DIR_CERT}/$1"
else
    echo "file not exists"
    exit 1
fi

#失効
openssl ca \
    -config "${DIR_INTER_CA}/openssl.cnf" \
    -revoke "${REVOKE_FILE}" \
    -keyfile "${DIR_INTER_CA}/${DIR_PRIVATE}/${PRIVATE_KEY_INTER_CA}" \
    -passin "pass:${PASS_PRIVATE_INTER_CA}" \
    -cert "${DIR_INTER_CA}/${DIR_CERT}/${CERT_INTER_CA}" \
    -out "${DIR_INTER_CA}/${DIR_CRL}/${CRL_INTER_CA}" \
    -crldays "${CRL_DAYS_INTER_CA}" \
    -gencrl
