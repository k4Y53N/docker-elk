#!/bin/bash
set -e
cmd="rabbitmqadmin \
    --host=rabbitmq \
    --port=15672 \
    --vhost=/ \
    --path-prefix="${RABBITMQ_MANAGEMENT_PATH_PREFIX}" \
    --username=${RABBITMQ_USER} \
    --password=${RABBITMQ_PASS} \
    "


$cmd declare user name=${MQTT_RW_USER} password=${MQTT_RW_PASS} tags=mqtt_rw
$cmd declare user name=${MQTT_RO_USER} password=${MQTT_RO_PASS} tags=mqtt_ro
$cmd list users


$cmd declare vhost name="${MQTT_VHOST}" tracing=false
$cmd list vhosts


# MQTT USER READ/WRITE PERMISSIONS
$cmd declare permission \
    vhost="${MQTT_VHOST}" \
    user=${MQTT_RW_USER} \
    configure="mqtt-subscription-*" \
    write="${MQTT_EXCHANGE_REGEX}|mqtt-subscription-*" \
    read="${MQTT_EXCHANGE_REGEX}|mqtt-subscription-*"

# MQTT USER READ ONLY PERMISSIONS
$cmd declare permission \
    vhost="${MQTT_VHOST}" \
    user=${MQTT_RO_USER} \
    configure="mqtt-subscription-*" \
    write="mqtt-subscription-*" \
    read="${MQTT_EXCHANGE_REGEX}|mqtt-subscription-*"

$cmd list permissions

$cmd show overview
