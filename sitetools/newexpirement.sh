#!/bin/bash -u

source /root/sat-env

TYPES='cr svr ws'
SOURCES='puppet software'

# setup args in the right order for making getopt evaluation
# nice and easy.  You'll need to read the manpages for more info
args=$(getopt -o hn: -- "$@")
eval set -- "$args"

usage() {
    echo ''           >&2
    echo "$0"         >&2
    echo ''           >&2
    echo ' -n to set name'           >&2
    echo ''          >&2
    exit 1
}

for arg in $@; do
    case $1 in
        -- )
            # end of getopt args, shift off the -- and get out of the loop
            shift
            break 2
           ;;
         -n )
            # get the name
            NAME=$(echo $2|tr -d '=')
            shift
            shift
           ;;
         -h )
            # get help
            usage
           ;;
    esac
done

if [[ "x${NAME}" == 'x' ]]; then
    usage
fi

NAME_LC=$(echo ${NAME} | tr '[:upper:]' '[:lower:]')
NAME_UC=$(echo ${NAME} | tr '[:lower:]' '[:upper:]')

for software in $SOURCES; do
    hammer content-view create --organization=${MY_ORG} --name=cv-${software}-${NAME_LC}
    hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=cv-${software}-${NAME_LC}
done

TMPFILE=$(mktemp)
for kind in $TYPES; do
    echo > $TMPFILE
    hammer content-view create --organization=${MY_ORG} --composite --name=ccv-service-${NAME_LC}-${kind}
    hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=ccv-service-${NAME_LC}-${kind}
    for software in $SOURCES; do
        thisrepo=$(hammer content-view list --organization=${MY_ORG} |grep -v ccv | grep ${software}-${kind} | awk '{print $1}')
        echo $thisrepo >> $TMPFILE
        thisrepo=$(hammer content-view list --organization=${MY_ORG} | grep cv-${software}-${NAME_LC} | awk '{print $1}')
        echo $thisrepo >> $TMPFILE
    done
    repos=$(cat $TMPFILE | tr '\012' ',')
    hammer content-view update  --organization=${MY_ORG} --name=ccv-service-${NAME_LC}-${kind} --component-ids=${repos}
done
rm ${TMPFILE}


for kind in $TYPES; do
    kind_UC=$(echo ${kind} | tr '[:lower:]' '[:upper:]')
    top=$(hammer hostgroup list --organization=${MY_ORG}| grep ${MY_NAME}/${kind_UC} |grep -v "${kind_UC}/" | awk '{print $1}')
    hammer hostgroup create --organization=${MY_ORG} --parent-id=${top} --content-view=ccv-service-${NAME_LC}-${kind} --name=${NAME_UC}
    containerid=$(hammer hostgroup list --organization=${MY_ORG}| grep ${MY_NAME}/${kind_UC}/${NAME_UC} |grep -v "${NAME_UC}/" | awk '{print $1}')
    for lc in $(hammer lifecycle-environment list --organization=${MY_ORG} |awk '{print $3}' |grep ${NAME_UC}); do
        lc_upper_suffix=$(echo $lc | cut -d'-' -f2 | tr '[:lower:]' '[:upper:]')
        hammer hostgroup create --organization=${MY_ORG} --parent-id=${containerid} --name=${lc_upper_suffix} --lifecycle-environment=${lc}
    done
done
