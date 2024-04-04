#!/bin/bash
clear
while true; do
[[ $EUID != 0 ]] && echo "当前非ROOT用户" && exit 0
# 检查应用是否已安装
    path=/data/local/tmp/tmp.apk
    echo -e "你就想安装/更新谁？\n--------\n1.Magisk \n\n2.Kitsune Mask\n---------" && read mk
    case ${mk} in
    
        1) app=com.topjohnwu.magisk && res=topjohnwu/Magisk && link="https://gh.ddlc.top/https://gh.ddlc.top/https://github.com/${res}/releases/latest/download/Magisk-$(curl -Ls 'https://api.github.com/repos/${res}/releases/latest' | grep 'tag_name' | sed -E 's/.*"([^"]+)".*/\1/').apk" && version1=$(curl -Ls 'https://api.github.com/repos/topjohnwu/Magisk/releases/latest' | grep 'tag_name' | sed -E 's/.*"([^"]+)".*/\1/') && version1=${version1//[v]/} && clear && name="Magisk" ;;
        
        2) app=io.github.huskydg.magisk && res=HuskyDG/magisk-files && link=https://huskydg.github.io/magisk-files/app-release.apk && name="Kitsune Mask" && clear && echo -e "\n由于github原因，找不到狐狸面具的最新版本号的api，故无法检测\n";;
        
        *) echo -e "再会！" && exit 0 ;;
        
    esac
  if pm list packages | grep "$app" >/dev/null 2>&1; then
   echo -e "$name已安装"
   version=$(dumpsys package $app | grep versionName | cut -d'=' -f2)
   if [[ -z "version1" ]];then
    version1=$(curl -Ls 'https://api.github.com/repos/${res}/releases/latest' | grep 'tag_name' | sed -E 's/.*"([^"]+)".*/\1/')
   fi
     #检查更新
     if [[ "$version" != "$version1" ]]; then
           echo "$name需要更新!"
           echo "正在更新$name......"
           wget --no-check-certificate -O $path $link >/dev/null 2>&1
        # 检查下载是否成功
           if [ $? -eq 0 ]; then
		     pm install $path >/dev/null 2>&1
		     if [ $? -eq 0 ]; then  
                  echo "$name更新成功"
                else
                  echo "$name更新失败"
             fi
             rm $path
           else
             echo "下载出错！请检查网络连接" 
             exit 1
           fi
     else
             echo "$name已经是最新"
     fi
  else
        echo "$name未安装，尝试安装"    
        wget --no-check-certificate -O $path $link >/dev/null 2>&1
        # 检查下载是否成功
        if [ $? -eq 0 ]; then  
        	pm install $path >/dev/null 2>&1
		     if [ $? -eq 0 ]; then  
		          mv $path ./
                  echo "$name安装成功,rec卡刷包在脚本目录"
                else
                  echo "$name安装失败"
             fi
            rm $path
        else
            echo "下载出错！请检查网络连接" 
            exit 1
        fi
  fi
  echo -e "\n---------------\n"
done
  exit 0