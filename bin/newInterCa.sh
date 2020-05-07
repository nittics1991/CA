#!/bin/bash
#
#   InterCa作成
#
set -e

cd $(dirname "$0");
cd ..

#設定読み込み
source setting.cnf

#初期ファイル
if [[ ! -a "${DIR_INTER_CA}/index.txt" ]] ; then
    touch "${DIR_INTER_CA}/index.txt"
    echo 00 > "${DIR_INTER_CA}/crlnumber"
fi

#重複生成防止
if [[ -a "${DIR_INTER_CA}/${DIR_PRIVATE}/${PRIVATE_KEY_INTER_CA}" ]] ; then
    echo "same file name exists"
    exit 1
fi

#csr生成
openssl req \
    -config "${DIR_INTER_CA}/openssl.cnf" \
    -keyout "${DIR_INTER_CA}/${DIR_PRIVATE}/${PRIVATE_KEY_INTER_CA}" \
    -out "${DIR_INTER_CA}/${DIR_CSR}/${CSR_INTER_CA}" \
    -days "${DAYS_INTER_CA}" \
    -subj "${SUBJ_INTER_CA}" \
    -passout pass:"${PASS_PRIVATE_INTER_CA}" \
    -new \
    -batch

#root caの最新ファイルを検索
NEWEST_CERT_ROOT_CA=$(ls -1t "${DIR_ROOT_CA}/${DIR_CERT}" | sed -n 1P)
NEWEST_PRIVATE_KEY_ROOT_CA=$(ls -1t "${DIR_ROOT_CA}/${DIR_PRIVATE}" | sed -n 1P)

echo "${NEWEST_CERT_ROOT_CA}"
echo "${NEWEST_PRIVATE_KEY_ROOT_CA}"

openssl ca \
    -config "${DIR_ROOT_CA}/openssl.cnf" \
    -in "${DIR_INTER_CA}/${DIR_CSR}/${CSR_INTER_CA}" \
    -out "${DIR_INTER_CA}/${DIR_CERT}/${CERT_INTER_CA}" \
    -keyfile "${DIR_ROOT_CA}/${DIR_PRIVATE}/${NEWEST_PRIVATE_KEY_ROOT_CA}" \
    -passin pass:"${PASS_PRIVATE_ROOT_CA}" \
    -cert "${DIR_ROOT_CA}/${DIR_CERT}/${NEWEST_CERT_ROOT_CA}" \
    -days "${DAYS_INTER_CA}" \
    -subj "${SUBJ_INTER_CA}" \
    -extensions v3_ca \
    -rand_serial \
    -batch
