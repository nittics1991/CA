#!/bin/bash
#
#   RootCa作成
#
set -e

cd $(dirname "$0");
cd ..

#設定読み込み
source setting.cnf

#初期ファイル
if [[ ! -a "${DIR_ROOT_CA}/index.txt" ]] ; then
    touch "${DIR_ROOT_CA}/index.txt"
    echo 00 > "${DIR_ROOT_CA}/crlnumber"
fi

#重複生成防止
if [[ -a "${DIR_ROOT_CA}/${DIR_PRIVATE}/${PRIVATE_KEY_ROOT_CA}" ]] ; then
    echo "same file name exists"
    exit 1
fi

#private key & cert生成
openssl req \
    -config "${DIR_ROOT_CA}/openssl.cnf" \
    -keyout "${DIR_ROOT_CA}/${DIR_PRIVATE}/${PRIVATE_KEY_ROOT_CA}" \
    -out "${DIR_ROOT_CA}/${DIR_CERT}/${CERT_ROOT_CA}" \
    -days "${DAYS_ROOT_CA}" \
    -subj "${SUBJ_ROOT_CA}" \
    -passout pass:"${PASS_PRIVATE_ROOT_CA}" \
    -new \
    -x509 \
    -extensions v3_ca \
    -batch

#証明書表示
#openssl x509 \
    #-noout \
     #-text \
     #-in "${DIR_ROOT_CA}/${DIR_CERT}/${CERT_ROOT_CA}"
