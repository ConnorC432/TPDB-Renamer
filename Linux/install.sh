#!/bin/bash
# curl https://raw.githubusercontent.com/ConnorC432/TPDB-Renamer/main/Linux/install.sh | sudo bash
mkdir /usr/share/tpdb-rename
curl https://raw.githubusercontent.com/ConnorC432/TPDB-Renamer/main/tpdb-rename.py -o /usr/share/tpdb-rename/tpdb-rename.py
curl https://raw.githubusercontent.com/ConnorC432/TPDB-Renamer/main/Linux/tpdb-rename -o /usr/share/tpdb-rename/tpdb-rename
chmod -R 755 /usr/share/tpdb-rename
ln -s /usr/share/tpdb-rename/tpdb-rename.py /usr/bin/tpdb-rename