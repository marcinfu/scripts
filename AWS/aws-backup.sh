#!/bin/bash
#last update 2017-04-21 - extend date; rm tmp file
#last update 2017-04-20
#created by marcifur

DNS_HOME="/aws/DNS"
cd $DNS_HOME

DATE=`/bin/date +%Y-%m-%d:%H:%M:%S`
echo -e "\n"

for DOMENA in `cat /aws/scripts/domeny.txt`;do
	echo "\\033[34m! $DOMENA !\\033[0m"
	#plik_pomocniczy - ostatni dump bazy
	TMP_FILE=1-last_dump-$DOMENA

	#sprawdzic czy istnieje najnowszy plik, jesli nie to stworzyc
	for i in $DOMENA*; do test -f "$i" && echo "exists one or more files" && L=1 && break || echo "no files!" && L=0; done
	#echo $L
	
	if [ $L = 1 ]; then
		NEWEST_FILE=`/bin/ls -t $DOMENA* | head -1`
		echo newest file exist
	elif [ $L = 0 ]; then
		echo temp_file >> $DNS_HOME/tmp_newest_file
		NEWEST_FILE=tmp_newest_file
		echo newest file does not exist
	else
		echo there is some wrong!
		break;
	fi

	echo "The newest file: $NEWEST_FILE"

	#otlabs.fr
	if [ $DOMENA = "otlabs.fr" ];then
		/usr/local/bin/aws route53 list-resource-record-sets --hosted-zone-id XXXXXXXXXXXXX --profile marcifur > $DNS_HOME/$TMP_FILE
	#oberthur.net
	elif [ $DOMENA = "oberthur.net" ];then
		/usr/local/bin/aws route53 list-resource-record-sets --hosted-zone-id XXXXXXXXXXXXX --profile marcifur > $DNS_HOME/$TMP_FILE
	#oberthurtest.net
	elif [ $DOMENA = "oberthurtest.net" ];then
		/usr/local/bin/aws route53 list-resource-record-sets --hosted-zone-id XXXXXXXXXXXXX --profile marcifur > $DNS_HOME/$TMP_FILE
	#otlabs.io
	elif [ $DOMENA = "otlabs.io" ];then
		/usr/local/bin/aws route53 list-resource-record-sets --hosted-zone-id XXXXXXXXXXXXX --profile marcifur > $DNS_HOME/$TMP_FILE
	#smctr.net
	elif [ $DOMENA = "smctr.net" ];then
		/usr/local/bin/aws route53 list-resource-record-sets --hosted-zone-id XXXXXXXXXXXXX --profile marcifur > $DNS_HOME/$TMP_FILE
	#moremagic.com
	elif [ $DOMENA = "moremagic.com" ];then
		/usr/local/bin/aws route53 list-resource-record-sets --hosted-zone-id XXXXXXXXXXXXX --profile marcifur > $DNS_HOME/$TMP_FILE
	else
		echo "Dodano wszystkie domeny!"
	fi

	COMPARED_FILES=`cmp $TMP_FILE $NEWEST_FILE`

	if $COMPARED_FILES 2>/dev/null; then
        	echo "File is up to date. Nothing to do"
	else
        	echo "There are some differents. Adding new file."
	        cp $TMP_FILE $DOMENA-$DATE
	fi
done
#czyszczenie
PLIKI=`ls $DNS_HOME -l | grep tmp_newest_file`
if [ "$PLIKI" != "" ]; then
	rm tmp_newest_file
fi

echo -e "\n\\033[31m$DATE\\033[0m\n"
