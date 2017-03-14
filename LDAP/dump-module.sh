#dump-module

echo -e "\\033[32m\n########################\n###    dump-module   ###\n########################\n\\033[0m"

echo -e "Wszystkie rekordy z bazy beda zapisane w postaci:\n"
        cat << "EOF"
# William Wu, R&D, otlabs
dn: cn=William Wu,ou=R&D,dc=otlabs
mail: w.wu@external.oberthur.com
cn: William Wu
sn: Wu
EOF
echo -e "\nPodaj nazwe pliku do zapisu dump-a z bazy"
read NAZWA_PLIKU
#ldapsearch -D cn=admin,dc=otlabs -z 1000 -h $HOST -p $PORT -w $PASS -b "ou=sbu,ou=users,dc=otlabs" "dn" "mail" "cn" "sn" > $NAZWA_PLIKU
ldapsearch -D cn=admin,dc=otlabs -z 1000 -h $HOST -p $PORT -w $PASS -b "ou=sbu,ou=users,dc=otlabs" > $NAZWA_PLIKU
echo -e "\nDump bazy LDAP zapisany do pliku o nazwie: $NAZWA_PLIKU"
