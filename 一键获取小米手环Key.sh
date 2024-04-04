#!/bin/bash
clear

Get_beaconKey_irqKey=true
fast_mode=true

# 检查文件是否存在
if [ -f "MI_DEVICE" ]; then
# 读取文件内容
    IFS='|' read -r name mac sn encryptKey beaconKey irqKey < "MI_DEVICE"
# 显示结果
    echo -e "\n---------上一次结果---------- \n"
    echo -e "设备名称: $name \n"
    echo -e "设备MAC: $mac \n"
    echo -e "设备SN: $sn \n"
    echo -e "设备encryptKey: $encryptKey \n"
    echo -e "设备beaconKey: $beaconKey \n"
    echo -e "设备irqKey: $irqKey \n"
    echo -e "------------------------------- \n"
    read -p "是否重新获取？（y/n）" CHOICE
		case ${CHOICE} in
		y|Y)if [[ "fast_mode"="true" ]]; then
        echo -e "已开启fastmode......."
        for i in $(ps -A | grep com.mi.health | awk '{print $2}'); do kill $i; done
        rm -rf /storage/emulated/0/Android/data/com.mi.health/files/log/*
        am start --windowingMode 5 -n com.mi.health/com.xiaomi.fitness.main.MainActivity &>/dev/null
        sleep 3s
        for i in $(ps -A | grep com.mi.health | awk '{print $2}'); do kill $i; done
fi;;
		n|N)exit 0;;
		esac
fi


while true; do
    # 读取文件
    echo -e "读取文件中......."
    log=$(cat /storage/emulated/0/Android/data/com.mi.health/files/log/XiaomiFit.device.log)
    # 获取mac, name, encryptKey和sn
    encryptKey=$(echo -e $log | sed -n 's/.*encryptKey=\([^,]*\).*/\1/p')
    if [ ${#encryptKey} -eq 32 ]; then
        echo -e "正在获取设备名称......."
        name=$(echo $log | sed -n 's/.*model=[^,]*, name=\([^,]*\).*/\1/p' | tr -d "'")
        echo -e "正在获取设备MAC地址......."
        mac=$(echo -e $log | sed -n 's/.*mac=\([^,]*\).*/\1/p')
        echo -e "正在获取设备SN码......."
        sn=$(echo $log | sed -n 's/.*detail=[^,]*, sn=\([^,]*\).*/\1/p')
        
        if [[ "Get_beaconKey_irqKey"="true" ]]; then
           echo -e "正在获取设备beaconKey......."
           beaconKey=$(echo -e $log | sed -n 's/.*beaconKey=\([^,]*\).*/\1/p')
           echo -e "正在获取设备irqKey......."
           irqKey=$(echo -e $log | sed -n 's/.*irqKey=\([^,]*\).*/\1/p')
        else
            beaconKey=未获取
            irqKey=未获取
        fi
        
         break
    else
    # 重新生成log
        echo -e "encryptKey不存在，尝试重生成......."
        for i in $(ps -A | grep com.mi.health | awk '{print $2}'); do kill $i; done
        rm -rf /storage/emulated/0/Android/data/com.mi.health/files/log/*
        am start --windowingMode 5 -n com.mi.health/com.xiaomi.fitness.main.MainActivity &>/dev/null
        sleep 3s
        for i in $(ps -A | grep com.mi.health | awk '{print $2}'); do kill $i; done
fi

done
# 输出获取到的值
clear
echo -e "设备名字是：$name \n"
echo -e "设备MAC地址是：$mac \n"
echo -e "设备SN是：$sn \n"
echo -e "设备encryptKey是：$encryptKey \n"
echo -e "设备beaconKey是：$beaconKey \n"
echo -e "设备irqKey是：$irqKey \n"
echo -e "$name|$mac|$sn|$encryptKey|$beaconKey|$irqKey" > MI_DEVICE