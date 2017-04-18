#!/bin/sh

cd /home/marcifur/DNS
#Sprawdzenie czy istnieje plik pomocniczy last_dump
if [ -e "last_dump" ]; then
	:
else
        cat >> last_dump << EOF
temp_file
EOF
fi

#PATH=/usr/bin:/usr/local/bin
DATE=`/bin/date +%Y-%m-%d`
#plik_pomocniczy
TMP_FILE=last_dump
#najnowszy plik
#sprawdzic czy istnieje plik najnowszy, jesli nie to stworzyc
if `/bin/ls | grep otlabs.fr*` 2>/dev/null; then
	NEWEST_FILE=`/bin/ls -t otlabs.fr* | head -1`
	echo plik nie istnieje
else
	NEWEST_FILE=last_dump2
	echo plik istnieje
fi
NEWEST_FILE=`/bin/ls -t otlabs.fr* | head -1`
echo "Najnowszy plik: $NEWEST_FILE"

#otlabs.fr
/usr/local/bin/aws route53 list-resource-record-sets --hosted-zone-id ZF4FOVJ338X4P --profile marcifur > /home/marcifur/DNS/$TMP_FILE

COMPARED_FILES=`cmp last_dump $NEWEST_FILE`

if $COMPARED_FILES 2>/dev/null; then
        echo "File is up to date. Nothing to do"
#        echo Nalezy usunac pliki tymczasowe
	#rm last_dump
	#PLIKI=`ls /home/marcifur/DNS -l | grep last_dump`
	#if [ "$PLIKI" != "" ]; then
	#	rm last_dump
	#fi
	
else
        echo "There are some differents. Adding new file."
        cp $TMP_FILE otlabs.fr-$DATE
fi



#oberthur.net
#aws route53 list-resource-record-sets --hosted-zone-id Z3QPW1RGRLD49C --profile marcifur > /home/marcifur/DNS/oberthur.net-$DATE
#oberthurtest.net
#aws route53 list-resource-record-sets --hosted-zone-id Z321DWEJB0MUH1 --profile marcifur > /home/marcifur/DNS/oberthurtest.net-$DATE
#otlabs.io
#aws route53 list-resource-record-sets --hosted-zone-id Z9ETOGU3CIGLZ --profile marcifur > /home/marcifur/DNS/otlabs.io-$DATE
#smctr.net
#aws route53 list-resource-record-sets --hosted-zone-id ZS5POEVFWBTXD --profile marcifur > /home/marcifur/DNS/smctr.net-$DATE
#moremagic.com
#aws route53 list-resource-record-sets --hosted-zone-id Z3QHRWWVL7QLYL --profile marcifur > /home/marcifur/DNS/moremagic.com-$DATE
