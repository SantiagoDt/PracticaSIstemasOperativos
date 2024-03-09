#!/bin/bash

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
    echo "Las últimas conexiones LOCALES son:"
    echo "-----------------------------------"
  elif test "$1" == "--help"
  then
    cadena_help="info_user.sh [-u usuario][-g grupo][--login][--help]\n
    \t -u usuario   Mostrar información sobre un usuario especificado
    \t -g grupo     Mostrar usuarios asociados al grupo especificado
    \t --login      Mostrar los 5 últimos usuarios que han accedido al sistema
    \t --help       Mostrar ayuda"
  echo -e "$cadena_help"
elif test "$1" == "-u"
then
  echo "Error:Se debe proporcionar el nombre de usuario con el parametro -u"
elif test "$1" == "-g"
then
  echo "Se debe proporcionar el nombre del grupo con el parámetro -g"
  else
    "Error:Opción no valida.Use --help para obtener ayuda."
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

  echo "help"
fi
