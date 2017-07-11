echo "############################################################XYZ S/N XYZ"
echo ""
dmidecode -q | grep -i serial | sed -n '/Serial Number/ {p;q}'

echo "############################################################XYZ PROC XYZ"
echo ""
cat /proc/cpuinfo | grep -i model | sed -n '/model name/ {p;q}'

echo "############################################################XYZ HDD XYZ"
echo ""
hdparm -i /dev/sda | grep -i model

echo "############################################################XYZ RAM XYZ"
echo ""
dmidecode -t memory | sed -n '/Maximum Capacity/ {p;q}'
dmidecode -t memory | sed -n '/Number Of Devices/ {p;q}'

echo "############################################################XYZ GRAPH XYZ"
echo ""
lspci | grep -i vga | sed -n '/VGA compatible controller/ {p;q}'
lspci | grep -i controller | sed -n '/3D controller/ {p;q}'

echo "############################################################XYZ ETH XYZ"
echo ""
lspci | grep -i eth

#echo "@@@@@@@@@@@@@@@@@@@@@ALL@@@@@@@@@@@@@@@@@@@@@@@@"
#echo ""
#lshw
