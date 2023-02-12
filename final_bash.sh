#!/bin/bash
#Funciones de menu princial
function Menu {
	clear
echo "   _________________________________________ "
echo "  |                                         |"
echo "  |  __   __  _________   _________  __   __|"
echo "  |  | \\ |  \\  \\     \\  \\     \\   | \\ |  |"
echo "  |  |  \\|  \\  \\     \\  \\     \\  |  \\|  |"
echo "  |  |      \\  \\     \\  \\     \\ |      |"
echo "  |  |      \\  \\_____/  \\_____/  |      |"
echo "  |_________________________________________|"
echo ""
  echo -e "\n"
  echo "#################################################"
  echo "#            Bienvenido al Menu                 #"
  echo "#################################################"
  echo "#                                               #"
  echo "# 1. Configuracion IP fija                      #"
  echo "# 2. Configuracion de IP dinamica               #"
  echo "# 3. Exit                                       #"
  echo "#                                               #"
  echo "#################################################"
  echo -e "\n"
}

#Funcion de configuracion del adaptador de red
function Get-Adaptador {
echo -e "\n"
echo "================================================================================="
nmcli device status
echo "================================================================================="
echo -e "\n"
read -p "Ingrese el nombre de la conexión (ej. eth0, enp0s3): ==> " interface
read -p "Coloca el nombre de la conexio (ej. estatica, dinamica)==> " name
uuid=$(nmcli -g UUID connection show --active)
nmcli conn delete uuid $uuid >> /dev/null
}

#Funcion de configuracion de IP fija
function Ip-fija {
Get-Adaptador
read -p "Ingrese la dirección IP fija (ej. 192.168.0.100/24): ==> " ip
read -p "Ingrese la dirección IP de la puerta de enlace (ej. 192.168.0.1): ==> " gateway
read -p "Ingrese el primer DNS ==> " dns1
read -p "Ingrese el segundo DNS ==> " dns2
#nmcli connection down $interface
#nmcli connection modify $interface ipv4.addresses $ip/$mascara
#nmcli connection modify $interface ipv4.gateway $gateway ipv4.dns $dns1 \ +ipv4.dns $dns2
nmcli connection add con-name $name autoconnect yes ifname \
$interface type ethernet ip4 $ip gw4 $gateway ipv4.dns $dns1 \
+ipv4.dns $dns2
nmcli connection up $name
  echo -e "\n"
  echo "========================================================="
  nmcli connection show $name | grep ipv4.address
  echo "========================================================="
  echo -e "\n"
exit 0 
}

#Funcion de configuracion de IP por DHCP
function Ip-dhcp {
Get-Adaptador
nmcli connection add con-name $name autoconnect yes ifname \
$interface type ethernet
nmcli connection up $name
  echo -e "\n"
  echo "========================================================="
  nmcli connection show $name | grep ipv4.address
  echo "========================================================="
  echo -e "\n"

exit 0
}
#Inicio del Menu
while :
do
Menu
	read -p "Por favor elija una opcion ==> " option
	case "$option" in
		1) Ip-fija
		   read x
		   ;;
		2) Ip-dhcp
		   ;;
		3) exit 0
		   ;;
		*) echo -e "\n"
		   echo " _______ _________ _______  _______  _______ "
		   echo "(  ____ \\__   __/(  ____ \(  ____ \(  ____ \\"
		   echo "| (    \/   ) (   | (    \/| (    \/| (    \/"
		   echo "| (__       | |   | (__    | (_____ | (_____ "
		   echo "|  __)      | |   |  __)   (_____  )(_____  )"
	    	   echo "| (         | |   | (            ) |      ) |"
		   echo "| (____/\   | |   | (____/\/\____) |/\____) |"
		   echo "(_______/   )_(   (_______/\_______)\_______)"
		   echo ""
		   echo "       -- Error: Ere mu listo -.- "
		   echo -e "\n"
		   read -p "Presiona [Enter] para poder continuar..."
		   #read x
		   ;;
  esac
done
