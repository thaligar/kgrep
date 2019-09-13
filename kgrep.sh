#!/bin/bash

if [ $# -lt 2 ]; then
  echo "Usage: ${0} KIND [-n NAMESPACE] -- GREP-PARAMS"
	exit 1
fi

KIND="${1}"
shift

FLAG="${1}"
shift

if [ ${FLAG} == "--" ]; then
	NAMESPACE="--all-namespaces"
else
  NAMESPACE="-n ${1}"
	NS="${1}"
	shift
  shift
fi

GREPPARAMS="$@"
ITEMS=$(kubectl get ${KIND} ${NAMESPACE} | tail -n +2)

POD_COLOR='\033[0;32m'
NC='\033[0m'

if [ ${FLAG} == "--" ]; then

	while read -r ITEM; do
    echo "${ITEM}" | awk '{print "'"${POD_COLOR}"'" $1 ": " $2 "'"${NC}"'"}'
		echo "${ITEM}" | awk '{ system("kubectl get '"${KIND}"' -n " $1 " " $2 " -o	yaml")}' | grep --color=always ${GREPPARAMS}
	done <<< "${ITEMS}"

else

	while read -r ITEM; do
    echo "${ITEM}" | awk '{print "'"${POD_COLOR}${NS}"': " $1 "'"${NC}"'"}'
		echo "${ITEM}" | awk '{ system("kubectl get '"${KIND}"' '"${NAMESPACE}"' " $1 " -o yaml")}' | grep --color=always ${GREPPARAMS}
	done <<< "${ITEMS}"

fi

