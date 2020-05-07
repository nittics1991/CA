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
    -extensions client_cert \
    -rand_serial \
    -batch


#最新ファイルを検索
NEWEST_CERT_ROOT_CA=$(ls -1t "${DIR_ROOT_CA}/${DIR_CERT}" | sed -n 1P)
NEWEST_CERT_INTER_CA=$(ls -1t "${DIR_INTER_CA}/${DIR_CERT}" | sed -n 1P)
#NEWEST_CERT_SERVER=$(ls -1t "${DIR_SERVER}/${DIR_CERT}" | sed -n 1P)
NEWEST_CERT_CLIENT=$(ls -1t "${DIR_CLIENT}/${DIR_CERT}" | sed -n 1P)

#証明書集約
cat "${DIR_ROOT_CA}/${DIR_CERT}/${NEWEST_CERT_ROOT_CA}" > \
    "${DIR_CLIENT}/${DIR_DIST}/${JOINED_CERT_CLIENT}"
cat "${DIR_INTER_CA}/${DIR_CERT}/${NEWEST_CERT_INTER_CA}" >> \
    "${DIR_CLIENT}/${DIR_DIST}/${JOINED_CERT_CLIENT}"
#cat "${DIR_SERVER}/${DIR_CERT}/${NEWEST_CERT_SERVER}" >> \
    #"${DIR_CLIENT}/${DIR_DIST}/${JOINED_CERT_CLIENT}"
cat "${DIR_CLIENT}/${DIR_CERT}/${NEWEST_CERT_CLIENT}" >> \
    "${DIR_CLIENT}/${DIR_DIST}/${JOINED_CERT_CLIENT}"

#pkcs12ファイル生成
openssl pkcs12 \
    -in "${DIR_CLIENT}/${DIR_DIST}/${JOINED_CERT_CLIENT}" \
    -out "${DIR_CLIENT}/${DIR_PKCS12}/${PKCS12_CLIENT}" \
    -inkey "${DIR_CLIENT}/${DIR_PRIVATE}/${PRIVATE_KEY_CLIENT}" \
    -passin pass:"${PASS_PRIVATE_CLIENT}" \
    -passout pass:"" \
    -name "${PKCS12_NAME_CLIENT}" \
    -export
