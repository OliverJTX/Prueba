#!/bin/bash
#Funcion de menu principal
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
  echo "# 1. Crear Usuarios                             #"
  echo "# 2. Borrar usuario                             #"
  echo "# 3. Mostrar usuarios                           #"
  echo "# 4. Validar usuarios                           #"
  echo "# 5. Cambiar shell por defecto                  #"
  echo "# 6. Exit                                       #"
  echo "#                                               #"
  echo "#################################################"
  echo -e "\n"
}

#Opcion1 (Creacion de usuarios)
# Función para crear un nuevo usuario
function crear_usuario {
    read -p "Ingrese el nombre de usuario: " username
    read -s -p "Ingrese la contraseña: " password
    read -p "Ingrese el nombre completo: " fullname
    read -p "Ingrese el directorio home: " homedir
    read -p "Ingrese la shell: " shell

    # Añadir el usuario al archivo /etc/passwd
    sudo useradd -m -c "$fullname" -d "$homedir" -s "$shell" "$username"

    # Establecer la contraseña del usuario
    echo "$username:$password" | sudo chpasswd

    echo "Usuario creado exitosamente"
}
#Opcion2(Creacion de usuarios)
function validar_usuario() {
  # Expresión regular para verificar el nombre de usuario
  patron_usuario='^[a-z_][a-z0-9_-]{2,31}$'

  if echo "$1" | grep -qE "$patron_usuario"; then
    echo "El usuario '$1' es válido"
  else
    echo "El usuario '$1' no es válido"
    exit 1
  fi
}

function crear_usuario() {
  read -p "Ingrese el nombre de usuario: " username
  validar_usuario "$username"

  read -s -p "Ingrese la contraseña: " password
  read -p "Ingrese el nombre completo: " fullname
  read -p "Ingrese el directorio home: " homedir
  read -p "Ingrese la shell: " shell

  # Añadir el usuario al archivo /etc/passwd
  sudo useradd -m -c "$fullname" -d "$homedir" -s "$shell" "$username"

  # Establecer la contraseña del usuario
  echo "$username:$password" | sudo chpasswd

  echo "Usuario creado exitosamente"
}

#Opcion1 (Borrar usuarios)
function borrar_usuario {
    local username=""
    while [[ -z "$username" || ! $(getent passwd "$username") ]]; do
        read -p "Ingrese el nombre de usuario a borrar: " username
        if [[ -z "$username" ]]; then
            echo "Debe ingresar un nombre de usuario."
        elif [[ ! $(getent passwd "$username") ]]; then
            echo "El usuario ingresado no existe."
        fi
    done

    # Borrar el usuario y su directorio home
    sudo userdel -r -f "$username"

    echo "Usuario borrado exitosamente"
}
#Opcion2 (Borrar usuarios)
function borrar_usuario {
    read -p "Ingrese el nombre de usuario a borrar: " username

    # Verificar si el usuario existe en el archivo /etc/passwd
    while ! grep -q "^${username}:" /etc/passwd; do
        read -p "El usuario ${username} no existe. Ingrese un nombre de usuario válido: " username
    done

    # Borrar el usuario y su directorio home
    sudo userdel -r "$username"

    echo "Usuario borrado exitosamente"
}

# Función para mostrar los usuarios creados
function mostrar_usuarios {
    echo "Lista de usuarios:"
    awk -F: '{ print "Nombre de usuario: "$1"\nNombre completo: "$5 }' /etc/passwd
}

# Función para cambiar la shell por defecto de los usuarios
function cambiar_shell {
    read -p "Ingrese la nueva shell: " new_shell

    # Modificar el archivo /etc/default/useradd para cambiar la shell por defecto
    sudo sed -i "s@SHELL=/bin/bash@SHELL=$new_shell@g" /etc/default/useradd

    echo "Shell por defecto cambiada exitosamente"
}

#Inicio del Menu
while :
do
Menu
    read -p "Ingrese una opción ==> " opcion
    case $opcion in
        1) crear_usuario;;
        2) borrar_usuario;;
        3) mostrar_usuarios;;
        4) validar_usuario;;
        5) cambiar_shell;;
        6) exit 0;;
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
