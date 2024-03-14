#!/bin/bash

function help() {

  cadena_help="info_user.sh [-u usuario][-g grupo][--login][--help]\n
  \t -u usuario   Mostrar información sobre un usuario especificado
  \t -g grupo     Mostrar usuarios asociados al grupo especificado
  \t --login      Mostrar los 5 últimos usuarios que han accedido al sistema
  \t --help       Mostrar ayuda"
echo -e "$cadena_help"
return;

}
if test $# -gt 2
then
  #Parametros incorrectos pues solo se puede pasar dos parametros

  echo "Error:El número de parametros pasados es incorrectos"

elif test $# -eq 1
then

  #Aqui tenemos dos opciones
  #Si el parametro pasado es --login o si el parametro pasado es --help

  if test "$1" == "--login"
  then
    echo "Las últimas conexiones REMOTAS son:"
    echo "-----------------------------------"
    grep  "Accepted" /var/log/auth.log | tail -5 | cut -d ' ' -f 1,2,9,11
    echo -e "\n"
    echo "Las últimas conexiones LOCALES son:"
    echo "-----------------------------------"
    grep -E "su: pam_unix\(su:session\): session opened |systemd-user:session\): session opened" /var/log/auth.log | tail -5 | cut -d ' ' -f 1,2,3,11
  elif test "$1" == "--help"
  then
    help
elif test "$1" == "-u"
then
  echo "Error:Se debe proporcionar el nombre de usuario con el parametro -u"
elif test "$1" == "-g"
then
  echo "Se debe proporcionar el nombre del grupo con el parámetro -g"
  else
    echo "Error: Opción no valida. Uso "\$0 [-u][-g]" Use --help para obtener ayuda."]
  fi

elif test $# -eq 2
then

  #Aqui tenemos dos opciones
  # Si el primer parametro pasado es -u el segundo debe estar asociado a un nombre de usuario
  #Si el segundo paraemtro pasado es -g el segundo parametro debe estar asociado a un grupo

  if test "$1" == "-u"
  then
      STRING=`grep $2 /etc/passwd`
      if  test -z "$STRING"
      then
        echo "El usuario $2 no existe en el sistema"
      else
        LOGGED=`who | grep $2`
        if ! test -z "$LOGGED"
        then
          echo "El usuario $2 esta conectado actualmente"
        else
          echo "El usuario $2 no esta conectado"
        fi

        echo "Las últimas conexiones REMOTAS son:"
        echo "-----------------------------------"
        grep  "Accepted password for $2" /var/log/auth.log | tail -5 | cut -d ' ' -f 1,2,3,11
        echo -e "\n"
        echo "Las últimas conexiones LOCALES son:"
        echo "-----------------------------------"
       grep -E "su: pam_unix\(su:session\): session opened for user $2|systemd-user:session\): session opened for user $2" /var/log/auth.log | tail -5 | cut -d ' ' -f 1,2,3

       GRUPOS=`grep ":santi" /etc/group | tr ":" " " | cut -d ' ' -f 1 | tr '\n' ' '`

       echo "El usuario $2 pertenece a los siguientes grupos:$GRUPOS"
       echo "Espacio ocupado por la carpeta "home"/$2 : `du /home/"$2" -sh | tr "/" " " | cut -d ' ' -f 1`"

       NUM_FILES=`find /home/"$2" -size +1M | wc -l`
       echo "Contiene $NUM_FILES ficheros mayores de 1MB en la carpeta "home/"$2"

      fi
  elif test "$1" == "-g"
  then
      if test -z `grep "$2:x:" /etc/group`
      then
        echo "El grupo $2 no existe en el sistema"
      else
        STRING_2=`grep "$2:x:" /etc/group | tr ":" " " | cut -d ' ' -f 4`

        if test -z "$STRING_2"
        then
          echo "El grupo $2 no contiene usuarios"
        else
          echo "Los usuarios del grupo $2 son : $STRING_2"

      fi
    fi

  else
    echo "El modificador solicitado no existe"
  fi

else
  help
fi
