#!/bin/bash
#
#   作業DIRクリーン
#
#set -e

cd $(dirname "$0");
cd ..

#設定読み込み
source setting.cnf

rm -rf ${DIR_ROOT_CA} ${DIR_INTER_CA} ${DIR_SERVER} ${DIR_CLIENT}

ls -l
