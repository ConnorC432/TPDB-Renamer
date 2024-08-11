#!/bin/bash
# curl https://raw.githubusercontent.com/ConnorC432/TPDB-Renamer/main/Linux/install.sh | sudo bash

#Download files
mkdir /usr/share/tpdb-rename
curl https://raw.githubusercontent.com/ConnorC432/TPDB-Renamer/main/tpdb-rename.py -o /usr/share/tpdb-rename/tpdb-rename.py
curl https://raw.githubusercontent.com/ConnorC432/TPDB-Renamer/main/Linux/tpdb-rename -o /usr/bin/tpdb-rename
chmod -R 755 /usr/share/tpdb-rename

##Determine whether crontab or systemd is installed
cron_available=false
systemd_available=false

#Check if crontab is installed
if command -v crontab &> /dev/null; then
  cron_available=true
fi

#Check if systemd is installed
if command -v crontab &> /dev/null; then
  systemd_available=true
fi


##Determine User/Group
read -rp "Enter the user to run the script under" script_user
read -rp "Enter the group to run the script under" script_group

#Determine whether crontab or systemd is being used
cron_using=false
systemd_using=false

if [[ $cron_available == true && $systemd_available == true ]]; then
  echo "Choose whether to use a cron job or systemd"
  echo "1) crontab"
  echo "2) systemd"
  read -rp "Choose an option (1/2): " cron_systemd_choice

  if [[ $cron_systemd_choice == "1" ]]; then
    cron_using=true
  elif [[ $cron_systemd_choice == "2" ]]; then
    systemd_using=true
  else
    echo "invalid choice"
    exit 1
  fi

elif [[ $cron_available == true ]]; then
  cron_using=true

elif [[ $systemd_available == true ]]; then
  systemd_using=true

else
  echo "Neither crontab or systemd is installed, exiting installation"
  exit 1
fi


#Determine script use frequency
echo "Select the frequency at which files will be renamed"
echo "1) Every minute"
echo "2) Every 5 minutes"
echo "3) Every 15 minutes"
echo "4) Every hour"
echo "5) Every day"

while true; do
  read -rp "Choose an option (1-5): " frequency
  case $frequency in
    1)
      cron_frequency="* * * * *"
      systemd_frequency="*:0/1"
      break
      ;;
    2)
      cron_frequency="5 * * * *"
      systemd_frequency="*:0/5"
      break
      ;;
    3)
      cron_frequency="*/15 * * * *"
      systemd_frequency="*:0/15"
      break
      ;;
    4)
      cron_frequency="0 * * * *"
      systemd_frequency="hourly"
      break
      ;;
    5)
      cron_frequency="0 0 * * *"
      systemd_frequency="daily"
      break
      ;;
    *)
      echo "Invalid choice, please try again."
      ;;
  esac
done


#Build TV Directories array
echo "Enter the TV directories to be renamed (type 'done' to quit)"
tv_dirs=()

while true; do
  read -rp "Input Directory: " dir

  if [[ "$dir" =~ ^(done|exit|quit|q|bye)$ ]]; then
    break
  fi

  #Add valid directories to array
  if [[ -d "$dir" ]]; then
    tv_dirs+=("$dir")

  else
    echo "'$dir' is not a valid directory."
  fi
done


#Build Film Directories array
echo "Enter the Film directories to be renamed (type 'done' to quit)"
film_dirs=()

while true; do
  read -rp "Input Directory: " dir

  if [[ "$dir" =~ ^(done|exit|quit|q|bye)$ ]]; then
    break


  #Add valid directories to array
  elif [[ -d "$dir" ]]; then
    film_dirs+=("$dir")

  else
    echo "'$dir' is not a valid directory."
  fi
done


#Add service
if [[ $cron_using == true ]]; then
  (crontab -u "$script_user" -l 2>/dev/null; echo "$cron_frequency  /usr/bin/python3 /usr/share/tpdb-rename.py -t $(printf '%s ' "${tv_dirs[@]}") | sed 's/ $//') -f $(printf '%s ' "${film_dirs[@]}")") | crontab -u "$script_user" -
elif [[ $systemd_using == true ]]; then

  #systemd service
  echo "[Unit]
Description=tpdb-rename service

[Service]
Type=oneshot
User=$script_user
Group=$script_group
ExecStart=/usr/bin/python3 /usr/share/tpdb-rename.py -t $(printf '%s ' "${tv_dirs[@]}") -f $(printf '%s ' "${film_dirs[@]}")" | sudo tee /etc/systemd/system/tpdb-rename.service > /dev/null

  #systemd timer
  echo "[Unit]
Description=tpdb-rename timer

[Timer]
OnCalendar=$systemd_frequency
Persistent=true

[Install]
WantedBy=timers.target" | sudo tee /etc/systemd/system/tpdb-rename.timer > /dev/null

  #Enable timer
  sudo systemctl daemon-reload
  sudo systemctl enable --now tpdb-rename@tpdb-rename.time

else
    echo "Error, neither crontab or systemd is installed or was selected"
    exit 1
fi

echo "Install Complete"
exit 0