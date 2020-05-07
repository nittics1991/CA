#!/bin/bash
#
#   作業DIR作成
#
#set -e

cd $(dirname "$0");
cd ..

#設定読み込み
source setting.cnf

#DIR作成
#rootCA
mkdir -p "${DIR_ROOT_CA}"

for TARGET_PATH in ${DIRS_CA}
do
    mkdir -p "${DIR_ROOT_CA}/${TARGET_PATH}"
done

#interCA
cp -r "${DIR_ROOT_CA}" "${DIR_INTER_CA}"

#server
mkdir -p "${DIR_SERVER}"

for TARGET_PATH in ${DIRS_USER}
do
    mkdir -p "${DIR_SERVER}/${TARGET_PATH}"
done

#client
cp -r "${DIR_SERVER}" "${DIR_CLIENT}"

#chmod & config file
for TARGET_PATH in ${DIR_ROOT_CA} ${DIR_INTER_CA} ${DIR_SERVER} ${DIR_CLIENT} 
do
    #private dir アクセス権
    chmod 750 "${TARGET_PATH}/private"
    
    #openssl.cnf作成
    cp ./openssl.cnf "${TARGET_PATH}/"
    
    sed -i -r -e "s/^dir\s.+/dir=.\/${TARGET_PATH}/" "${TARGET_PATH}/openssl.cnf"
done

#config server

cat << EOT >> "${DIR_INTER_CA}/openssl.cnf"

#--------------------------------------------------
[server_cert]

basicConstraints=CA:FALSE
keyUsage=digitalSignature,keyEncipherment
extendedKeyUsage=serverAuth
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer

EOT

#config client

cat << EOT >> "${DIR_INTER_CA}/openssl.cnf"

#--------------------------------------------------
[client_cert]

basicConstraints=CA:FALSE
keyUsage=digitalSignature,keyEncipherment
extendedKeyUsage=clientAuth
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer

EOT

tree -a .
