#!/bin/bash - 
#===============================================================================
#
#          FILE: company.sh
# 
#         USAGE: ./company.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Dusty Carver (), 
#  ORGANIZATION: Micfo 
#       CREATED: 03/08/2017 15:40
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
#Grabs Company Name

file=$1
epoch=$(printf $1 | sed 's/[a-zA-Z\\\/]\+\([0-9]\+\).txt$/\1/')
echo $epoch
COMPANY=$(whois $(cat $file | head -n1 | awk -F' ' '{print $1}') |egrep -oi 'yourcompany.tld' | head -n1)
REVIP=$(grep -o '^[0-9]\+\.[0-9]\+\.[0-9]\+' $file| head -n1 | awk -F. '{print $3"."$2"."$1}')
IP=$(grep -o '^[0-9]\+\.[0-9]\+\.[0-9]\+' $file| head -n1 )
RANGELOW=$(grep -o '^[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' $file| head -n1 | awk -F. '{print $4}')
RANGEHIG=$(grep -o '^[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' $file| tail -n1 | awk -F. '{print $4}')
#If we don't recognize the company
IFS=$(echo -en "\n")
if [ -z ${COMPANY} ]; 
then echo "This is Garbage" && exit 1;
else echo "This appears to be '$COMPANY'";
#lower case company
space=$(echo -n $COMPANY | tr A-Z a-z) &&
CCONF='0'
#function 
case $space in
oppob*)
read -r -d "" HEADER <<EOF
\$TTL 14400
$REVIP.in-addr.arpa.       IN      SOA      dns3.yourcompany.tld.        support.yourcompany.com.    (
                                                $(date +%Y%m%d)01 ;Serial Number
                                                86400 ;refresh
                                                7200 ;retry
                                                36000 ;expire
                                                3600 ;minimum
        )
        IN      NS      dns3.yourcompany.tld.
        IN      NS      dns4.yourcompany.tld.

EOF

DNS="dns3.yourcompany.tld"
  ;;
other*)

read -r -d "" HEADER <<EOF
\$TTL 14400
$REVIP.in-addr.arpa.  14400   IN      SOA     NS3.CLOUD-SERV.yourcompany.tld.COM.     support.yourcompany.tld.    (
               $(date +%Y%m%d)01 ;Serial Number
                86400 ;refresh
                7200 ;retry
                36000 ;expire
                3600 ;minimum
                )
14400   IN      NS      NS3.CLOUD-SERV.yourcompany.tld.COM.
14400   IN      NS      NS4.CLOUD-SERV.yourcompany.tld.COM.

EOF

DNS="ns3:loud-serv.yourcompany.tld"

  Message="Start thinking about cleaning out some stuff.  There's a partition that is $space % full."
  ;;
otherone*)
read -r -d "" HEADER <<EOF
\$TTL 14400
$REVIP.in-addr.arpa.       IN      SOA      rns1.yourcompany.tld.        noc-support.yourcompany.tld.    (
                                                $(date +%Y%m%d)01 ;Serial Number
                                                86400 ;refresh
                                                7200 ;retry
                                                36000 ;expire
                                                3600 ;minimum
        )
        IN      NS      rns1.yourcompany.tld.
        IN      NS      rns2.yourcompany.tld.
EOF

DNS="rns1.yourcompany.tld"
;;

roy*)

read -r -d "" HEADER <<EOF
\$TTL 14400
$REVIP.in-addr.arpa.       IN      SOA     ns1.rsname.tld.        support.micfo.com.    (
                                                $(date +%Y%m%d)01 ;Serial Number
                                                86400 ;refresh
                                                7200 ;retry
                                                36000 ;expire
                                                3600 ;minimum
        )
        IN      NS      ns1.rsname.tld.
        IN      NS      ns2.rsname.tld.

EOF
DNS="RDNS1.HOSTAWARE.COM"

#\$TTL 14400
#$REVIP.in-addr.arpa.  14400   IN      SOA     NS3.CLOUD-SERV.yourcompany.tld.COM.     support.yourcompany.tld.    (
#               $(date +%Y%m%d)01 ;Serial Number
#                86400 ;refresh
#                7200 ;retry
#                36000 ;expire
#                3600 ;minimum
#                )
#14400   IN      NS      NS3.CLOUD-SERV.yourcompany.tld.COM.
#14400   IN      NS      NS4.CLOUD-SERV.yourcompany.tld.COM.
#
#EOF
#
#  Me
#
#  Message="Better hurry with that new disk...  One partition is $space % full."
  ;;
asdf)
  Message="I'm drowning here!  There's a partition at $space %!"
  ;;
no*)
  Message="I seem to be running with an nonexistent amount of disk space..."
  ;;
ari*)
read -r -d "" HEADER <<EOF
\$TTL 14400
$REVIP.in-addr.arpa.       IN      SOA      dns3.yourcompany.tld.        support.yourcompany.tld.    (
                                                $(date +%Y%m%d)01 ;Serial Number
                                                86400 ;refresh
                                                7200 ;retry
                                                36000 ;expire
                                                3600 ;minimum
        )
        IN      NS      dns3.yourcompany.tld.
        IN      NS      dns4.yourcompany.tld.

EOF


DNS="127.0.0.1"
  ;;

esac
#echo $HEADER
#echo "scp -r $DNS:/var/named/$IP.0.rev.db backup/$IP.$epoch"
scp -o 'StrictHostKeyChecking no' -i ../.ssh/id_rsa -r root@$DNS:/var/named/$IP.0.rev.db backup/$IP.$epoch
TIRE="backup/$IP.$epoch"
if [ -e "$TIRE" ]
then
	for i in $(cat backup/$IP.$epoch);
	do
	    grep '^[0-9]\+' <(echo "$i")
	done
    CCONF="NEW"
fi

SEDDER=$(cat $file | tr -d '' | sed 's/^[0-9]\+\.[0-9]\+\.[0-9]\+\.\([0-9]\+\)\(.*\)/\1 IN PTR\2./' )
HEADER="$HEADER$SEDDER"


echo $HEADER > new/$IP.0.rev.db
#$scp=`scp -o 'StrictHostKeyChecking no' -i ../.ssh/id_rsa -r <(echo $HEADER) root@$DNS:/var/named/$IP.0.rev.db`
#$ssh=`ssh -o 'StrictHostKeyChecking no' -i ../.ssh/id_rsa 'rdnc reload'`
#diff <(tail -n$(echo $(cat backup/$IP.$epoch | wc -l) - 10 | bc) backup/$IP.$epoch | grep -P '^\d') <($SEDDER)
echo   "<input type="hidden" name="ip" value='$IP'>"
echo   "<input type="hidden" name="dns" value='$DNS'>"
echo   "<input type="hidden" name="low" value='$RANGELOW'>"
echo   "<input type="hidden" name="high" value='$RANGEHIG'>"
echo   "<input type="hidden" name="cconf" value='$CCONF'>"
fi
