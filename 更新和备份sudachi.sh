#!/bin/bash
clear
[[ $EUID != 0 ]] && echo "当前非ROOT用户" && exit 0
# 定义应用的包名
app2=org.sudachi.sudachi_emu.ea
path=/data/local/tmp/tmp.apk
path1=$(find /data/app -maxdepth 2 -type d -name "*sudachi*")
pid2=$(ps -A | grep $app2 | awk '{print $2}')
  #检查Sudachi
    if pm list packages | grep "$app2">/dev/null 2>&1; then
   echo "Sudachi 已安装"
     if [[ -f ./yuzu_old.apk ]]; then
        read -p "存在旧版，是否回退yuzu版本？" yn
        case $yn in
          Y|y)pm install yuzu_old.apk>/dev/null 2>&1
           if [ $? -eq 0 ]; then
              echo "回退完毕！"
           else
              echo "回退失败..."
           fi;;
          N|n)echo "用户取消...";;
          *)exit 1;;
        esac
     fi
     if [[ -f ./yuzu.tar.gz ]]; then
    read -p "是否先还原yuzu数据？（Y|N）" yn
    case $yn in
        Y|y)tar -zxvf ./yuzu.tar.gz /sdcard/Android/data/$app2>/dev/null 2>&1
           if [ $? -eq 0 ]; then
              echo "还原完毕！"
           else
              echo "还原失败..."
           fi;;
        N|n)echo "用户取消...";;
        *)exit 1;;
    esac
  else
    read -p "是否先备份yuzu数据？（Y|N）" yn
    case $yn in
        Y|y)cp $path1/base.apk ./yuzu_old.apk
           tar -zcvf ./yuzu.tar.gz /sdcard/Android/data/$app2>/dev/null 2>&1 
           if [ $? -eq 0 ]; then
              echo "压缩完毕！"
           else
              echo "压缩失败..."
           fi;;
        N|n)echo "用户取消..";;
        *)exit 1;;
    esac
  fi
   version=$(dumpsys package $app2 | grep versionName | cut -d'=' -f2)
   version1=$(curl -Ls 'https://api.github.com/repos/sudachi-emu/sudachi/releases/latest' | grep 'tag_name' | sed -E 's/.*"([^"]+)".*/\1/')

     #检查更新
     if [[ "$version" != "$version1" ]]; then
           echo "Sudachi正在更新!"
           #检查是否运行
        if ps -Af | grep $app2 | grep -v root | grep -v grep>/dev/null 2>&1; then
        read -p "Sudachi 正在运行，是否结束运行？（Y/N）" yn
        case $yn in
          Y|y)kill $pid2;;
          N|n)echo "用户取消" && exit 0;;
          *)exit 1;;
        esac
     else
        echo "Sudachi没有运行"
     fi
           wget --no-check-certificate -O $path https://gh.ddlc.top/https://github.com/sudachi-emu/sudachi/releases/latest/download/sudachi-ea-release.apk>/dev/null 2>&1
        # 检查下载是否成功
           if [ $? -eq 0 ]; then
            pm install $path>/dev/null 2>&1
		     if [ $? -eq 0 ]; then  
                  echo "Sudachi更新成功"
                else
                  echo "Sudachi更新失败"
             fi
           else
             echo "下载出错！请检查网络连接" 
             exit 1
           fi
     else
             echo "Sudachi已经是最新"
     fi
  else
        echo "Sudachi未安装，尝试安装"    
        wget --no-check-certificate -O $path https://gh.ddlc.top/https://github.com/sudachi-emu/sudachi/releases/latest/download/sudachi-ea-release.apk>/dev/null 2>&1
        # 检查下载是否成功
        if [ $? -eq 0 ]; then  
        	pm install $path>/dev/null 2>&1
        	    if [ $? -eq 0 ]; then  
                  echo "Sudachi安装成功"
                else
                  echo "Sudachi安装失败"
                fi
            rm $path
        else
            echo "下载出错！请检查网络连接" 
            exit 1
        fi
  fi
 
  exit 0
