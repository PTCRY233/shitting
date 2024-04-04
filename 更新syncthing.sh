#!/bin/bash
clear
[[ $EUID != 0 ]] && echo "当前非ROOT用户" && exit 0
# 检查应用是否已安装
    path=/data/local/tmp/tmp.apk
    app1=com.nutomic.syncthingandroid
    pid1=$(ps -A | grep $app1 | awk '{print $2}')
  if pm list packages | grep "$app1">/dev/null 2>&1; then
   echo "Syncthing 已安装"
   version=$(dumpsys package $app1 | grep versionName | cut -d'=' -f2)
   version1=$(curl -Ls 'https://api.github.com/repos/syncthing/syncthing-android/releases/latest' | grep 'tag_name' | sed -E 's/.*"([^"]+)".*/\1/')
     #检查更新
     if [[ "$version" != "$version1" ]]; then
           echo "Syncthing需要更新!"
       #检查是否运行
       if ps -Af | grep $app1 | grep -v root | grep -v grep>/dev/null 2>&1; then
        read -p "Syncthing 正在运行，是否结束运行？（Y/N）" yn
        case $yn in
          Y|y)kill $pid1;;
          N|n)echo "用户取消" && exit 0;;
          *)exit 1;;
         esac
        else
         echo "Syncthing没有运行"
        fi
           echo "正在更新Syncthing......"
           wget --no-check-certificate -O $path https://gh.ddlc.top/https://github.com/syncthing/syncthing-android/releases/latest/download/app-release.apk>/dev/null 2>&1
        # 检查下载是否成功
           if [ $? -eq 0 ]; then
		     pm install $path>/dev/null 2>&1
		     if [ $? -eq 0 ]; then  
                  echo "Syncthing更新成功"
                else
                  echo "Syncthing更新失败"
             fi
             rm $path
           else
             echo "下载出错！请检查网络连接" 
             exit 1
           fi
     else
             echo "Syncthing已经是最新"
     fi
  else
        echo "Syncthing未安装，尝试安装"    
        wget --no-check-certificate -O $path https://gh.ddlc.top/https://github.com/syncthing/syncthing-android/releases/latest/download/app-release.apk>/dev/null 2>&1
        # 检查下载是否成功
        if [ $? -eq 0 ]; then  
        	pm install $path>/dev/null 2>&1
		     if [ $? -eq 0 ]; then  
                  echo "Syncthing安装成功"
                else
                  echo "Syncthing安装失败"
             fi
            rm $path
        else
            echo "下载出错！请检查网络连接" 
            exit 1
        fi
  fi
  rm wget-log
  exit 0