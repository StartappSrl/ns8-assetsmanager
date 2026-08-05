#!/bin/bash

#
# build-images.sh - Asset Manager MSP (modulo NS8)
#
# Semplificato rispetto al template ns8-kickstart: NESSUNA build di
# interfaccia Vue.js - la nostra app Flask ha già la sua interfaccia
# web completa (login, dashboard, tutte le pagine), non serve un
# pannello di gestione NS8 separato sopra.
#
# Questo script costruisce solo il "modulo pacchetto" (script di
# configurazione + systemd) - l'immagine VERA dell'applicazione (con
# tutto il codice Flask) va costruita e pubblicata SEPARATAMENTE con il
# Containerfile del progetto principale, PRIMA di lanciare questo
# script - vedi le istruzioni fornite insieme a questo file.

set -e

images=()
repobase="${REPOBASE:-ghcr.io/nethserver}"
reponame="assetsmanager"

# ATTENZIONE: sostituire questo placeholder con l'immagine VERA della
# vostra app (quella costruita dal Containerfile del progetto
# principale, pubblicata su un registry raggiungibile dal server NS8).
ASSETSMANAGER_REAL_IMAGE="ghcr.io/startappsrl/asset-manager-app:latest"

container=$(buildah from scratch)

# Aggiungo SOLO imageroot - niente cartella ui/, non costruiamo nessuna
# interfaccia separata per questo modulo.
buildah add "${container}" imageroot /imageroot

buildah config --entrypoint=/ \
    --label="org.nethserver.authorizations=traefik@node:routeadm" \
    --label="org.nethserver.tcp-ports-demand=1" \
    --label="org.nethserver.rootfull=0" \
    --label="org.nethserver.images=${ASSETSMANAGER_REAL_IMAGE}" \
    "${container}"

buildah commit "${container}" "${repobase}/${reponame}"
images+=("${repobase}/${reponame}")

if [[ -n "${CI}" ]]; then
    printf "images=%s\n" "${images[*],,}" >> "${GITHUB_OUTPUT}"
else
    printf "Publish the images with:\n\n"
    for image in "${images[@],,}"; do printf "  buildah push %s docker://%s:%s\n" "${image}" "${image}" "${IMAGETAG:-latest}" ; done
    printf "\n"
fi
