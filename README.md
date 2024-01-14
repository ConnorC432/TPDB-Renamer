# TPDB-Renamer


[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/license/gpl-3-0/)

## Authors

- [ConnorC432](https://github.com/ConnorC432)

## Features

Batch renames all poster image files to match Plex's Local Media Asset formats.\
[TV Local Media Assets Format](https://support.plex.tv/articles/200220717-local-media-assets-tv-shows/)\
[Film Local Media Assets Format](https://support.plex.tv/articles/200220677-local-media-assets-movies/)

## Documentation

### Usage: rename.sh [OPTIONS] [ARGUMENTS]

#### Options:

#### [-h|--help]
#### [-t|-tv]	[TV Directory]		[Second TV Directory...]
- Specify the root TV directory(s) to rename
- Leave empty to rename files in current directory
#### [-f|-film]	[Film Directory]	[Second Film Directory...]
- Specify the root Film directory(s) to rename
- Leave empty to rename files in current directory
#### [-d|-default]
- Rename both TV and Film default directory(s)
#### [-dt|-defaulttv]
- Rename TV default directory(s)
#### [-df|-defaultfilm]
- Rename Film default directory(s)


## Appendix

Currently only Linux scripts, windows scripts don't work.
