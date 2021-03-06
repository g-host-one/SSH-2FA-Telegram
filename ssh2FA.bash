#!/bin/bash
# SSH-2FA-Telegram => SECURE YOUR SHELL LOGIN

#### CONFIGURATION ####
RECALL_SHELL="/bin/bash"
URGENT_KEY="l0g1nplz"
### TELEGRAM CONFIG ###
APIKEY="" # Insert Telegram Bot API KEY here
CHATID="" # Insert Chat ID here
#######################

echo ""
echo " --------------------- "
echo " | 2 F A - S h e l l | "
echo " |     L o g i n     | "
echo " --------------------- "
echo " Login with $(whoami) [at] $(hostname) "
echo ""

function RandomKey() {
	awk 'BEGIN {
	   srand()
	   for (i=1;i<=1;i++){
	     print int(rand() * 1000000)
	   }
	}'
}
KEYCODE=$(RandomKey)

if [[ ! -z $(curl -s "https://api.telegram.org/bot${APIKEY}/sendMessage?chat_id=${CHATID}&parse_mode=Markdown&text=2FA-SHELL+OTP%0A%0D%0A%0D%60HOSTNAME+:%60+*$(hostname)*%0A%0D%60USERNAME+:%60+*$(whoami)*%0A%0D%60OTP+KEY++:%60+*${KEYCODE}*" 2> /dev/null | grep '"ok":true') ]]; then
	echo " INFO: OTP Sent!"
	for counter in {1..3}
	do
		echo -ne " Input OTP Key : "
		read OTP 
		if [[ ${OTP} == ${KEYCODE} ]]; then
			echo ""
			echo " INFO: Login Successfully!"
			echo ""
			curl -s "https://api.telegram.org/bot${APIKEY}/sendMessage?chat_id=${CHATID}&parse_mode=Markdown&text=2FA-SHELL+ALERT%0A%0D%0A%0D$(whoami)@$(hostname)%0A%0D%0A%0D*LOGIN+SUCCESSFULLY!*" &> /dev/null
			${RECALL_SHELL}
			exit
		else
			echo " ERROR: auth-fail (${counter}/3)"
			echo ""
		fi
	done
	echo " ERROR: Login attempt failed."
	curl -s "https://api.telegram.org/bot${APIKEY}/sendMessage?chat_id=${CHATID}&parse_mode=Markdown&text=2FA-SHELL+ALERT%0A%0D%0A%0D$(whoami)@$(hostname)%0A%0D%0A%0D*LOGIN+FAILED!*" &> /dev/null
	exit
else
	echo " ERROR: Send OTP code failed."
	echo " INFO: You can login with URGENT_KEY"
	echo -ne " Input URGENT_KEY : "
	read URGENT_INPUT
	if [[ ${URGENT_INPUT} == ${URGENT_KEY} ]]; then
		${RECALL_SHELL}
		exit
	else
		echo " ERROR: Invalid URGENT_KEY"
		exit
	fi
fi
