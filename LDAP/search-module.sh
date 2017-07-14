#ldapsearch-module

echo -e "\\033[32m\n###########################\n###	search-module	###\n###########################\n\\033[0m"

echo -e "*** Czyszczenie plikow podrecznych - ldap-users.txt ***"
echo "" > ldap-users.txt

echo -e "\nJesli pojawil sie szukany uzytkownik, to oznacza ze istnieje juz w bazie\n"
	for (( i=2; i <= $L_WIERSZY+1; i++ )) ; do
		CN=`awk -v avar="$i" 'NR==avar{print $LICZBA1}' USERS.txt`;

		TAB=( $CN )
		IMIE=`echo ${TAB[0]}`
		NAZWISKO=`echo ${TAB[1]}`
		MAIL=`echo ${TAB[2]}`

		if [ "$IMIE" != "" ] && [ "$NAZWISKO" != "" ]; then
			#Jesli $IMIE i $NAZWISKO zawiera jakies wartosci - szukaj po imieniu i nazwisku
			ldapsearch -D cn=admin,dc=otlabs -z 1000 -h $HOST -p $PORT -w $PASS -b "ou=sbu,ou=users,dc=otlabs" | grep dn: | grep -i $IMIE | grep -i $NAZWISKO >> ldap-users.txt
		else
			#Nie odnaleziono IMIENIA i/lub NAZWISKA
			if [ -z $IMIE ]; then
				echo -e "\e[93m(i) Nie podano IMIENIA w pliku USERS.txt dla użytkownika o NAZWISKU - $NAZWISKO\\033[0m"
			else
				#ldapsearch -D cn=admin,dc=otlabs -z 1000 -h $HOST -p $PORT -w $PASS -b "ou=sbu,ou=users,dc=otlabs" | grep dn: | grep -i $IMIE  >> ldap-users.txt
				ldapsearch -D cn=admin,dc=otlabs -z 1000 -h $HOST -p $PORT -w $PASS -b "ou=users,dc=otlabs" | grep dn: | grep -i $IMIE  >> ldap-users.txt
			fi
			if [ -z $NAZWISKO ]; then
				echo -e "\e[93m(i) Nie podano NAZWISKA w pliku USERS.txt dla użytkownika o IMIENIU - $IMIE\n(i) Wyszukuje wszystkich o IMIENIU $IMIE\\033[0m"
			else
				#ldapsearch -D cn=admin,dc=otlabs -z 1000 -h $HOST -p $PORT -w $PASS -b "ou=sbu,ou=users,dc=otlabs" | grep dn: | grep -i $NAZWISKO >> ldap-users.txt
				ldapsearch -D cn=admin,dc=otlabs -z 1000 -h $HOST -p $PORT -w $PASS -b "ou=users,dc=otlabs" | grep dn: | grep -i $NAZWISKO >> ldap-users.txt
			fi
		fi

	done

echo -e "\\033[31m`cat ldap-users.txt`\\033[0m";
rm ldap-users.txt
