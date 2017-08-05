#! /bin/bash -e

###   ```sh
###   # RSA recommendation key ≥ 2048-bit
###   openssl req -x509 -nodes -newkey ec:secp384r1 -keyout server.ecdsa.key -out server.ecdsa.crt -days 3650
###   # openssl req -x509 -nodes -newkey ec:<(openssl ecparam -name secp384r1) -keyout server.ecdsa.key -out server.ecdsa.crt -days 3650
###   # -pkeyopt ec_paramgen_curve:… / ec:<(openssl ecparam -name …) / -newkey ec:…
###   ln -sf server.ecdsa.key server.key
###   ln -sf server.ecdsa.crt server.crt
###   
###   # ECDSA recommendation key ≥ secp384r1
###   # List ECDSA the supported curves (openssl ecparam -list_curves)
###   openssl req -x509 -nodes -newkey rsa:2048 -keyout server.rsa.key -out server.rsa.crt -days 3650
###   ln -sf server.rsa.key server.key
###   ln -sf server.rsa.crt server.crt
###   ```
###   
###   * `.crt` — Alternate synonymous most common among *nix systems `.pem` (pubkey).
###   * `.csr` — Certficate Signing Requests (synonymous most common among *nix systems).
###   * `.cer` — Microsoft alternate form of `.crt`, you can use MS to convert `.crt` to `.cer` (`DER` encoded `.cer`, or `base64[PEM]` encoded `.cer`).
###   * `.pem` = The PEM extension is used for different types of X.509v3 files which contain ASCII (Base64) armored data prefixed with a «—– BEGIN …» line. These files may also bear the `cer` or the `crt` extension.
###   * `.der` — The DER extension is used for binary DER encoded certificates.
###   
###   #### Generating the Certficate Signing Request
###   
###       openssl req -new -sha256 -key server.key -out server.csr
###       openssl x509 -req -sha256 -in server.csr -signkey server.key -out server.crt -days 3650

KEY_TYPE="RSA"
FRESHEN_KEY=false

case ${#} in
0)
    ;;
1)
    if [[ "$1" == "--help" || "$1" == "-help" || "$1" == "help" || "$1" == "-h" ]]
    then
        echo
        echo "usage: $( basename $0 ) [ --rsa | --ec ]]"
        echo "note : --rsa is the default key type"
        echo
        exit 1
    elif [[ "$1" =~ ^[-][-]rsa ]]
    then
        KEY_TYPE="RSA"
    elif [[ "$1" =~ ^[-][-]ec ]]
    then
        KEY_TYPE="EC"
    else
        echo "ERROR: Bad parameter: $1"
        exit 2
    fi
    ;;
*)  
    echo "ERROR: Too many parameters \($BASH_ARGC\): ${BASH_ARGV[*]}"
    exit 3
    ;;
esac

echo "generating CSR of $KEY_TYPE type"
echo

function echo_exec() {
    local -a args=( $* )
    shift $#

    echo
    echo "${args[*]}"
    eval "${args[*]}"
    echo
}

declare -a ectypes=( $( echo "secp256r1 secp521r1 secp384r1" ) )
if [[ $KEY_TYPE == "RSA" ]]
then
    echo_exec openssl req -x509 -nodes -newkey rsa:2048 -keyout server.rsa.key -out server.rsa.crt -days 3650
else
    echo_exec openssl req -x509 -nodes -newkey ec:${ectypes[2]} -keyout server.ecdsa.key -out server.ecdsa.crt -days 3650
fi

