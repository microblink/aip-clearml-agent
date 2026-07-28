#!/bin/bash -x

export CLEARML_FILES_HOST=${CLEARML_FILES_HOST:-$TRAINS_FILES_HOST}

if [ -z "$CLEARML_FILES_HOST" ]; then
    CLEARML_HOST_IP=${CLEARML_HOST_IP:-${TRAINS_HOST_IP:-$(curl -s https://ifconfig.me/ip)}}
fi

export CLEARML_FILES_HOST=${CLEARML_FILES_HOST:-${TRAINS_FILES_HOST:-"http://$CLEARML_HOST_IP:8081"}}
export CLEARML_WEB_HOST=${CLEARML_WEB_HOST:-${TRAINS_WEB_HOST:-"http://$CLEARML_HOST_IP:8080"}}
export CLEARML_API_HOST=${CLEARML_API_HOST:-${TRAINS_API_HOST:-"http://$CLEARML_HOST_IP:8008"}}

echo $CLEARML_FILES_HOST $CLEARML_WEB_HOST $CLEARML_API_HOST 1>&2

QUEUE=${K8S_GLUE_QUEUE:-k8s_glue}
MAX_PODS=${K8S_GLUE_MAX_PODS:-2}
EXTRA_ARGS=${K8S_GLUE_EXTRA_ARGS:-}

CLEARML_CONF="${CLEARML_CONFIG_FILE:-$HOME/clearml.conf}"
if [ -f "$CLEARML_CONF" ] && ! [ -w "$CLEARML_CONF" ]; then
    CLEARML_CONF="/tmp/clearml.conf"
    cp "${CLEARML_CONFIG_FILE:-$HOME/clearml.conf}" "$CLEARML_CONF"
    export CLEARML_CONFIG_FILE="$CLEARML_CONF"
fi

# shellcheck disable=SC2129
echo "api.credentials.access_key: ${CLEARML_API_ACCESS_KEY}" >> "$CLEARML_CONF"
echo "api.credentials.secret_key: ${CLEARML_API_SECRET_KEY}" >> "$CLEARML_CONF"
echo "api.api_server: ${CLEARML_API_HOST}" >> "$CLEARML_CONF"
echo "api.web_server: ${CLEARML_WEB_HOST}" >> "$CLEARML_CONF"
echo "api.files_server: ${CLEARML_FILES_HOST}" >> "$CLEARML_CONF"

./provider_entrypoint.sh


if [[ -z "${K8S_GLUE_MAX_PODS}" ]]
then
  python3 k8s_glue_example.py --queue ${QUEUE} ${EXTRA_ARGS}
else
  python3 k8s_glue_example.py --queue ${QUEUE} --max-pods ${MAX_PODS} ${EXTRA_ARGS}
fi
