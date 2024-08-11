# TPDB-Renamer

[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/license/gpl-3-0/)

## Authors

- [ConnorC432](https://github.com/ConnorC432)

## Features

Batch renames all poster image files to match Plex's Local Media Asset formats.\
[TV Local Media Assets Format](https://support.plex.tv/articles/200220717-local-media-assets-tv-shows/)\
[Film Local Media Assets Format](https://support.plex.tv/articles/200220677-local-media-assets-movies/)

## Install
### Linux:
```
curl https://raw.githubusercontent.com/ConnorC432/TPDB-Renamer/main/Linux/install.sh | sudo bash
```

## Documentation

### Usage: tpdb-rename.py [-h] [-t TV [TV ...]] [-f FILM [FILM ...]]

#### Options:

#### [-h|--help]

#### [-t|--tv]		TV	[TV ...]

- Specify the root TV directory(s) to rename
- Leave empty to rename files in current directory

#### [-f|--film]	Film	[Film ...]

- Specify the root Film directory(s) to rename
- Leave empty to rename files in current directory
