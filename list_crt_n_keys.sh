#! /bin/bash -e

for f in $( echo "$( find . -name '*crt' | grep -v save ; find . -name '*key' | grep -v save )" )
do
    if [[ $# -eq 0 ]]
    then
        echo $f
    else
        eval "$* $f"
    fi
done
