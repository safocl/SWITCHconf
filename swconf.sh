#!/bin/sh
clear
# LOGO
echo "\033[36m\t\t\t##################################################################"
echo "\033[33m\t\t\t##     #  ###  #  #      ##     #  ###  ##########################"
echo "\033[37m\t\t\t#  #####  ###  #  ###  ###  #####  ###  ##########################"
echo "\033[36m\t\t\t##     #  ###  #  ###  ###  #####       ##   #   #   ##   ########"
echo "\033[33m\t\t\t#####  #  # #  #  ###  ###  #####  ###  ## ### # # ## #  ##  Beta " 
echo "\033[37m\t\t\t#     ###  #  ##  ###  ####     #  ###  ##   #   # ## # ### v2.0 #"
echo "\033[36m\t\t\t##################################################################"
echo "\033[33m\t\t\t##################################################################\n"
# Проверка установленных пакетов
echo "Для правильной работы программы необходимы следующие пакеты:"
echo " dialog"
echo " minicom\n"
echo "Проверка наличия необходимых пакетов..."
# проверка пакета dialog
if [ -f /usr/bin/dialog ]; then
	echo "Пакет dialog установлен";
else
	echo "\033[37;1;41mНе установлен пакет dialog! Пожалуйста установите необходимые пакеты!\033[0m"; 
	exit;
fi
# проверка пакета minicom
if  [ -f /usr/bin/minicom ]; then
        echo "Пакет minicom установлен" ;
else 
        echo "\033[37;1;41mНе установлен пакет minicom! Пожалуйста установите необходимые пакеты!\033[0m" ;
        exit;
fi
#
################### ЗАПУСК ПРОГРАММЫ #####################
#
# readme
clear
dialog --backtitle "SWITCHconf v2.0 Beta" \
	--msgbox "

XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
XX_____X__XXX__X__X______XX_____X__XXX__XXXXXXXXXXXXXXXXXXXXXXXXXX
X__XXXXX__XXX__X__XXX__XXX__XXXXX__XXX__XXXXXXXXXXXXXXXXXXXXXXXXXX
XX_____X__XXX__X__XXX__XXX__XXXXX_______XX___X___X___XX___XXXXXXXX
XXXXX__X__X_X__X__XXX__XXX__XXXXX__XXX__XX_XXX_X_X_XX_X__XX Beta X
X_____XXX__X__XX__XXX__XXXX_____X__XXX__XX___X___X_XX_X_XXX 2.0 XX
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 
Здравствуйте!
Вас приветствует программа SWITCHconf! 
Данная программа предназначена для автоматизации конфигурирования коммутаторов фирмы D-Link через USB-to-COM интерфейс. Тестировалась на коммутаторах серии DES-30xx и DES-32xx.
Конфигурирование коммутаторов осуществляется посредством посыла на них стандартных команд через USB-to-COM кабель, предварительно подключенный и настроенный через утилиту minicom. Если Вам требуется настройка порта через minicom, то в последующем программа предложит вам это сделать.
Внимание! Все манипуляции с оборудованием Вы проводите на свой страх и риск! Разработчик не несет ответственность за неправильное конфигурирование или порчу оборудования (вероятность этого крайне мала).
Если Вы не уверены какой параметр нужно задать в каком-либо диалоговом окне, просто нажмите Enter. 
Прервать выполнение программы на любом ее этапе можно с помощью нажатия клавиш CTRL+C.
  
 
moonSN 2017
 
так же спасибо safocl за подсказки с написанием кода ;)" \40 70
# Предупреждение
dialog --backtitle "SWITCHconf v2.0 Beta" \
	--colors --title "\Zb\Z1\ZrВНИМАНИЕ" \
	--colors --msgbox "\Z1Во избежании неправильной работы программы, отключите все устройства, использующие USB интерфейс, кроме USB-to-COM кабеля!"  \9 40
# Проверка usb
# usb1 - переменная будет использоваться для последующего перенаправленияна нее команд
usb1="$(ls /dev/ttyUSB*)"
if [ -e /dev/ttyUSB* ]; then
	dialog --clear --title "Проверка USB" \
	--backtitle "SWITCHconf v2.0 Beta" \
	--no-mouse --sleep 2 --infobox "USB кабель подключен к $usb1" \ 4 40
else
	dialog --clear --title "Проверка USB" \
        --backtitle "SWITCHconf v2.0 Beta" \
        --colors --msgbox "\Z1USB кабель не подключен! Пожалуйста, подключите USB и перезапустите программу." \ 7 30
	exit;
fi
#  Настройка minicom
dialog --backtitle "SWITCHconf v2.0 Beta" \
	--title "Настройка minicom" \
	--yesno "Вы действительно хотите настроить minicom?" \ 6 30
minc1=$?
case $minc1 in
0) sudo minicom -l -8 -c on -s ;;
1) ;;
*) ;;
esac
# Создание переменных и присвоение значений
# запрос логина
login=$(dialog --stdout --backtitle "SWITCHconf v2.0 Beta" --title "Username" --clear --inputbox "Пожалуйста, введите логин для доступа к коммутатору (Пример: admin):" 9 40)
# запрос пароля
pass=$(dialog --stdout --backtitle "SWITCHconf v2.0 Beta" --title "Password" --clear --inputbox "Пожалуйста, введите пароль для доступа к коммутатору (Пример: 1234):" 9 40)
# запрос IP адреса
ipaddress=$(dialog --stdout --backtitle "SWITCHconf v2.0 Beta" --title "Switch IP" --clear --inputbox "Пожалуйста, введите IP адрес коммутатора (Пример: 192.168.1.10):" 9 40)
# запрос маски подсети
mask=$(dialog --stdout --backtitle "SWITCHconf v2.0 Beta" --title "Netmask" --clear --inputbox "Пожалуйста, введите маску подсети (Пример: 24):" 9 40)
# запрос IP адреса шлюза
gate=$(dialog --stdout --backtitle "SWITCHconf v2.0 Beta" --title "Gateway IP" --clear --inputbox "Пожалуйста, введите IP адрес шлюза (Пример: 192.168.1.1):" 9 40)
# запрос номеров портов для удаления default vlan
dfvlan=$(dialog --stdout --backtitle "SWITCHconf v2.0 Beta" --title "Default vlan" --clear --inputbox "Пожалуйста, введите номера портов для удаления default vlan (Пример: 1-26):" 9 40)
# запрос ID клиентского vlan
clientvlanid=$(dialog --stdout --backtitle "SWITCHconf v2.0 Beta" --title "Vlan ID" --clear --inputbox "Пожалуйста, введите ID клиентского vlan (Пример: 1300):"  9 40)
# задаем имя клиенского vlan из переменной clientvlanid
clientvlanname="s"$clientvlanid
# запрос ID multicast vlan
multid=$(dialog --stdout --backtitle "SWITCHconf v2.0 Beta" --title "Multicast vlan ID" --clear --inputbox "Пожалуйста, введите ID multicast vlan (Пример: 300):" 9 40)
# запрос номеров клиентских портов
clientvlanport=$(dialog --stdout --backtitle "SWITCHconf v2.0 Beta" --title "Client ports" --clear --inputbox "Пожалуйста, введите номера клиентских портов (Пример: 5,7-10):" 9 40)
# запрос ID управляющего vlan, имя будет присвоено по умолчанию (core) 
corevlan=$(dialog --stdout --backtitle "SWITCHconf v2.0 Beta" --title "Control vlan ID" --clear --inputbox "Пожалуйста, введите ID управляющего vlan (Пример: 2000):" 9 40)
# запрос номеров портов для управляющего vlan 
corevlanport=$(dialog --stdout --backtitle "SWITCHconf v2.0 Beta" --title "Control ports" --clear --inputbox "Пожалуйста, введите номера управляющих портов (Пример: 16,24-25):" 9 40)
# запрос IP адреса SNTP сервера
sntpserv=$(dialog --stdout --backtitle "SWITCHconf v2.0 Beta" --title "SNTP IP" --clear --inputbox "Пожалуйста, введите IP адрес SNTP сервера (Пример: 192.168.1.1):" 9 40)
# запрос сдвига временной зоны GMT+
tz=$(dialog --stdout --backtitle "SWITCHconf v2.0 Beta" --title "TimeZone" --clear --inputbox "Пожалуйста, введите сдвиг часового пояса GMT+ (Пример: 3):" 9 40)
# запрос названия SNMP community
snmpcommname=$(dialog --stdout --backtitle "SWITCHconf v2.0 Beta" --title "SNMP community" --clear --inputbox "Пожалуйста, введите название SNMP community (Пример: public):" 9 40)
# запрос SNMP системного имени коммутатора
sysname=$(dialog --stdout --backtitle "SWITCHconf v2.0 Beta" --title "System Name" --clear --inputbox "Пожалуйста, введите системное имя коммутатора (Пример: eng, любое без пробелов):" 9 40) 
# запрос IP адреса syslog сервера 
syslogserv=$(dialog --stdout --backtitle "SWITCHconf v2.0 Beta" --title "Syslog server IP" --clear --inputbox "Пожалуйста, введите IP адрес сервера сбора логов (Пример: 192.168.1.1):" 9 40)
# запрос номеров портов для закрытия
close1=$(dialog --stdout --backtitle "SWITCHconf v2.0 Beta" --title "Disable ports" --clear --inputbox "Пожалуйста, введите номера портов для их закрытия (Пример: 1-3,7):" 9 40)
# ################################################
# вывод диалогов о запросах требующих решения пользователя и выполнение их на коммутаторе
# заходим на коммутатор
dialog --clear --backtitle "SWITCHconf v2.0 Beta" \
	--sleep 2 --infobox "Подключаемся к коммутатору..." \ 3 40
echo $login>$usb1
echo $pass>$usb1
dialog  --backtitle "SWITCHconf v2.0 Beta" \
        --title "Reset switch" \
        --yesno "Вы действительно хотите сбросить коммутатор на заводские настройки?" \ 9 40
res1=$? 
case $res1 in
0) echo "reset conf">$usb1 | echo "y">$usb1 ;;
1) ;;
*) ;;
esac
dialog  --backtitle "SWITCHconf v2.0 Beta" \
        --no-mouse --sleep 20 --infobox "Пожалуйста подождите..." \4 40
# Включение ssh или telnet
dialog  --backtitle "SWITCHconf v2.0 Beta" \
	--title "Telnet\SSH" \
	--yesno "Включить Telnet\Выключить SSH?" \ 9 40
res2=$? 
case $res2 in
0) echo "enable telnet">$usb1 | echo "disable ssh">$usb1 ;;
1) echo "enable ssh">$usb1 | echo "disable telnet">$usb1 ;;
esac
dialog  --backtitle "SWITCHconf v2.0 Beta" \
	--sleep 2 --infobox "Настраивается Telnet\SSH..." \4 40
# Включение\отключение web
dialog  --backtitle "SWITCHconf v2.0 Beta" \
        --title "Web" \
        --yesno "Включить web-интерфейс?" \ 9 40
res3=$? 
case $res3 in
0) echo "enable web">$usb1 ;;
1) echo "disable web">$usb1 ;;
esac
dialog  --backtitle "SWITCHconf v2.0 Beta" \
	--title "Wait..." \
        --sleep 2 --infobox "Настраивается Web..." \4 40
# Включение\отключение loopdetect
dialog  --backtitle "SWITCHconf v2.0 Beta" \
        --title "LoopDetect" \
        --yesno "Включить Loopdetect?" \ 9 40
res4=$? 
case $res4 in
0) echo "enable loopdetect">$usb1 ;;
1) echo "disable loopdetect">$usb1 ;;
esac
dialog  --backtitle "SWITCHconf v2.0 Beta" \
	--title "Wait..." \
        --sleep 2 --infobox "Настраивается Loopdetect..." \4 40
# Включение\отключение SNMP
dialog  --backtitle "SWITCHconf v2.0 Beta" \
        --title "SNMP" \
        --yesno "Включить SNMP?" \ 9 40
res5=$? 
case $res5 in
0) echo "enable snmp">$usb1 ;;
1) echo "disable snmp">$usb1 ;;
esac
dialog  --backtitle "SWITCHconf v2.0 Beta" \
	--title "Wait..."
        --sleep 2 --infobox "Настраивается SNMP..." \4 40
# Включение\отключение IGMP\Multicast
dialog  --backtitle "SWITCHconf v2.0 Beta" \
        --title "IGMP\Multicast" \
        --yesno "Включить поддержку Multicast?" \ 9 40
res6=$? 
case $res6 in
0) echo "enable igmp_snooping">$usb1 | echo "enable igmp_snooping multicast_vlan">$usb1 ;;
1) echo "disable igmp_snooping">$usb1 | echo "disable igmp_snooping multicast_vlan">$usb1 ;;
esac
dialog  --backtitle "SWITCHconf v2.0 Beta" \
	--title "Wait..." \
        --sleep 2 --infobox "Настраивается Multicast..." \4 40
# ###########################################################################################
# выполение основного конфигурирования коммутатора с помощью заданных переменных
#
# настройка аккаунта
echo "create account admin $login">$usb1
echo $pass>$usb1
echo $pass>$usb1
dialog  --backtitle "SWITCHconf v2.0 Beta" --sleep 2 --infobox "Настраивается account..." \4 40
# настройка IP адреса
echo "config ipif System ipaddress $ipaddress /$mask state enable">$usb1
dialog  --backtitle "SWITCHconf v2.0 Beta" --sleep 2 --infobox "Настраивается IP адрес..." \4 40
# настройка шлюза 
echo "create iproute default $gate 1">$usb1
dialog  --backtitle "SWITCHconf v2.0 Beta" --sleep 2 --infobox "Настраивается шлюз по умолчанию..." \4 40
# настройка loopdetect
echo "config loopdetect ports $clientvlanport state enable">$usb1
echo "config loopdetect ports $corevlanport state disable">$usb1 
dialog  --backtitle "SWITCHconf v2.0 Beta" --sleep 2 --infobox "Настраивается loopdetect..." \4 40
# настройка системного имени
echo "config snmp system_name $sysname">$usb1
dialog  --backtitle "SWITCHconf v2.0 Beta" --sleep 2 --infobox "Настраивается system name..." \4 40
# настрока default vlan
echo "config vlan default delete $dfvlan">$usb1
dialog  --backtitle "SWITCHconf v2.0 Beta" --sleep 2 --infobox "Настраивается default vlan..." \4 40
# настройка управляющего vlan
echo "create vlan core tag $corevlan">$usb1
echo "config vlan core add untag $corevlanport">$usb1
echo "config ipif System vlan core">$usb1
dialog  --backtitle "SWITCHconf v2.0 Beta" --sleep 2 --infobox "Настраивается управляющий (core) vlan..." \4 40
# настройка клиентских vlan
echo "create vlan $clientvlanname tag $clientvlanid">$usb1
echo "config vlan $clientvlanname add tag $corevlanport">$usb1
echo "config vlan $clientvlanname add untag $clientvlanport">$usb1
dialog  --backtitle "SWITCHconf v2.0 Beta" --sleep 2 --infobox "Настраивается клиентский vlan..." \4 40  
# настройка traffic control
echo "config traffic control $clientvlanport broadcast enable">$usb1
echo "config traffic control $corevlanport broadcast disable">$usb1
echo "config traffic control all threshold 64">$usb1
dialog  --backtitle "SWITCHconf v2.0 Beta" --sleep 2 --infobox "Настраивается traffic control..." \4 40 
# настройка Multicast
echo "create igmp_snooping multicast_vlan iptv $multid">$usb1
echo "config igmp_snooping multicast_vlan iptv state enable">$usb1
echo "config igmp_snooping multicast_vlan iptv add source_port $corevlanport">$usb1
echo "config igmp_snooping multicast_vlan iptv add member_port $clientvlanport">$usb1
echo "config igmp_snooping multicast_vlan iptv remap_priority 7 replace_priority">$usb1
echo "config multicast port_filtering_mode all filter_unregistered_groups">$usb1
echo "config igmp_snooping multicast_vlan_group iptv add 239.1.1.1-239.1.1.250,234.4.4.4">$usb1
dialog  --backtitle "SWITCHconf v2.0 Beta" --sleep 2 --infobox "Настраивается multicast..." \4 40
# настройка SNTP
echo "config sntp primary $sntpserv poll-interval 86400">$usb1
echo "config time_zone operator + hour $tz min 0">$usb1
echo "enable sntp">$usb1
dialog  --backtitle "SWITCHconf v2.0 Beta" --sleep 2 --infobox "Настраивается SNTP и временная зона..." \4 40 
# настройка access profile
echo "create access_profile ip udp src_port_mask 0xFFFF profile_id 1">$usb1
echo "config access_profile profile_id 1 add access_id 1 ip udp src_port 67 port $corevlanport permit">$usb1
echo "config access_profile profile_id 1 add access_id 2 ip udp src_port 67 port $clientvlanport deny">$usb1
echo "create access_profile ip tcp dst_port_mask 0xffff profile_id 2">$usb1
echo "config access_profile profile_id 2 add access_id 1 ip tcp dst_port 137 port all deny">$usb1
echo "config access_profile profile_id 2 add access_id 2 ip tcp dst_port 138 port all deny">$usb1
echo "config access_profile profile_id 2 add access_id 3 ip tcp dst_port 139 port all deny">$usb1
echo "config access_profile profile_id 2 add access_id 4 ip tcp dst_port 445 port all deny">$usb1
echo "create access_profile ip udp dst_port_mask 0xffff profile_id 3">$usb1
echo "config access_profile profile_id 3 add access_id 1 ip udp dst_port 137 port all deny">$usb1
echo "config access_profile profile_id 3 add access_id 2 ip udp dst_port 138 port all deny">$usb1
echo "config access_profile profile_id 3 add access_id 3 ip udp dst_port 139 port all deny">$usb1
echo "config access_profile profile_id 3 add access_id 4 ip udp dst_port 445 port all deny">$usb1
dialog  --backtitle "SWITCHconf v2.0 Beta" --sleep 2 --infobox "Настраивается access profile (ACL)..." \4 40 
# настройка syslog
echo "create syslog host 1 ipaddress $syslogserv severity all state enable">$usb1
echo "enable syslog">$usb1
dialog  --backtitle "SWITCHconf v2.0 Beta" --sleep 2 --infobox "Настраивается syslog..." \4 40
# настройка SNMP
echo "delete snmp view restricted all">$usb1
echo "create snmp community $snmpcommname view CommunityView read_only">$usb1
echo "create snmp view CommunityView 1 view_type included">$usb1
echo "create snmp view CommunityView 1.3.6.1.6.3 view_type excluded">$usb1
echo "create snmp view CommunityView 1.3.6.1.6.3.1 view_type included">$usb1
dialog  --backtitle "SWITCHconf v2.0 Beta" --sleep 2 --infobox "Настраивается SNMP community..." \4 40
###################################################################################################
# запрос на сохранение настроек
dialog  --backtitle "SWITCHconf v2.0 Beta" \
	--title "Save configuration" \
	--yesno "Вы действительно хотите сохранить настройки?" \ 6 40
res7=$? 
case $res7 in
0) echo "save all">$usb1 | echo "y">$usb1 | dialog --backtitle "SWITCHconf v2.0 Beta" --sleep 4 --colors --msgbox "Настройки успешно сохранены!" \6 40;;
1) dialog --backtitle "SWITCHconf v2.0 Beta" --colors --msgbox "\Z1Настройки не сохранены!" \6 40;;
esac
clear
echo "######################### DONE! ############################"




