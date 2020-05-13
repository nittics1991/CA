#!/bin/bash
#
#   
#
#set -e

cd $(dirname "$0");
cd ..

#設定読み込み
source setting.cnf

#######################################



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


#    -passin pass:"${PASS_PRIVATE_CLIENT}" \
