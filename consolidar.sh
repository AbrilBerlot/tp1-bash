#!/bin/bash

entrada="$HOME/EPNro1/entrada"
ARCHIVO_SALIDA="$HOME/EPNro1/salida"
procesado="$HOME/EPNro1/procesado"


ls "$entrada"/*.txt 2>/dev/null | while read -r archivo
do
  if [-f "$archivo" ]; then
     cat "archivo" >> "$ARCHIVO_SALIDA/${FILENAME}.txt"
     mv "$archivo" "$procesado/"
  fi
done



