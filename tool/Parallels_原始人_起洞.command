#!/bin/sh

PDFM_DIR="/Applications/Parallels Desktop.app"
PDFM_DISP_DST="${PDFM_DIR}/Contents/MacOS/Parallels Service.app/Contents/MacOS/prl_disp_service"
PDFM_DISP_PATCH="${PDFM_DISP_DST}_patched"
PDFM_DISP_BCUP="${PDFM_DISP_DST}_backup"

if [ "$(pgrep -x prl_disp_service)" != "" ] && [ "$(pgrep -x prl_client_app)" != "" ]; then
    open "${PDFM_DIR}"
    exit 0
fi


# 获取脚本文件的完整路径，包括文件名
script_path="$0"
# 提取脚本文件所在的目录
script_dir=$(dirname "${script_path}")
cd "${script_dir}"

if [[ -e "./Parallels_一键配置.app" ]]; then
    read -r -p "⚙️ 是否(y/n)需要配置一键启动PD.(默认为:y)" flag || exit 1
    if [[ $flag != n ]]; then
        read -r -p "⚙️ 请输入密码(明文)然后回车." input || exit 1
        sed -i '' -e "s/INPPUT=\"密码\"/INPPUT=\"${input}\"/g;" "./Parallels_一键配置.app/Contents/document.wflow" || exit 1
        echo "${input}" | sudo -S rm -rf "/Applications/启动_PD.app" > /dev/null 2>&1
        echo "${input}" | sudo -S cp -rf "./Parallels_一键配置.app" "/Applications/启动_PD.app" || exit 1
        sed -i '' -e "s/INPPUT=\"${input}\"/INPPUT=\"密码\"/g;" "./Parallels_一键配置.app/Contents/document.wflow" || exit 1
        open "/Applications/启动_PD.app" || exit 1
        exit 0
    fi
fi

sudo cp -f "${PDFM_DISP_PATCH}" "${PDFM_DISP_DST}"
open "${PDFM_DIR}"

sleep 2

sudo cp -f "${PDFM_DISP_BCUP}" "${PDFM_DISP_DST}"

