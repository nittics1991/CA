#!/bin/bash
#
#   DB=RootCa失効処理
#
#   $1:証明書ファイル名(PATH固定)
set -e

cd $(dirname "$0");
cd ..

#設定読み込み
source setting.cnf

if [[ ! -a "${DIR_INTER_CA}/${DIR_CERT}/$1" ]] ; then
    echo "file not exists"
    exit 1
fi

#失効
openssl ca \
    -config "${DIR_ROOT_CA}/openssl.cnf" \
    -revoke "${DIR_INTER_CA}/${DIR_CERT}/${CERT_INTER_CA}" \
    -keyfile "${DIR_ROOT_CA}/${DIR_PRIVATE}/${PRIVATE_KEY_ROOT_CA}" \
    -passin "pass:${PASS_PRIVATE_ROOT_CA}" \
    -cert "${DIR_ROOT_CA}/${DIR_CERT}/${CERT_ROOT_CA}" \
    -out "${DIR_ROOT_CA}/${DIR_CRL}/${CRL_ROOT_CA}" \
    -crldays "${CRL_DAYS_ROOT_CA}" \
    -gencrl
