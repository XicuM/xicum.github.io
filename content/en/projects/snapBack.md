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

This project consists on a series of scripts in Python to backup and restore my files. It was born from my personal need to backup my files with little additional storage.

The scripts use `rclone` to sync files from my computer to several remote storage services and creates a backup structure in the `.snapback` folder in the root of the remotes, so I have acces to different snapshots of my files.

The project can be adapted to your needs by changing the remotes and directories to be backup changing the `config.yaml` file.

## Usage

1. Install [rclone](https://rclone.org/) on your system.
2. Clone this repository.
3. Run `python backup.py` to backup your files. Otherwise, you can schedule the backup script to run periodically by running `python schedule.py`.
4. Run `python restore.py <remote> <directory> <snapback>` to restore your files, being:
   - `<remote>` the alias of your remote
   - `<directory>` the name of the directory to restore (e.g. `directory1`)
   - `<snapback>` the name of the backup to restore (e.g. `hourly.12`)

The default available backups for each directory are: `hourly.12`, `hourly.16`, `hourly.20`, `hourly.24`, `daily.1`, `daily.2`, `daily.3`, `weekly.1`, `weekly.2`, `monthly.1`, `monthly.2`, `monthly.3`, `yearly.1` and `yearly.2`.

As the name suggests, the four hourly backups are created every 12, 16, 20 and 24 hours. It is easy to see that:
- The 3 first daily backups are stored in the daily folders
- The 2 first weekly backups are stored in the weekly folders
- The 3 first monthly backups are stored in the monthly folders
- The 2 first yearly backups are stored in the yearly folders.

> ⚠️ Since the backups are incremental, you cannot restore a backup by simply copying the files from the backup folder to the main directory. You need to use the `restore.py` script.

## Philosophy

### Backup pipeline

{{< figure src="/projects/snapBack/pipeline.jpg" alt="Backup pipeline" caption="Backup pipeline" >}}

To understand the backup pipeline, the following diagram is drawm. The diagram shows each folder as a square node. The arrows represent each one of the transfer of files. The data is transfered from one square node to the next one each time the backup script is executed, acting as a pipeline. The circles (and the trapezoid) represent the operations the files are subject to. There are four operations used:

- **Directory accumulation** (➕). It is defined as the operation of adding the files from the source directory to the destination directory, without overwriting existing files. This operation ensures that the destination directory contains the oldest version of each file:
    $$ AB + A'B => AB $$
    with $A$, $A'$ and $B$ as files where $A$ and $A'$ are two versions of a file such that $A < A'$, defining $<$ as "older than".

- **Directory differencing** (➖). It is defined as the operation of obtaining only the files that are different between the source and destination directories. This operation ensures that the destination directory only contains the newest version of each file:
    $$ A'B - AB => A' $$
    with $A$, $A'$ and $B$ as files where $A$ and $A'$ are two versions of a file such that $A < A'$, defining $<$ as "older than".

- **Buffering** (▶️). The tri-state buffer operation permits or forbids the files to access the destination directory, depending on the given condition. The circle at the bottom of the triangle represents the negation of the condition that is given.

- **Decoding** (represented by the trapezium). Selects one of multiple destination directories for the source directory, based on a given condition. Works as a switch in programming.

### Restoring

With this approach restoring files becomes easy. It is only necessary to accumulate the files from the desired directory back to the main directory.

## Folder structure

Each one of the source selected directories are synced with a directory in the root of the remote.

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