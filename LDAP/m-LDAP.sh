#!/bin/bash

#Zawartosc pliku USERS.txt powinna wygladac nastepujaco:
#	#IMIE | NAZWISKO | MAIL
#	Jan Jankowski j.jankowski@oberthur.com
#gdzie Jan Jankowski j.jankowski@oberthur.com - to przykładowy użytkownik.
#Można dodawć kolejnych użytkowników według schematu, każdy w osobnym wierszu.

EXT_PASS="no"
source server.conf;

#Sprawdzenie poprawnosci pliku server.conf
if [ $EXT_PASS = "yes" ]; then
		:
        elif [ $EXT_PASS = "no" ]; then
		:
	else
		echo "ERROR - no valid EXT_PASS=$EXT_PASS in server.conf!"
		exit 0;
fi


#Sprawdzenie czy istnieje plik USERS.txt
if [ -e "USERS.txt" ]; then
        echo -e "USERS.txt istnieje\nProceed.."
else
        echo "USERS.txt nie istnieje!"
	echo "Czy chcesz utworzyc plik USERS.txt? (y-yes n-no)"
        read KEY
        if [ "$KEY" = "y" ] || [ "$KEY" = "yes" ]; then
	cat >> USERS.txt << EOF
#IMIE | NAZWISKO | MAIL
Jan Jankowski j.jankowski@oberthur.com
EOF
        elif [ "$KEY" = "n" ] || [ "$KEY" = "no" ]; then
                echo -e "Brak pliku USERS.txt!\nexiting..."
                exit 0
        else
                echo -e "Zle dane wejsciowe!\nexiting..."
                exit 0
        fi
fi

L_POM=(`wc -l USERS.txt`)
L_WIERSZY=`expr $L_POM - 1`
LICZNIK=0

##Sprawdzenie czy istnieje pakiet ldap-utils

#Zapisanie wyniku polecenia dpkg -l | grep ldap-utils do zmiennej
POL_DPKG=`dpkg -l | grep ldap-utils`
#Zapisanie wyniku polecenia dpkg -l | grep ldap-utils do pliku tymczasowego tmpi
echo $POL_DPKG > tmpi
#Wyciagniecie drugiego slowa z pliku tmpi, ktore zawiera nazwe pakietu
NAZWA_PAKIETU=`awk '{ print $2 }' tmpi`
#Sprawdzenie czy nazwa pakietu istnieje
if [ -z $NAZWA_PAKIETU ]; then
	echo "Nie odnaleziono pakietu ldap-utils"
        echo "Czy chcesz zainstalowac pakiet ldap-utils? (y-yes n-no)"
        read KEY
        if [ "$KEY" = "y" ] || [ "$KEY" = "yes" ]; then
                sudo apt-get install ldap-utils
	elif [ "$KEY" = "n" ] || [ "$KEY" = "no" ]; then
                echo -e "Bez pakietu ldap-utils program nie bedzie poprawnie funkcjonowal!\nexiting..."
                exit 0
        else
                echo -e "Zle dane wejsciowe!\nexiting..."
                exit 0
        fi
fi
#Usuniecie pliku tymczasowego tmpi
rm tmpi

echo -e "\n\nLista osob z pliku:\n"
tac USERS.txt | tac
echo -e "Razem $L_WIERSZY\n"

#Komentarz wielolinijkowy
##<<KOMENTARZ
##tekst
##KOMENTARZ

if [ "$EXT_PASS" = "no" ]; then

#Reczne podawanie hasla. Haslo jest rowniez w pliku server.conf
echo -e "Podaj haslo do bazy $HOST:$PORT"
read -s PASS

TEST_CONNECTION=`ldapsearch -D cn=admin,dc=otlabs -z 1000 -h $HOST -p $PORT -w $PASS -b "ou=sbu,ou=users,dc=otlabs"`

#Sprawdzenie poprawnosci hasla
while [ "$TEST_CONNECTION" = "" ]; do
	echo "Czy chcesz podac haslo raz jeszcze? (y-yes n-no)"
	read KEY
	if [ "$KEY" = "y" ] || [ "$KEY" = "yes" ]; then
		echo -e "Podaj haslo do bazy $HOST:$PORT"
		read -s PASS
		TEST_CONNECTION=`ldapsearch -D cn=admin,dc=otlabs -z 1000 -h $HOST -p $PORT -w $PASS -b "ou=sbu,ou=users,dc=otlabs"`
	elif [ "$KEY" = "n" ] || [ "$KEY" = "no" ]; then
		echo "Exiting..."
		exit 0
        else
                echo -e "Zle dane wejsciowe!\nexiting..."
                exit 0
        fi
done

fi

echo -e "\nToDO\n\x1b[7m- sprawdzanie czy zainstalowane ldap-utilsy, a jak nie to pytanie czy instalowac: sudo apt-get install ldap-utils - OK\n- szukanie zarowno po malych jak i wielkich literach! - OK\n- sprawdzenie czy istnieje plik USERS.txt - OK\x1b[m\n- szukalem Jan Jankowski, a znalazl cn=Jan JankowskiTEST - trzeba poprawic\n- dodac modyfikacje maila i uuid na male litery\n- dodac petle z menu zamiast zakonczenia dzialania programu po zle wprowadzonym znaku\n- ldap_add: Already exists (68) -> po tym nie dodaje kolejnych\n- szukanie po NAZWISKU. Obecnie po wpisaniu jednego slowa jest ono traktowane jako IMIE\n- dodac mozliwosc wprowadzania dwoch imion. Obecnie kolejne slowa to IMIE, NAZWISKO i MAIL\n- dodac do search-module mozliwosc wyswietlenia calej struktury w postaci drzewa\n\x1b[7m- pytanie o haslo do bazy i wyswietlenie adresu ip i portu do zweryfikowania prez uzytkownika + test polaczenia, jesli niepoprawne zapytaj czy chce podac haslo jeszcze raz czy zakonczyc dzialanie programu - OK\n\x1b[7m- przy dumpie nadpisuje plik. Nalezy dodac sprawdzanie czy dany plik istnieje i czy go zastapic - OK\x1b[m\n- weryfikacja poprawnosci pliku server.conf. Sprawdzic m.in. EXT_PASS i PASS\n- na poczatku zapytanie czy dane zaczytac z pliku USERS.txt czy beda wprowadzane recznie"
cat << "EOF"
	||||  |||| |||||| ||||  ||| ||| |||
	||| || ||| |||    ||| | ||| ||| |||
	|||    ||| |||||  |||  |||| ||| |||
	|||    ||| |||    |||   ||| ||| |||
	|||    ||| |||||| |||   ||| |||||||
EOF

echo -e "\n\t###################\n\t\\033[36m1 - search-module\n\t2 - add-module\n\t3 - mod_cn-module\n\t4 - dump\n\t5 - add_user_to_group\n\t6 - remove_user_from_group\n\t0 - exit\\033[0m\n\t###################\n"
read WYBOR
#Sprawdzenie czy wybrano jedna z opcji
if [ -z "$WYBOR" ]; then

        echo "No options !"
        echo -e "\\033[31mExiting...\\033[0m";
        exit 0

elif [ $WYBOR -eq $WYBOR 2> /dev/null ]; then

	if [ $WYBOR = 1 ]; then

		source search-module.sh;

	elif [ $WYBOR = 2 ]; then

		source add-module.sh;

	elif [ $WYBOR = 3 ]; then

		source mod_cn-module.sh;

	elif [ $WYBOR = 4 ]; then

		source dump-module.sh;

	elif [ $WYBOR = 5 ]; then

		source add-user-to-group-module.sh;

	elif [ $WYBOR = 6 ]; then
	
		source remove-user-from-group-module.sh;

	elif [ $WYBOR = 0 ]; then
		echo "Bye!"
		exit 0

	else

		echo $WYBOR - brak opcji w Menu
		exit 0

	fi

else

	echo -e "\\033[31mNiedozwolony znak!\\033[0m";
	echo -e "\\033[31mExiting...\\033[0m";
	exit 0

fi

#Sprawdzenie czy istnieja i usuwanie wszystkich plikow tymczasowych *.ldif
PLIKI=`ls -l | grep *.ldif`

if [ "$PLIKI" != "" ]; then

	rm *.ldif
fi

exit 0
