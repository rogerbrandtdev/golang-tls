#! /bin/bash -e

if [[ $# -eq 0 ]]
then
    hname=$(  hostname -f )
else
    hname=$1
fi

echo "opening hostname $hname"
echo "expect: 0000000: 1503 0100 0202 0a                        ......."
curl -sL https://$hname:443/hello # | xxd
echo "Result is $?"
