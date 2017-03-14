echo -e "\\033[32m\n###########################\n###	add module	###\n###########################\n\\033[0m"

                echo -e "*** Czyszczenie plikow podrecznych - adduser.ldif ***"
                echo "" > adduser.ldif

                echo -e "\n\n\t########################################"

                for (( i=2; i <= $L_WIERSZY+1; i++ )) ; do
                        CN=`awk -v avar="$i" 'NR==avar{print $LICZBA1}' USERS.txt`;

			TAB=( $CN )
                        IMIE=`echo ${TAB[0]}`
                        NAZWISKO=`echo ${TAB[1]}`
                        MAIL=`echo ${TAB[2]}`
                        #Wszystko malymi literami
                        IMIE=`echo "$IMIE" | tr '[:upper:]' '[:lower:]'`
                        NAZWISKO=`echo "$NAZWISKO" | tr '[:upper:]' '[:lower:]'`
                        MAIL=`echo "$MAIL" | tr '[:upper:]' '[:lower:]'`
                        #Imie i nazwisko rozpoczynajac z duzych liter
                        IMIE="${IMIE[@]^}"
                        NAZWISKO="${NAZWISKO[@]^}"

                        PASS_TMP=`apg -n 1 -a 1 -m 16`;
                        PASS=`echo -n $PASS_TMP | shasum -a 1 | awk '{print $1}'`;

			if [ "$IMIE" != "" ] && [ "$NAZWISKO" != "" ] && [ "$MAIL" != "" ]; then
				echo -e "\tHaslo dla uzytkownika -- $IMIE $NAZWISKO $MAIL --: \\033[34m$PASS_TMP\\033[0m\n\tw formacie sha: $PASS\n"
				LICZNIK=`expr $LICZNIK + 1`

				cat >> adduser.ldif << EOF
#adding new user
dn: cn=$IMIE $NAZWISKO,ou=sbu,ou=users,dc=otlabs
changetype: add
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
objectClass: top
userPassword:: $PASS
mail: $MAIL
givenName: $IMIE
uid: $MAIL
cn: $IMIE $NAZWISKO
sn: $NAZWISKO

EOF
			else
				echo -e "\t\e[93m(i) $IMIE - Brak IMIENIA i/lub NAZWISKA i/lub MAILA\n\t(i) Pomijam dodanie uzytkownika $IMIE\\033[0m"
			fi


		done

		echo -e "\n\tLiczba uzytkownikow do dodania - $LICZNIK"
                echo -e "\t########################################\n\nPotwierdzasz wprowadzenie zmian? (y-yes n-no)"
                read POTWIERDZENIE
                if [ "$POTWIERDZENIE" = "y" ] || [ "$POTWIERDZENIE" = "yes" ]; then
                        echo -e "\\033[32mWorking...\\033[0m";
                        ldapmodify -a -h $HOST -p $PORT -D cn=admin,dc=otlabs -w $PASS -f adduser.ldif
                elif [ "$POTWIERDZENIE" = "n" ] || [ "$POTWIERDZENIE" = "no" ]; then
                        echo -e "\\033[31mExiting...\\033[0m";
                else echo -e "\\033[31mNiedozwolony znak!\\033[0m";
                fi
