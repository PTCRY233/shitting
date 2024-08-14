#!/bin/bash
[[ $EUID != 0 ]] && err "当前非 ${yellow}ROOT用户${none}"
clear
touch /data/1大傻逼张天霖不要开挂了
echo -e "\n"
echo -e "当前时间为：$(date)"
echo -e "当前内核为：$(uname -r)"
echo -e "\n"
sleep 1
echo -e "请输入卡密:"
read nul
echo -e "\n"
echo -e "正在向服务器查询数据......."
sleep 2
echo -e "\n"
echo -e "\n"
if [[ -f "/data/1大傻逼张天霖不要开挂了" ]]; then
    echo -e  "查询失败，正在格机!"
    sleep 1
    echo -e "算了，不逗你了，这么想开🍉去电报搜@VKernelNotice"
else
    echo -e  "查询失败，正在格机!"
    echo -e  "查询失败，正在格机!"
    echo -e  "查询失败，正在格机!"
    echo -e  "查询失败，正在格机!"
    echo -e  "查询失败，正在格机!"
    sleep 2
    reboot -p
fi
