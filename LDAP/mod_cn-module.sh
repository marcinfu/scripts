echo -e "\\033[32m\n###########################\n###	mod_cn-module	###\n###########################\n\\033[0m!INFO: Modyfikacja CN - przyklad: JAN JANKOWSKI -> Jan Jankowski\n"

                        echo -e "*** Czyszczenie plikow podrecznych - modrdn-cn.ldif ***"
                        echo "" > modrdn-cn.ldif

                        echo -e "\n\n\t########################################"
                        for (( i=2; i <= $L_WIERSZY+1; i++ )) ; do
                                CN=`awk -v avar="$i" 'NR==avar{print $LICZBA1}' USERS.txt`;

                                TAB=( $CN )
                                IMIE=`echo ${TAB[0]}`
                                NAZWISKO=`echo ${TAB[1]}`
                                MAIL=`echo ${TAB[2]}`

                                #Wszystko malymi literami
                                IMIE_LOW_CASE=`echo "$IMIE" | tr '[:upper:]' '[:lower:]'`
                                NAZWISKO_LOW_CASE=`echo "$NAZWISKO" | tr '[:upper:]' '[:lower:]'`
                                #Imie i nazwisko rozpoczynajac z duzych liter
                                IMIE_LOW_CASE="${IMIE_LOW_CASE[@]^}"
                                NAZWISKO_LOW_CASE="${NAZWISKO_LOW_CASE[@]^}"
# Moze wrzucic EOF do zmiennej?                         xyz="cn=$IMIE $NAZWISKO,ou=sbu,ou=users,dc=otlabs"
				 if [ "$IMIE" != "" ] && [ "$NAZWISKO" != "" ]; then
					echo -e "\tZamiana $IMIE $NAZWISKO na \\033[32m$IMIE_LOW_CASE $NAZWISKO_LOW_CASE\\033[0m"
					LICZNIK=`expr $LICZNIK + 1`
					cat >> modrdn-cn.ldif << EOF
cn=$IMIE $NAZWISKO,ou=sbu,ou=users,dc=otlabs
cn=$IMIE_LOW_CASE $NAZWISKO_LOW_CASE
EOF
				else
					echo -e "\t\e[93m(i) $IMIE - Brak IMIENIA lub NAZWISKA\n\t(i) Pomijam modyfikacje uzytkownika $IMIE\\033[0m"
				fi
                        done

			echo -e "\n\tLiczba uzytkownikow do modyfikacji - $LICZNIK"
                        echo -e "\t########################################\n\nPotwierdzasz wprowadzenie zmian? (y-yes n-no)"
                        read POTWIERDZENIE
                        if [ "$POTWIERDZENIE" = "y" ] || [ "$POTWIERDZENIE" = "yes" ]; then
                                echo -e "\\033[32mWorking...\\033[0m";
                                ldapmodrdn -h $HOST -p $PORT -D cn=admin,dc=otlabs -w $PASS -f modrdn-cn.ldif
                        elif [ "$POTWIERDZENIE" = "n" ] || [ "$POTWIERDZENIE" = "no" ]; then
                                echo -e "\\033[31mExiting...\\033[0m";
                        else echo -e "\\033[31mNiedozwolony znak!\\033[0m";
				exit 0
                        fi

