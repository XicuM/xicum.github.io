---
title: "InfoHotel"
date: 2024-10-14T00:06:49+02:00
hideMeta: true
ShowBreadCrumbs: true
comments: true
draft: false
tags: [Flutter, Raspberry Pi, Python, Ibiza]
icon: "/projects/infoHotel/icon.png"
github: https://github.com/XicuM/infoHotel
cover: 
    image: "/projects/infoHotel/screenshot.jpg"
---

InfoHotel is a kiosk application for hotel lobbies, built with **Flutter** and designed to run on a **Raspberry Pi 3B+**.

Instead of a static bulletin board, guests get a touchscreen where they can check:

- **Weather** — live data from AEMET OpenData
- **Flights** — real-time arrival and departure info for Ibiza airport
- **Bus schedules** — upcoming departures from nearby stops via ALSA's GTFS API
- **Local info** — a directory of services, excursions, markets, beaches (with distance from the hotel), shows, and useful websites

The app supports **7 languages** (English, Spanish, Catalan, French, German, Italian, and Dutch) and runs in immersive kiosk mode — no browser chrome, no desktop, just the app.

Hotel-specific content (excursions, markets, beaches) can be edited on-screen by staff without touching any code.

## Screenshots

{{< gallery match="*.jpg" sortOrder="asc" rowHeight="150" margins="8" thumbnailResizeOptions="600x600 q80 Lanczos" previewType="blur" thumbnailHoverEffect="enlarge" embedPreview=true lastRow="nojustify" loadJQuery=true >}}
