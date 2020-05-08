#!/bin/bash
#
#   Server作成
#
set -e

cd $(dirname "$0");
cd ..

#設定読み込み
source setting.cnf

#重複生成防止
if [[ -a "${DIR_SERVER}/${DIR_PRIVATE}/${PRIVATE_KEY_SERVER}" ]] ; then
    echo "same file name exists"
    exit 1
fi

#csr生成
openssl req \
    -config "${DIR_SERVER}/openssl.cnf" \
    -keyout "${DIR_SERVER}/${DIR_PRIVATE}/${PRIVATE_KEY_SERVER}" \
    -out "${DIR_SERVER}/${DIR_CSR}/${CSR_SERVER}" \
    -days "${DAYS_SERVER}" \
    -subj "${SUBJ_SERVER}" \
    -passout pass:"${PASS_PRIVATE_SERVER}" \
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
    -in "${DIR_SERVER}/${DIR_CSR}/${CSR_SERVER}" \
    -out "${DIR_SERVER}/${DIR_CERT}/${CERT_SERVER}" \
    -keyfile "${DIR_INTER_CA}/${DIR_PRIVATE}/${NEWEST_PRIVATE_KEY_INTER_CA}" \
    -passin pass:"${PASS_PRIVATE_INTER_CA}" \
    -cert "${DIR_INTER_CA}/${DIR_CERT}/${NEWEST_CERT_INTER_CA}" \
    -days "${DAYS_SERVER}" \
    -subj "${SUBJ_SERVER}" \
    -extensions server_cert \
    -rand_serial \
    -batch

#private key パスフレーズ除去ファイル生成
openssl rsa \
    -in "${DIR_SERVER}/${DIR_PRIVATE}/${PRIVATE_KEY_SERVER}" \
    -out "${DIR_SERVER}/${DIR_PRIVATE}/${NO_PASS_PRIVATE_KEY}"

#最新ファイルを検索
NEWEST_CERT_ROOT_CA=$(ls -1t "${DIR_ROOT_CA}/${DIR_CERT}" | sed -n 1P)
NEWEST_CERT_INTER_CA=$(ls -1t "${DIR_INTER_CA}/${DIR_CERT}" | sed -n 1P)
NEWEST_CERT_SERVER=$(ls -1t "${DIR_SERVER}/${DIR_CERT}" | sed -n 1P)
#NEWEST_CERT_CLIENT=$(ls -1t "${DIR_CLIENT}/${DIR_CERT}" | sed -n 1P)

#証明書集約
cat "${DIR_ROOT_CA}/${DIR_CERT}/${NEWEST_CERT_ROOT_CA}" > \
    "${DIR_SERVER}/${DIR_DIST}/${JOINED_CERT_SERVER}"
cat "${DIR_INTER_CA}/${DIR_CERT}/${NEWEST_CERT_INTER_CA}" >> \
    "${DIR_SERVER}/${DIR_DIST}/${JOINED_CERT_SERVER}"
cat "${DIR_SERVER}/${DIR_CERT}/${NEWEST_CERT_SERVER}" >> \
    "${DIR_SERVER}/${DIR_DIST}/${JOINED_CERT_SERVER}"
# cat "${DIR_SERVER}/${DIR_CERT}/${NEWEST_CERT_CLIENT}" >> \
    # "${DIR_SERVER}/${DIR_DIST}/${JOINED_CERT_SERVER}"

#pkcs12ファイル生成
openssl pkcs12 \
    -in "${DIR_SERVER}/${DIR_DIST}/${JOINED_CERT_SERVER}" \
    -out "${DIR_SERVER}/${DIR_PKCS12}/${PKCS12_SERVER}" \
    -inkey "${DIR_SERVER}/${DIR_PRIVATE}/${NO_PASS_PRIVATE_KEY}" \
    -passout pass:"" \
    -name "${PKCS12_NAME_SERVER}" \
    -export

#    -passin pass:"${PASS_PRIVATE_SERVER}" \
