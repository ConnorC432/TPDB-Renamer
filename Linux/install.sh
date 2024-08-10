# curl https://raw.githubusercontent.com/ConnorC432/TPDB-Renamer/main/Linux/install.sh | bash
mkdir /usr/share/tpdb-rename
curl https://raw.githubusercontent.com/ConnorC432/TPDB-Renamer/main/tpdb-rename.py -o /usr/share/tpdb-rename/tpdb-rename.py
echo /usr/bin/python3 /usr/share/tpdb-rename/tpdb-rename.py >> /usr/share/tpdb-rename/tpdb-rename
chmod 755 /usr/share/tpdb-rename/*
ln -s /usr/share/tpdb-rename/tpdb-rename.py /usr/bin/tpdb-rename