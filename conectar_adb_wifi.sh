#!/bin/bash

# Función para listar servicios y solicitar la selección del usuario
list_services_for_pair_connect() {
    local no_connect="$1"

    # Ejecutar el comando adb mdns services y filtrar la línea de encabezado
    services=$(get_mdns_services)

    # Verificar si no se encontraron servicios
    if [ -z "$services" ]; then
        echo "No se encontraron servicios disponibles."
        exit 1
    fi

    # Mostrar los servicios numerados con IP y puerto
    echo "Servicios disponibles para emparejar:"
    echo "$services" | awk '{print NR".", $0}'

    # Pedir al usuario que elija un servicio
    read -p "Elige el número correspondiente al servicio que deseas: " choice

    # Validar la elección del usuario
    if [[ $choice =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "$(echo "$services" | wc -l)" ]; then
        # Extraer la IP y el puerto del servicio seleccionado
        chosen_service=$(echo "$services" | sed -n "${choice}p")
        echo "Seleccionaste: $chosen_service"
        
        # Extraer la IP y el puerto del servicio seleccionado
        ip=$(get_ip_from_service "$chosen_service")
        pair_port=$(get_port_from_service "$chosen_service")
        
        # Ejecutar adb pair con el puerto correspondiente
        adb pair "$ip:$pair_port"
        
        # Verificar si no se debe ejecutar list_services_for_connect
        if [ "$no_connect" != true ]; then
            # Volver a listar los servicios para seleccionar el puerto de conexión
            list_services_for_connect "$services"
        fi
    else
        echo "Opción no válida. Por favor, elige un número válido."
    fi
}

# Función para listar servicios y seleccionar el puerto de conexión
list_services_for_connect() {
    local services="$1"

    # Verificar si no se encontraron servicios
    if [ -z "$services" ]; then
        echo "No se encontraron servicios disponibles."
        exit 1
    fi

    # Mostrar los servicios numerados con IP y puerto
    echo "Servicios disponibles para conectar:"
    echo "$services" | awk '{print NR".", $0}'
    
    # Pedir al usuario que elija un servicio
    read -p "Elige el número correspondiente al servicio para conectar: " choice

    # Validar la elección del usuario
    if [[ $choice =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "$(echo "$services" | wc -l)" ]; then
        # Extraer la IP y el puerto del servicio seleccionado
        chosen_service=$(echo "$services" | sed -n "${choice}p")
        ip=$(get_ip_from_service "$chosen_service")
        connect_port=$(get_port_from_service "$chosen_service")
        echo "Seleccionaste: $chosen_service"
        
        # Ejecutar adb connect con el puerto correspondiente
        adb connect "$ip:$connect_port"
    else
        echo "Opción no válida. Por favor, elige un número válido."
    fi
}

# Función para obtener los servicios mdns
get_mdns_services() {
    adb mdns services | grep -v "List of discovered mdns services"
}

# Función para extraer la IP de un servicio
get_ip_from_service() {
    local service="$1"
    echo "$service" | awk '{print $3}' | cut -d ':' -f 1
}

# Función para extraer el puerto de un servicio
get_port_from_service() {
    local service="$1"
    echo "$service" | awk '{print $3}' | cut -d ':' -f 2
}

# Inicializar variables
pair_mode=false
no_connect=false

# Procesar los parámetros
while [ $# -gt 0 ]; do
    case "$1" in
        --pair)
            pair_mode=true
            ;;
        --no-connect)
            no_connect=true
            ;;
        *)
            echo "Parámetro no reconocido: $1"
            exit 1
            ;;
    esac
    shift
done

# Ejecutar las funciones correspondientes según los parámetros
if [ "$pair_mode" = true ]; then
    list_services_for_pair_connect "$no_connect"
else
    list_services_for_connect "$(get_mdns_services)"
fi