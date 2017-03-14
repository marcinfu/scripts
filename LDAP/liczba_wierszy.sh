NUMOFLINES=$(wc -l < "add-module.sh")
echo "add-module.sh - $NUMOFLINES"
TOTAL=$NUMOFLINES
NUMOFLINES=$(wc -l < "dump-module.sh")
echo "dump-module.sh - $NUMOFLINES"
TOTAL=`expr $TOTAL + $NUMOFLINES`
NUMOFLINES=$(wc -l < "mod_cn-module.sh")
echo "mod_cn-module.sh - $NUMOFLINES"
TOTAL=`expr $TOTAL + $NUMOFLINES`
NUMOFLINES=$(wc -l < "search-module.sh")
echo "search-module.sh - $NUMOFLINES"
TOTAL=`expr $TOTAL + $NUMOFLINES`
NUMOFLINES=$(wc -l < "m-LDAP.sh")
echo "m-LDAP.sh - $NUMOFLINES"
TOTAL=`expr $TOTAL + $NUMOFLINES`

echo -e "\nTOTAL = $TOTAL"
