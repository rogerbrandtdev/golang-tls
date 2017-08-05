#! /bin/bash -e

function help() {
    echo
    echo "usage: $( basename $0 ) ( --rsa | --ec ) [ <prefix> ]"
    echo "where options are"
    echo "    --rsa RSA Key"
    echo "    --ec  Elliptic Curve Key"
    echo "and parameters are"
    echo "    <prefix>  is an optional string to use as a prefix to filenames"
    echo "note: if a <prefix> is a directory path, the trailing / must be included"
    echo
    exit 1
}

# options
KEY_TYPE="RSA"
PREFIX=""

case ${#} in
0)
    help
    ;;
1|2)
    if [[ "$1" == "--help" || "$1" == "-help" || "$1" == "help" || "$1" == "-h" ]]
    then
        help
    elif [[ "$1" =~ ^[-][-]rsa ]]
    then
        KEY_TYPE="RSA"
        shift 1
    elif [[ "$1" =~ ^[-][-]ec ]]
    then
        KEY_TYPE="EC"
        shift 1
    elif [[ $# -eq 1 ]]
    then
        PREFIX=$1
        shift 1
    else
        echo "ERROR: Bad parameter: $1"
        exit 2
    fi

    if [[ $# -eq 1 ]]
    then
        PREFIX=$1
        shift 1
    fi
    ;;
*)  
    echo "ERROR: Too many parameters \($BASH_ARGC\): ${BASH_ARGV[*]}"
    exit 3
    ;;
esac

echo
echo "generating key and certificate of $KEY_TYPE type"
echo

function echo_exec() {
    local -a args=( $* )
    shift $#

    echo "${args[*]}"
    eval "${args[*]}"
    echo
}

if [[ $KEY_TYPE == "RSA" ]]
then
    # Key considerations for algorithm "RSA" ≥ 2048-bit
    echo_exec openssl genrsa -out "${PREFIX}server.key" 2048
    echo_exec chmod go-r "${PREFIX}server.key"

    echo_exec openssl req -new -x509 -sha256 -key "${PREFIX}server.key" -out "${PREFIX}server.crt" -days 3650
else
    # Key considerations for algorithm "ECDSA" ≥ secp384r1
    # List ECDSA the supported curves (openssl ecparam -list_curves)
    echo_exec openssl ecparam -genkey -name secp384r1 -out server.key
    echo_exec chmod go-r "${PREFIX}server.key"

    echo_exec openssl req -new -x509 -sha256 -key "${PREFIX}server.key" -out "${PREFIX}server.crt" -days 3650
fi
