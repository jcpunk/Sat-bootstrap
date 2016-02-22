#!/bin/bash -u

source /root/sat-env

TYPES='cr svr ws'
OS_VERS='el6 el7'
MY_NAME_LC=$(echo ${MY_NAME} | tr '[:upper:]' '[:lower:]' | tr '-' '_')

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
            CUSTOMER_NAME=$(echo $2|tr -d '=')
            shift
            shift
           ;;
         -h )
            # get help
            usage
           ;;
    esac
done

if [[ "x${CUSTOMER_NAME}" == 'x' ]]; then
    usage
fi

CUSTOMER_NAME_LC=$(echo ${CUSTOMER_NAME} | tr '[:upper:]' '[:lower:]')
CUSTOMER_NAME_UC=$(echo ${CUSTOMER_NAME} | tr '[:lower:]' '[:upper:]')

hammer product create --name="${CUSTOMER_NAME_UC}" --organization=${MY_ORG}
hammer content-view create --organization=${MY_ORG} --name=cv-puppet-${CUSTOMER_NAME_LC}
hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=cv-puppet-${CUSTOMER_NAME_LC}
for VER in $OS_VERS; do
    hammer content-view create --organization=${MY_ORG} --name=cv-software-${CUSTOMER_NAME_LC}-${VER}
    hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=cv-software-${CUSTOMER_NAME_LC}-${VER}
    hammer repository create --product="${CUSTOMER_NAME_UC}" --name="${CUSTOMER_NAME} ${VER} - x86_64" --content-type='yum'
    hammer content-view add-repository --organization=${MY_ORG} --product="${CUSTOMER_NAME_UC}" --repository="${CUSTOMER_NAME} ${VER} - x86_64" --name=cv-software-${CUSTOMER_NAME_LC}-${VER}
done

TMPFILE=$(mktemp)
for kind in $TYPES; do
    kind_UC=$(echo ${kind} | tr '[:lower:]' '[:upper:]')
    echo > $TMPFILE

    hammer content-view create --organization=${MY_ORG} --composite --name=ccv-service-${CUSTOMER_NAME_LC}-${kind}
    # don't publish async as I need for next steps
    hammer content-view publish --organization=${MY_ORG} --description=Empty --name=ccv-service-${CUSTOMER_NAME_LC}-${kind}

    # Promote this view to all lifecycles for this path
    for lc in $(hammer lifecycle-environment paths --organization=${MY_ORG} | grep Library |grep ${kind_UC}- | tr '>' ' ' | sed -e s'/Library//' ); do
        hammer content-view version promote --organization=${MY_ORG} --content-view=ccv-service-${CUSTOMER_NAME_LC}-${kind} --to-lifecycle-environment=${lc} --version=1.0
    done

    # create hostgroups and attach content views
    kind_UC=$(echo ${kind} | tr '[:lower:]' '[:upper:]')
    top=$(hammer hostgroup list --organization=${MY_ORG}| grep ${MY_NAME}/${kind_UC} |grep -v "${kind_UC}/" | awk '{print $1}')
    hammer hostgroup create --organizations=${MY_ORG} --parent-id=${top} --content-view=ccv-service-${CUSTOMER_NAME_LC}-${kind} --name=${CUSTOMER_NAME_UC}
    containerid=$(hammer hostgroup list --organization=${MY_ORG} | grep ${MY_NAME}/${kind_UC}/${CUSTOMER_NAME_UC} | grep -v "${CUSTOMER_NAME_UC}/" | awk '{print $1}')
    for lc in $(hammer lifecycle-environment list --organization=${MY_ORG} |awk '{print $3}' |grep ${kind_UC}); do
        lc_upper_suffix=$(echo $lc | cut -d'-' -f2 | tr '[:lower:]' '[:upper:]')
        hammer hostgroup create --organizations=${MY_ORG} --parent-id=${containerid} --name=${lc_upper_suffix} --lifecycle-environment=${lc}

        if [[ "${lc_upper_suffix}" == 'PRODUCTION' ]]; then
            hammer activation-key create --organization=${MY_ORG} --unlimited-content-hosts=true --lifecycle-environment=${lc} --content-view=ccv-service-${CUSTOMER_NAME_LC}-${kind} --name=${CUSTOMER_NAME_UC}-${kind_UC}
            hammer activation-key update --organization=${MY_ORG} --name=${CUSTOMER_NAME_UC}-${kind_UC} --auto-attach=false
            hammer hostgroup set-parameter --organization=${MY_ORG} --hostgroup=${containerid}/${lc_upper_suffix} --name=kt_activation_keys --value=${CUSTOMER_NAME_UC}-${kind_UC}
        fi
    done

    # Add repos that make sense that we know automatically
    thisrepo=$(hammer content-view list --organization=${MY_ORG} |grep -v ccv | grep cv-puppet-${kind} | awk '{print $1}')
    echo $thisrepo >> $TMPFILE
    thisrepo=$(hammer content-view list --organization=${MY_ORG} | grep cv-puppet-${CUSTOMER_NAME_LC} | awk '{print $1}')
    echo $thisrepo >> $TMPFILE
    thisrepo=$(hammer content-view list --organization=${MY_ORG} | grep cv-puppet-${MY_NAME_LC} | awk '{print $1}')
    echo $thisrepo >> $TMPFILE
    for repo in $(cat $TMPFILE | grep -e [[:digit:]] | tr '\012' ',' | sed s'/.$//'); do
        hammer content-view add-version --organization=${MY_ORG} --content-view-version=1.0 --content-view-id=${repo} --content-view=ccv-service-${CUSTOMER_NAME_LC}-${kind}
    done

done

rm ${TMPFILE}
