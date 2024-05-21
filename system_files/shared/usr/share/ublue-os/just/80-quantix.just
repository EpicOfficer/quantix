# vim: set ft=make :

# Force-enable AMD pstate
pstate-force-enable:
    rpm-ostree kargs --append-if-missing=amd_pstate=active

# Configure grub bootmenu visibility and fix duplicate entries
configure-grub ACTION="":
    #!/usr/bin/bash
    source /usr/lib/ujust/ujust.sh
    GRUB_STATE="$(grep -P "^GRUB_TIMEOUT_STYLE=hidden" /etc/default/grub)"
    OPTION={{ ACTION }}
    if [ "$GRUB_STATE" == "GRUB_TIMEOUT_STYLE=hidden" ]; then
        GRUB_STATE="${b}Hidden${n}"
    else
        GRUB_STATE="${b}Not Hidden${n}"
    fi
    if [ "$OPTION" == "help" ]; then
      echo "Usage: ujust configure-grub <option>"
      echo "  <option>: Specify the quick option to skip the prompt"
      echo "  Use 'hide' to select Hide Grub"
      echo "  Use 'unhide' to select Unhide Grub"
      echo "  Use 'fix' to select Fix double ostree entry"
      exit 0
    elif [ "$OPTION" == "" ]; then
      echo "${bold}Grub menu configuration${normal}"
      echo "Grub menu is set to: $GRUB_STATE"
      OPTION=$(Choose "Hide Grub" "Unhide Grub" "Fix double ostree entry")
    fi
    if [[ "${OPTION,,}" =~ ^hide ]]; then
      sudo sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
      echo 'GRUB_TIMEOUT_STYLE=hidden' | sudo tee -a /etc/default/grub 1>/dev/null
      echo 'GRUB_HIDDEN_TIMEOUT=1' | sudo tee -a /etc/default/grub 1>/dev/null
      if [ -d /sys/firmware/efi ]; then
        sudo grub2-mkconfig -o /etc/grub2-efi.cfg
      else
        sudo grub2-mkconfig -o /etc/grub2.cfg
      fi
    elif [[ "${OPTION,,}" =~ ^unhide ]]; then
      sudo sed -i '/GRUB_HIDDEN_TIMEOUT=1/d' /etc/default/grub
      sudo sed -i '/GRUB_TIMEOUT_STYLE=hidden/d' /etc/default/grub
      sudo sed -i 's/GRUB_TIMEOUT=0/GRUB_TIMEOUT=5/g' /etc/default/grub
      if [ -d /sys/firmware/efi ]; then
        sudo grub2-mkconfig -o /etc/grub2-efi.cfg
      else
        sudo grub2-mkconfig -o /etc/grub2.cfg
      fi
    elif [[ "${OPTION,,}" =~ ^fix ]]; then
      sudo grub2-switch-to-blscfg
      if [ -d /sys/firmware/efi ]; then
        sudo grub2-mkconfig -o /etc/grub2-efi.cfg
      else
        sudo grub2-mkconfig -o /etc/grub2.cfg
      fi
    fi

# Add user to "input" group required by certain controller drivers
add-user-to-input-group:
    #!/usr/bin/bash
    if ! grep -q "input" /etc/group; then
      sudo bash -c 'grep "input" /lib/group >> /etc/group'
    fi
    sudo usermod -a -G input $USER

# Set the default powerprofile to load when the desktop starts
configure-powerprofile ACTION="":
    #!/usr/bin/bash
    source /usr/lib/ujust/ujust.sh
    OPTION={{ ACTION }}
    if [ "$OPTION" == "help" ]; then
      echo "Usage: ujust configure-powerprofile <option>"
      echo "  <option>: Specify the quick option to skip the prompt"
      echo "  Use 'powersave' to select Powersave"
      echo "  Use 'balanced' to select Balanced"
      exit 0
    elif [ "$OPTION" == "" ]; then
      # Cleanup old method
      if [ -f "~/.config/autostart/bazzite-powersave.desktop" ]; then
        rm ~/.config/autostart/bazzite-powersave.desktop
      fi
      # New method from here on
      echo "${bold}Power profile configuration${normal}"
      echo "This lets you set the default power profile."
      echo "We do not recommend changing this from ${b}Balanced${n} if you use this device primarily for gaming!"
      echo "If you have any performance or audio related issues..."
      echo "${invert}${b}Please test with the default power profile set to Balanced${n} before reporting!"
      echo ""
      echo "Which power profile do you want to use when the desktop loads?"
      OPTION=$(Choose "Powersave" "Balanced")
    fi
    if [[ "${OPTION,,}" =~ powersave ]]; then
      echo "Setting default powerprofile to ${b}Powersave${n}"
      sudo sed -iE 's/default=(.+)/default=power-saver/' /etc/tuned/ppd.conf
      /usr/libexec/bazzite-powersave
    elif [[ "${OPTION,,}" =~ balanced ]]; then
      echo "Setting default powerprofile to ${b}Balanced${n}"
      sudo sed -iE 's/default=(.+)/default=balanced/' /etc/tuned/ppd.conf
      /usr/libexec/bazzite-powersave 0
    fi