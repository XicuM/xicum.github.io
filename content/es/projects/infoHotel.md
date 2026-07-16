---
title: "InfoHotel"
date: 2024-10-14T00:06:49+02:00
hideMeta: true
ShowBreadCrumbs: true
comments: false
draft: false
tags: [Flutter, Raspberry Pi, Python, Ibiza]
icon: "/projects/infoHotel/icon.png"
github: https://github.com/XicuM/infoHotel
cover: 
    image: "/projects/infoHotel/screenshot.jpg"
---

InfoHotel es una aplicación de quiosco para lobbies de hotel, desarrollada con **Flutter** y pensada para funcionar en una **Raspberry Pi 3B+**.

En lugar de un tablón de anuncios estático, los huéspedes tienen una pantalla táctil donde pueden consultar:

- **El tiempo** — datos en directo de AEMET OpenData
- **Vuelos** — llegadas y salidas en tiempo real del aeropuerto de Ibiza
- **Autobuses** — próximas salidas de paradas cercanas usando la API GTFS de ALSA
- **Información local** — un directorio con servicios, excursiones, mercadillos, playas (con distancia desde el hotel), espectáculos y webs útiles

La app funciona en **7 idiomas** (inglés, español, catalán, francés, alemán, italiano y neerlandés) y se ejecuta en modo quiosco inmersivo — sin navegador, sin escritorio, solo la aplicación.

El contenido específico del hotel (excursiones, mercadillos, playas) lo puede editar el personal desde la propia pantalla, sin tocar código.
