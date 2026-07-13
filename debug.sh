#!/bin/bash
set -e

HOSTS_LINE="127.0.0.1 xicu.net"

cleanup() {
    echo ""
    echo "Removing xicu.net from /etc/hosts..."
    sudo sed -i '/127\.0\.0\.1 xicu\.net/d' /etc/hosts
    echo "Done."
}

if grep -q "127.0.0.1 xicu.net" /etc/hosts; then
    echo "xicu.net already in /etc/hosts, skipping."
else
    echo "Adding xicu.net to /etc/hosts..."
    echo "$HOSTS_LINE" | sudo tee -a /etc/hosts > /dev/null
fi

trap cleanup EXIT

echo "Starting Hugo with production Adobe key (authorized for xicu.net)..."
hugo server --port 1313 --baseURL http://xicu.net --disableFastRender
