echo -e "\\033[32m\n###########################\n###	remove user from group module	###\n###########################\n\\033[0m"
TMP_FILE=remove_user_from_group.ldif
echo -e "*** Czyszczenie plikow podrecznych - $TMP_FILE ***"
echo "" > $TMP_FILE
echo $TMP_FILE

echo -e "\n\n\t########################################"

for (( i=2; i <= $L_WIERSZY+1; i++ )) ; do
	CN=`awk -v avar="$i" 'NR==avar{print $LICZBA1}' USERS.txt`;

	TAB=( $CN )
	IMIE=`echo ${TAB[0]}`
	NAZWISKO=`echo ${TAB[1]}`
	#Wszystko malymi literami
	IMIE=`echo "$IMIE" | tr '[:upper:]' '[:lower:]'`
	NAZWISKO=`echo "$NAZWISKO" | tr '[:upper:]' '[:lower:]'`
	#Imie i nazwisko rozpoczynajac z duzych liter
	IMIE="${IMIE[@]^}"
	NAZWISKO="${NAZWISKO[@]^}"

	cat >> $TMP_FILE << EOF
dn: cn=jira-users,ou=services,ou=groups,dc=otlabs
changetype: modify
delete: uniqueMember
uniqueMember: cn=$IMIE $NAZWISKO,ou=SBU,ou=Users,dc=otlabs
EOF

done

#ldapmodify -h 10.122.202.15 -p 389 -D cn=admin,dc=otlabs -w dupa.123 -f group.ldif
ldapmodify -h $HOST -p $PORT -D cn=admin,dc=otlabs -w $PASS -f $TMP_FILE
