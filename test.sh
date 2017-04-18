if [ `cat /proc/version | grep CentOS` 2>/dev/null ]; then
#	if [ `cat /proc/version | grep Ubuntu` 2>/dev/null ]; then
#		:
#	else
#		echo To jest Ubuntu !
#	fi
	echo To nie jest CentOS
else
	echo To jest CentOS !
fi
