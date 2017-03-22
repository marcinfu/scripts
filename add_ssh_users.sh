#Last update 2017-03-07

L_POM=(`wc -l USERS.txt`)
L_WIERSZY=`expr $L_POM - 1`
#DATE=`date +%Y-%m-%d`
DATE=`date +%Y-%m-%d:%H:%M:%S`
SUDO_CHECK=`cat /etc/group | grep sudo`
SUDO_G_EXIST=0

#Dla CentOSa
#Sprawdzenie czy to CentOS

echo -e "\\033[32m\n### add_ssh_users ###\n\\033[0m"

                echo -e "*** Tworzenie kopii i podmiana pliku /etc/ssh/sshd_config ***\n"
cp /etc/ssh/sshd_config /etc/ssh/sshd_config-$DATE
cat > /etc/ssh/sshd_config << EOF
Port 22

Protocol 2

HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

UsePrivilegeSeparation yes

KeyRegenerationInterval 3600
ServerKeyBits 1024

SyslogFacility AUTH
LogLevel INFO

LoginGraceTime 120
PermitRootLogin no
StrictModes yes

RSAAuthentication yes
PubkeyAuthentication yes
AuthorizedKeysFile      %h/.ssh/authorized_keys

IgnoreRhosts yes

RhostsRSAAuthentication no

HostbasedAuthentication no
#IgnoreUserKnownHosts yes

PermitEmptyPasswords no

ChallengeResponseAuthentication no

PasswordAuthentication no

X11Forwarding yes
X11DisplayOffset 10
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes
#UseLogin no

#MaxStartups 10:30:60
#Banner /etc/issue.net

# Allow client to pass locale environment variables
AcceptEnv LANG LC_*

Subsystem sftp /usr/lib/openssh/sftp-server

UsePAM yes

Match user otadmin
        PasswordAuthentication yes
EOF

                #echo -e "\n\n\t########################################"
		
		#Sprawdzenie czy istnieje grupa sudo
		if $SUDO_CHECK 2>/dev/null; then
		echo "sudo group does not exist"
		echo -e "Do you want to add sudo group? (y-yes n-no)"
		read POTWIERDZENIE
		if [ "$POTWIERDZENIE" = "y" ] || [ "$POTWIERDZENIE" = "yes" ]; then
			echo -e "\\033[32mWorking...\\033[0m";
			pom=1000
			while [ `cat /etc/group | grep $pom` 2>/dev/null ]; do
			if `cat /etc/group | grep $pom` 2>/dev/null; then
				#jesli id grupy jest wolne
				echo "ID group: $pom is free"
			else
				#jesli id grupy jest w uzyciu sprawdza kolejne id
				#echo "ID group: $pom is already in use"
				pom=`expr $pom + 1`
			fi
			done
			#testowe wyswietlenie id grupy
			#echo $pom
			if `cat /etc/group | grep $pom` 2>/dev/null; then
				#jesli brak odpowiedniego id
				#echo nie mamy dobrej liczby $pom
				:
			else
				#jesli id wolne, to dodaje grupe sudo z pierwszym wolnym id
				#echo mamy dobra liczbe $pom
				echo sudo:x:$pom: >> /etc/group
				SUDO_G_EXIST=1
			fi

		elif [ "$POTWIERDZENIE" = "n" ] || [ "$POTWIERDZENIE" = "no" ]; then
			echo -e "\\033[31mExiting...\\033[0m";
		else echo -e "\\033[31mNiedozwolony znak!\\033[0m";
		fi

		else
			echo "sudo group exist"
			SUDO_G_EXIST=1
		fi

                for (( i=1; i <= $L_WIERSZY+1; i++ )) ; do
                        CN=`awk -v avar="$i" 'NR==avar{print $LICZBA1}' USERS.txt`;

                        TAB=( $CN )
                        LOGIN=`echo ${TAB[0]}`
                        KLUCZ=`echo ${TAB[1]}`

			echo -e "\\033[31m$LOGIN\\033[0m"
			echo "$KLUCZ"

			if id $LOGIN >/dev/null 2>&1; then
				echo "!!!!!!!!!!!!! $LOGIN exists !!!!!!!!!!!!!!!"
			else
				echo "!!!!!!!!!!!!!! $LOGIN does not exist !!!!!!!!!!!!!!!"

				useradd -m $LOGIN -s /bin/bash
				mkdir /home/$LOGIN/.ssh

				LICZNIK=`expr $LICZNIK + 1`

				cat > /home/$LOGIN/.ssh/authorized_keys << EOF
ssh-rsa $KLUCZ
EOF
			#Dodanie uzytkownika do grupy sudo
			if [ $SUDO_G_EXIST = 1 ]; then
				echo "$SUDO_G_EXIST wynosi 1"
			else
				echo "$SUDO_G_EXIST wynosi 0"
			fi

			fi

                done
		echo -e "\tLiczba dodanych uzytkownikow: $LICZNIK"
		echo -e "\t\nZrestartowac usluge sshd? (y-yes n-no)"
		read POTWIERDZENIE
		if [ "$POTWIERDZENIE" = "y" ] || [ "$POTWIERDZENIE" = "yes" ]; then
			echo -e "\\033[32mWorking...\\033[0m";
			service sshd restart
		elif [ "$POTWIERDZENIE" = "n" ] || [ "$POTWIERDZENIE" = "no" ]; then
			echo -e "\\033[31mExiting...\\033[0m";
		else echo -e "\\033[31mNiedozwolony znak!\\033[0m";
			exit 0;
fi
