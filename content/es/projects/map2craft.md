---
title: Map2Craft
date: 2026-01-25T00:00:00+00:00
hideMeta: true
ShowBreadCrumbs: true
comments: true
draft: false
tags: ["Minecraft", "Python"]
icon: "/projects/map2craft/icon.png"
cover: 
    image: "/projects/map2craft/cover.png"
---

Map2Craft es una aplicación en Python diseñada para crear mundos de Minecraft realistas a partir de datos geográficos reales. El proyecto se apoya en SCons para orquestar el flujo de trabajo: desde el procesado de relieves y profundidades marinas hasta el mapeo de la vegetación y la integración de elementos de OpenStreetMap (OSM) en un formato listo para usar en WorldPainter.

## ¿Qué puedes hacer?

### 🌍 Terrenos y profundidades reales

Descarga y procesa datos de elevación de alta resolución (SRTM/Copernicus) y los proyecta con precisión en metros (EPSG:3857).

* **Fusión de batimetría**: Combina el relieve terrestre con datos de profundidad oceánica (EMODnet/GEBCO) para lograr costas y fondos marinos naturales.
* **Ajuste del nivel del mar**: Control total sobre la cota cero y máscaras personalizadas para evitar errores visuales en zonas costeras.

### 🌲 Biomas y vegetación inteligente

Utiliza los datos de **ESA WorldCover** para asignar automáticamente el tipo de suelo real a los biomas de Minecraft.

* **Mapeo inteligente**: Los bosques, matorrales, pastizales y zonas áridas se convierten en sus biomas correspondientes de forma nativa.
* **Detección de relieves**: El sistema analiza las pendientes para asignar automáticamente biomas de acantilado o playas de piedra en terrenos escarpados.

### 🛣️ Integración con OpenStreetMap

Importa datos vectoriales de OSM para dar vida al mapa con infraestructuras humanas.

* **Carreteras**: Dibuja redes viales (desde autopistas hasta calles residenciales) directamente sobre el terreno con anchos ajustables.
* **Edificios**: Genera la planta de los edificios. Puedes usar bloques básicos o **esquemas personalizados** (como catedrales, molinos o torres) definidos en el `config.yaml`.
* **Vías fluviales**: Los ríos y arroyos se tallan siguiendo la lógica del terreno para que el flujo de agua sea consistente.

### 🎨 Automatización para WorldPainter

Genera un script `build_world.js` que se encarga de todo el proceso de creación dentro de WorldPainter.

* **Gestión de capas**: Aplica mapas de altura, biomas y capas de anotación de forma automática.
* **Listo para jugar**: Exporta directamente un archivo `.world` listo para pasar a Minecraft.

### 🖼️ Previsualización

Cuenta con un proceso de generación de imágenes dedicado (`scons preview`) para revisar el progreso mediante mapas específicos:

* **Mapa de alturas**: `assets/img/heightmap.png`
* **Terreno**: `assets/img/terrain.png`
* **Cobertura vegetal**: `assets/img/land_cover.png`
* **Biomas**: `assets/img/biomes.png`
* **Esquemas**: `assets/img/artifacts.png`

## Preparativos

* **Python 3.10+**
* **WorldPainter**: Instalado y configurado en las variables de entorno del sistema.
* **SCons**: Para gestionar la automatización de tareas.

## Instalación

1. Clona el repositorio en tu equipo.
2. Instala las depencias de Python:
  ```bash
  pip install -r requirements.txt
  ```
  *Nota: Dependiendo de tu sistema operativo, es posible que necesites instalar `gdal` para que funcionen las depencias de `rasterio` y `osgeo`.*

## Configuración

Todo se ajusta desde un archivo `.yaml` en la carpeta `config/`. Los parámetros principales son:

* **Project**: Nombre del proyecto y rutas de las carpetas.
* **Geospatial**: Define las coordenadas (`bounds`: min_lon, min_lat, max_lon, max_lat) y la resolución.
* **Minecraft**: Ajusta límites de altura, nivel del mar y la escala del mundo.
* **Features**: Activa o desactiva a tu gusto biomas, carreteras, edificios, ríos, etc.

## Cómo se usa

Este proyecto utiliza **SCons** para gestionar el flujo de trabajo. Todos los comandos se lanzan desde la carpeta raíz.

### Construcción completa

Para procesar todo el pipeline, generar el mundo e instalarlo directamente en tu carpeta de partidas guardadas de Minecraft:

```bash
scons
```

*(Esto ejecuta el objetivo `install` por defecto)*

### Tareas específicas

Si prefieres ejecutar el proceso por partes:

* **Generar previsualizaciones**:
  ```bash
  scons preview
  ```

Crea las imágenes de prueba en `build/[nombre_del_proyecto]/preview/`.
* **Procesar solo el relieve**:
  ```bash
  scons process
  ```

* **Descargar y procesar datos de OSM**:
  ```bash
  scons roads buildings waterways
  ```

* **Generar el mundo de WorldPainter**:
  ```bash
  scons world
  ```
  Crea el archivo `.world` en `output/` usando el script generado.

* **Exportar el mapa**:
  ```bash
  scons export
  ```
  Convierte el archivo `.world` en una carpeta de mundo de Minecraft dentro de `output/worlds/`.

## Estructura del Proyecto

* `config/`: Archivos de configuración (ej. `default.yaml`).
* `SConstruct`: Definición de las tareas de construcción para SCons.
* `src/`: Módulos del código fuente.
  * `data.py`: Descarga de elevaciones y batimetría.
  * `geospatial.py`: Procesado, escalado y proyección del terreno.
  * `biomes.py`: Clasificación y mapeo de biomas.
  * `osm.py`, `roads.py`, `buildings.py`, `waterways.py`: Integración de datos de OSM.
  * `worldpainter.py`: Generación del script de automatización.
  * `visualize.py`: Lógica para las imágenes de previsualización.
  * `amulet_editor.py`: Procesado final y colocación de elementos en el mundo.
* `build/`: Archivos temporales, datos brutos y máscaras intermedias (organizado por proyecto).
* `assets/`: Recursos estáticos como los `schematics/` para los edificios.
