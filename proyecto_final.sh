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
    read -s -p "Ingrese la contraseña del usuario: " password
    echo
    read -p "Ingrese el nombre completo del usuario: " fullname
    read -p "Ingrese el directorio de inicio del usuario (opcional, presione enter para dejar el valor por defecto): " homedir
    read -p "Ingrese la shell por defecto del usuario (opcional, presione enter para dejar el valor por defecto): " shell

    # Establecer directorio de inicio y shell por defecto si no se proporcionaron valores
    if [ -z $homedir ]; then
        homedir="/home/$username"
    fi

    if [ -z $shell ]; then
        shell="/bin/bash"
    fi

    # Crear el usuario con el nombre de usuario y contraseña especificados
    sudo useradd -m -c $fullname -d $homedir -s $shell $username
    echo $username:$password | sudo chpasswd
    echo "Usuario creado con éxito!"
    read x
}
#Opcion2(Creacion de usuarios)
function validar_usuario() {
    read -p "Ingrese el nombre de usuario que desea validar: " username

    # Expresión regular para validar el nombre de usuario
    # Valida si el nombre de usuario comienza con una letra minúscula
    # y contiene solo letras minúsculas, números y guiones (-).
    # El nombre de usuario puede terminar con un signo de dólar ($).
    # Esto se debe a que algunos sistemas de Linux permiten que
    # los nombres de usuario terminen con un signo de dólar

    regex='^[a-z][-a-z0-9]*\$?$'

    if [[ $username =~ $regex ]]; then
        echo "El nombre de usuario es válido"
	read x
    else
        echo "El nombre de usuario no es válido"
	read x
    fi
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
    read x
}
# Función para mostrar los usuarios creados
function mostrar_usuarios {
    echo "Lista de usuarios:"
    getent passwd | awk -F: '{print $1}'
}

# Función para cambiar la shell por defecto de los usuarios
function cambiar_shell {
  # Solicitar el nombre del usuario
  read -p "Ingrese el nombre del usuario: " usuario

  # Verificar si el usuario existe
  if ! id -u $usuario > /dev/null 2>&1; then
    echo "El usuario $usuario no existe."
    return 1
  fi

  # Mostrar la lista de shells disponibles
  echo "Shells disponibles:"
  cat /etc/shells

  # Solicitar la nueva shell
  read -p "Ingrese la ruta de la nueva shell: " nueva_shell

  # Verificar si la nueva shell es válida
  if ! grep -q ^$nueva_shell$ /etc/shells; then
    echo "La shell $nueva_shell no es válida o no está en la lista de shells permitidas."
    return 1
    read x
  fi

  # Cambiar la shell del usuario
  sudo chsh -s $nueva_shell $usuario
  if [ $? -eq 0 ]; then
    echo "La shell del usuario '$usuario' ha sido cambiada a $nueva_shell."
    read x
    # Verificar que se ha actualizado correctamente la shell
    actual_shell=$(awk -F: /^$usuario:/ {print \$NF} /etc/passwd)
    if [ $actual_shell = $nueva_shell ]; then
      echo "La shell del usuario $usuario ha sido actualizada correctamente."
      read x
    else
      echo "Ha ocurrido un error al actualizar la shell del usuario $usuario."
      return 1
      read x
    fi
  else
    echo "Ha ocurrido un error al cambiar la shell del usuario $usuario."
    return 1
    read x
  fi
}


#Inicio del Menu
while :
do
Menu
    read -p "Ingrese una opción ==> " opcion
    case $opcion in
        1) crear_usuario;;
        2) borrar_usuario;;
        3) mostrar_usuarios
	   read x
	   ;;
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
