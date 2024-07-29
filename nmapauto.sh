#!/bin/bash

# Verifica si se ha proporcionado una dirección IP
if [ -z "$1" ]; then
    echo "Uso: $0 <direccion_ip>"
    exit 1
fi

TARGET=$1

# Escanea los puertos abiertos y guarda los resultados en una variable
echo "Escaneando puertos abiertos en $TARGET..."
open_ports=$(nmap -n -v -T5 -p- --open -T4 $TARGET -oN puertos.txt | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed 's/,$//')

if [ -z "$open_ports" ]; then
    echo "No se encontraron puertos abiertos en $TARGET."
    exit 0
fi

echo "Puertos abiertos encontrados: $open_ports"

# Escanea los servicios en los puertos abiertos
echo "Escaneando servicios en los puertos abiertos..."
nmap -n -v -T5 -sCV -p$open_ports $TARGET -oN servicios.txt
