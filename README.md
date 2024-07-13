
# adb-connect-sh

![Usage](https://raw.githubusercontent.com/AngelKrak/adb-connect-sh/main/screen/screen1.png)

Conecta dispositivos Android a través de ADB y multicast DNS utilizando depuración inalámbrica o por cable (versión Bash).

## Descripción

Este proyecto proporciona un script en Bash para listar, emparejar y conectar dispositivos Android a través de ADB y multicast DNS. Facilita la depuración inalámbrica al permitir una fácil selección de dispositivos en la red.

## Requisitos

- Tener `adb` instalado y configurado en tu PATH.
- Dispositivos compatibles con ADB a través de Wi-Fi.

## Instalación

Para instalar globalmente usando npm:

```bash
npm install -g adb-connect-sh
```

## Uso

### Ejecutar el Script

```bash
adb-connect-sh [opciones]
```

### Opciones Disponibles

- `--pair`: Lista los servicios disponibles para emparejar y permite seleccionar uno. Después de emparejar, también lista los servicios para conectar.
- `--no-connect`: Si se usa con `--pair`, no lista los servicios para conectar después de emparejar.
- Sin opción: Lista los servicios disponibles para conectar y permite seleccionar uno.

### Ejemplos

#### Emparejar y Conectar

```bash
adb-connect-sh --pair
```

1. El script listará los servicios disponibles para emparejar.
2. Se te pedirá que selecciones el número correspondiente al servicio deseado.
3. Después de emparejar, se te pedirá que selecciones el número correspondiente al servicio para conectar.

#### Solo Conectar

```bash
adb-connect-sh
```

1. El script listará los servicios disponibles para conectar.
2. Se te pedirá que selecciones el número correspondiente al servicio deseado.

#### Emparejar Sin Conectar

```bash
adb-connect-sh --pair --no-connect
```

1. El script listará los servicios disponibles para emparejar.
2. Se te pedirá que selecciones el número correspondiente al servicio deseado.
3. El script finalizará después de emparejar sin listar los servicios para conectar.