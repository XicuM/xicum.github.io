---
title: snapBack
date: 2024-11-10T10:35:33+02:00
hideMeta: true
ShowBreadCrumbs: true
comments: true
showToc: true
tags: [Python]
github: https://github.com/XicuM/snapBack
icon: https://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Noto_Emoji_v2.034_1f9e2.svg/240px-Noto_Emoji_v2.034_1f9e2.svg.png
cover:
   image: projects/snapBack/cover.jpg
---

Este proyecto consiste en una serie de scripts en Python para hacer copias de seguridad y restaurar mis ficheros. El proyecto surge de mi necesidad personal de hacer copias de seguridad de mis ficheros intentando no ocupar mucho espacio adicional.

Los scripts usan `rclone` para sincronizar ficheros desde mi ordenador a varios servicios de almacenamiento remoto y crean una estructura de backup en la carpeta `.snapback` en los remotos, de manera que pueda tener acceso a diferentes instantáneas de mis ficheros.

El proyecto se puede adaptar a tus necesidades cambiando los remotos y las carpetas a respaldar modificando el archivo `config.yaml`.

## Uso

1. Instala [rclone](https://rclone.org/) en tu sistema.
2. Clona este repositorio.
3. Ejecuta `python backup.py` para hacer una copia de seguridad de tus archivos. Alternativamente, puedes programar el script de backup para que se ejecute periódicamente ejecutando `python schedule.py`.
4. Ejecuta `python restore.py <remote> <directory> <snapback>` para restaurar tus archivos, siendo:
   - `<remote>` el alias de tu remoto
   - `<directory>` el nombre dla carpeta a restaurar (por ejemplo, `directory1`)
   - `<snapback>` el nombre de la copia de seguridad a restaurar (por ejemplo, `hourly.12`)

Las copias de seguridad disponibles por defecto para cada carpeta son: `hourly.12`, `hourly.16`, `hourly.20`, `hourly.24`, `daily.1`, `daily.2`, `daily.3`, `weekly.1`, `weekly.2`, `monthly.1`, `monthly.2`, `monthly.3`, `yearly.1` y `yearly.2`.

Las cuatro copias de seguridad horarias se crean cada 12, 16, 20 y 24 horas. Es fácil ver que:
- Las 3 primeras copias de seguridad diarias se almacenan en las carpetas diarias
- Las 2 primeras copias de seguridad semanales se almacenan en las carpetas semanales
- Las 3 primeras copias de seguridad mensuales se almacenan en las carpetas mensuales
- Las 2 primeras copias de seguridad anuales se almacenan en las carpetas anuales

> ⚠️ Puesto que las copias de seguridad son incrementales, no se puede restaurar una copia de seguridad simplemente copiando los archivos de la carpeta de backup al directorio principal. Se necesita usar el script `restore.py`.

## Filosofía

### Pipeline de backup

{{< figure src="/projects/snapBack/pipeline.jpg" alt="Pipeline de backup" caption="Pipeline de backup" >}}

El diagrama de la pipeline muestra cada carpeta como un nodo cuadrado. Las flechas representan cada una de las transferencias de archivos. Los datos se transfieren de un nodo cuadrado al siguiente cada vez que se ejecuta el script de backup, actuando como un pipeline. Los círculos (y el trapecio) representan las operaciones a las que están sujetos los archivos. Hay cuatro operaciones utilizadas:

- **Acumulación de directorios** (➕). Se define como la operación de agregar los archivos dla carpeta fuente al directorio de destino, sin sobrescribir los archivos existentes. Esta operación asegura que la carpeta de destino contenga la versión más antigua de cada archivo:
    $$ AB + A'B => AB $$
    con $A$, $A'$ y $B$ como archivos donde $A$ y $A'$ son dos versiones de un archivo tal que $A < A'$, definiendo $<$ como "más antiguo que".

- **Diferenciación de directorios** (➖). Se define como la operación de obtener solo los archivos que son diferentes entre los directorios fuente y destino. Esta operación asegura que la carpeta de destino solo contenga la versión más nueva de cada archivo:
    $$ A'B - AB => A' $$
    con $A$, $A'$ y $B$ como archivos donde $A$ y $A'$ son dos versiones de un archivo tal que $A < A'$, definiendo $<$ como "más antiguo que".

- **Buffering** (▶️). La operación de buffer triestado permite o prohíbe que los archivos accedan al directorio de destino, dependiendo de la condición dada. El círculo en la parte inferior del triángulo representa la negación de la condición dada.

- **Decodificación** (representada por el trapecio). Selecciona uno de los múltiples directorios de destino para la carpeta fuente, basado en una condición dada. Funciona como un interruptor en programación.

### Restauración

Con este enfoque, restaurar es bastante sencillo. Solo se necesitan recorrer en sentido inverso la pipeline de backup, acumulando progresivamente los archivos de la carpeta selecionado hasta la carpeta principal.

## Estructura de carpetas

Cada uno de los directorios fuente seleccionados se sincroniza con un directorio en la raíz del remoto.

```
📁 remote:/
├── 📁 .snapbacks/
|   ├── 📁 directory1/
|   |    ├── 📁 hourly.12/
|   |    ├── 📁 hourly.16/
|   |    ├── 📁 hourly.20/
|   |    ├── 📁 hourly.24/
|   |    ├── 📁 daily.1/
|   |    ├── 📁 daily.2/
|   |    ├── 📁 daily.3/
|   |    ├── 📁 weekly.1/
|   |    ├── 📁 weekly.2/
|   |    ├── 📁 monthly.1/
|   |    ├── 📁 monthly.2/
|   |    ├── 📁 monthly.3/
|   |    ├── 📁 yearly.1/
|   |    └── 📁 yearly.2/
|   └── 📁 directory2/   
|        └── 📁 ...       
├── 📁 directory1/
└── 📁 directory2/
```