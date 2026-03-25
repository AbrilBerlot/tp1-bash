#!/bin/bash

DIRECTORIO_PRINCIPAL="$HOME/EPNro1"

crear_entorno(){
    echo "Iniciando creacion de entorno..."

    mkdir -p "$DIRECTORIO_PRINCIPAL/entrada"
    mkdir -p "$DIRECTORIO_PRINCIPAL/salida"
    mkdir -p "$DIRECTORIO_PRINCIPAL/procesado"

    if [ -f consolidar.sh ]; then
        cp consolidar.sh "$DIRECTORIO_PRINCIPAL/"
        echo "Copiando consolidar.sh..."
    else
        echo "Error: consolidar.sh no encontrado"
    fi

    if [ -d "$DIRECTORIO_PRINCIPAL" ]; then
        echo "Entorno creado con éxito en: $DIRECTORIO_PRINCIPAL"
        echo "Carpetas listas: entrada, salida, procesado."
    else
        echo "Hubo un error al crear el entorno."
    fi
    if [ -f "${FILENAME}.txt" ]; then
        echo "Detectado archivo local ${FILENAME}.txt. Movíendolo a la carpeta de salida..."
        mv "${FILENAME}.txt" "$DIRECTORIO_PRINCIPAL/salida/" 
    fi
}

correr_proceso(){
    echo "Comenzando el proceso..."
    (cd "$HOME/EPNro1" && bash consolidar.sh) &
    ID_CONSOLIDAR_PROCESO=$!
    export ID_CONSOLIDAR_PROCESO
    echo "Proceso iniciado con ID: $ID_CONSOLIDAR_PROCESO"
}

if [ "$1" == "-d" ]; then
   echo "Iniciando la limpieza de entorno..."
   pkill -f "consolidar.sh" 2>/dev/null
   rm -rf "$DIRECTORIO_PRINCIPAL"
   echo "Eliminando entorno y deteniendo los procesos..."
   exit 0;
fi

alumnos_ordenados_padron(){
   export  ARCHIVO_SALIDA="$HOME/EPNro1/salida/${FILENAME}.txt"
    if [ -f "$ARCHIVO_SALIDA" ]; then
        echo -e "Mostrando listado de alumnos: \n"
        sort "$ARCHIVO_SALIDA"
    else
        echo "El archivo $FILENAME.txt no existe en la carpeta de salida"
    fi
}

notas_mas_altas(){
    export  ARCHIVO_SALIDA="$HOME/EPNro1/salida/${FILENAME}.txt"
    if [ -f "$ARCHIVO_SALIDA" ]; then
        echo "Las notas mas altas son: "
        cut -d' ' -f1- "$ARCHIVO_SALIDA" | sort -nr -k5 | head -n 10
    else
        echo "El archivo no existe"
    fi
}

info_por_padron(){
    export  ARCHIVO_SALIDA="$HOME/EPNro1/salida/${FILENAME}.txt"
    PADRON_USUARIO=$1
    if [ -f "$ARCHIVO_SALIDA" ]; then
        grep -e "^$PADRON_USUARIO" "$ARCHIVO_SALIDA" || echo "Padrón no encontrado"
    fi
}

while true; do
    echo -e "\n--- MENÚ PRINCIPAL ---"
    echo "1) Crear entorno"
    echo "2) Correr proceso"
    echo "3) Listar alumnos por padrón"
    echo "4) Listar 10 notas más altas"
    echo "5) Buscar alumno por padrón"
    echo "6) Salir"
    read -p "Seleccione una opción:  " OPCION 

    case $OPCION in
        1)
            crear_entorno ;;
        2)
            correr_proceso ;;
        3)
            alumnos_ordenados_padron ;;
        4)
            notas_mas_altas ;;
        5)
            read -p "Ingrese el nro de padrón a buscar: " PADRON_A_BUSCAR
            info_por_padron "$PADRON_A_BUSCAR";;
        6)
            exit 0 ;;
        *) echo "Opción inválida" ;;
    esac
done
