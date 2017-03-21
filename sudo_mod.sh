#dodanie grupy sudo i umozliwienie sudo bez hasla

SUDO_CHECK=`cat /etc/group | grep sudo`
SUDOERS_CHECK=`cat /etc/sudoers | grep %sudo`

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
				echo
			else
				#jesli id wolne, to dodaje grupe sudo z pierwszym wolnym id
				#echo mamy dobra liczbe $pom
				echo sudo:x:$pom: >> /etc/group
			fi

                elif [ "$POTWIERDZENIE" = "n" ] || [ "$POTWIERDZENIE" = "no" ]; then
                        echo -e "\\033[31mExiting...\\033[0m";
                else echo -e "\\033[31mNiedozwolony znak!\\033[0m";
                fi

else
	echo "sudo group exist"
fi

if $SUDOERS_CHECK 2>/dev/null; then
        echo "visudo - missing line with NOPASSWD login for sudo group"
	echo -e "Do you want to add sudo group to NOPASSWD login? (y-yes n-no)"
	read POTWIERDZENIE
	if [ "$POTWIERDZENIE" = "y" ] || [ "$POTWIERDZENIE" = "yes" ]; then
		echo -e "%sudo\tALL=(ALL)\tNOPASSWD:ALL">> /etc/sudoers
	elif [ "$POTWIERDZENIE" = "n" ] || [ "$POTWIERDZENIE" = "no" ]; then
		echo -e "\\033[31mExiting...\\033[0m";
	else echo -e "\\033[31Unauthorized sign!\\033[0m";
fi


else
	#wpis o logowanie bez hasla juz istnieje
	#echo "visudo - line with NOPASSWD login for sudo group already exist"
	echo
fi
