#!/bin/bash
#
#   Client作成
#
set -e

cd $(dirname "$0");
cd ..

#設定読み込み
source setting.cnf

#重複生成防止
if [[ -a "${DIR_CLIENT}/${DIR_PRIVATE}/${PRIVATE_KEY_CLIENT}" ]] ; then
    echo "same file name exists"
    exit 1
fi

#csr生成
openssl req \
    -config "${DIR_CLIENT}/openssl.cnf" \
    -keyout "${DIR_CLIENT}/${DIR_PRIVATE}/${PRIVATE_KEY_CLIENT}" \
    -out "${DIR_CLIENT}/${DIR_CSR}/${CSR_CLIENT}" \
    -days "${DAYS_CLIENT}" \
    -subj "${SUBJ_CLIENT}" \
    -passout pass:"${PASS_PRIVATE_CLIENT}" \
    -new \
    -batch

#inter caの最新ファイルを検索
NEWEST_CERT_INTER_CA=$(ls -1t "${DIR_INTER_CA}/${DIR_CERT}" | sed -n 1P)
NEWEST_PRIVATE_KEY_INTER_CA=$(ls -1t "${DIR_INTER_CA}/${DIR_PRIVATE}" | sed -n 1P)

echo "${NEWEST_CERT_INTER_CA}"
echo "${NEWEST_PRIVATE_KEY_INTER_CA}"

#署名
openssl ca \
    -config "${DIR_INTER_CA}/openssl.cnf" \
    -in "${DIR_CLIENT}/${DIR_CSR}/${CSR_CLIENT}" \
    -out "${DIR_CLIENT}/${DIR_CERT}/${CERT_CLIENT}" \
    -keyfile "${DIR_INTER_CA}/${DIR_PRIVATE}/${NEWEST_PRIVATE_KEY_INTER_CA}" \
    -passin pass:"${PASS_PRIVATE_INTER_CA}" \
    -cert "${DIR_INTER_CA}/${DIR_CERT}/${NEWEST_CERT_INTER_CA}" \
    -days "${DAYS_CLIENT}" \
    -subj "${SUBJ_CLIENT}" \
    -extensions my_client \
    -rand_serial \
    -batch

#pkcs12ファイル生成



