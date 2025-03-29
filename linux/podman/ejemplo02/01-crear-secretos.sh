#!/bin/bash
# vi: ts=8 sw=4 sts=4 et filetype=sh
# Ejecutar este script para guardar las claves en podman

if [ -f .env ] ; then
    source .env
else
    >&2 echo "No se encontro el archivo \".env\""
    exit 1
fi

if [ -n "$POSTGRES_USER" ] ; then
    if podman secret exists postgres-user ; then
        podman secret rm postgres-user
    fi
    printf $POSTGRES_USER | podman secret create postgres-user - 
fi

if [ -n "$POSTGRES_PASSWORD" ] ; then
    if podman secret exists postgres-password ; then
        podman secret rm postgres-password
    fi
    printf $POSTGRES_PASSWORD | podman secret create postgres-password - 
fi

if [ -n "$POSTGRES_DB" ] ; then
    if podman secret exists postgres-db ; then
        podman secret rm postgres-db
    fi
    printf $POSTGRES_DB | podman secret create postgres-db - 
fi
