#!/usr/bin/env bash

# Copyright (c) 2017 Kazuki Suda <kazuki.suda@gmail.com>
#
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

MINIKUBE_INGRESS_DNS_DOMAIN=${MINIKUBE_INGRESS_DNS_DOMAIN:-minikube.dev}

minikube_ingress_dns() {
  if [[ -z "$dnsmasq_config_file" ]]; then
    echoerr "dnsmasq_config_file variable is not defined."
    exit 1
  fi

  if ! declare -f write_to_dnsmasq_config_file >/dev/null 2>&1; then
    echoerr "write_to_dnsmasq_config_file function is not defined."
    exit 1
  fi

  if ! declare -f restart_dnsmasq >/dev/null 2>&1; then
    echoerr "restart_dnsmasq function is not defined."
    exit 1
  fi

  local ip="$(minikube ip)"
  [[ -z "$ip" ]] && return

  echoinfo "The IP address of running a cluster: ${ip}"

  local dnsmasq_config="$(cat <<EOL
bind-interfaces
listen-address=127.0.0.1
address=/${MINIKUBE_INGRESS_DNS_DOMAIN}/${ip}
EOL
)"

  if [[ "$dnsmasq_config" != "$(cat $dnsmasq_config_file 2>/dev/null)" ]]; then
    echoinfo "Configure dnsmasq for ${MINIKUBE_INGRESS_DNS_DOMAIN}..."
    echo "$dnsmasq_config" | write_to_dnsmasq_config_file

    echoinfo "Restart dnsmasq..."
    exe restart_dnsmasq
  fi

  exe dig +noall +answer "${MINIKUBE_INGRESS_DNS_DOMAIN}" @127.0.0.1
}

exe() {
  (set -x; $@)
}

echoinfo() {
  echo -n "[minikube-ingress-dns] INFO: "
  echo $@
}

echoerr() {
  echo -n "[minikube-ingress-dns] ERROR: " >&2
  echo $@ >&2
}
# vim: ft=sh ts=2 sts=2 sw=2
