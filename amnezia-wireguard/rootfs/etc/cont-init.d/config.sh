#!/command/with-contenv bashio

declare config
declare interface
declare value

interface="wg0"
config="/etc/amnezia/amneziawg/${interface}.conf"

mkdir -p /etc/amnezia/amneziawg || \
    bashio::exit.nok "Could not create AmneziaWG configuration folder!"

# ---------------------------------------------------------------------------
# Interface
# ---------------------------------------------------------------------------

echo "[Interface]" > "${config}"

echo "Address = $(bashio::config "client.address")" >> "${config}"

for value in $(bashio::config "client.dns"); do
    echo "DNS = ${value}" >> "${config}"
done

echo "PrivateKey = $(bashio::config "client.private_key")" >> "${config}"

# ---------------------------------------------------------------------------
# AmneziaWG parameters
# ---------------------------------------------------------------------------

echo "Jc = $(bashio::config "client.jc")" >> "${config}"
echo "Jmin = $(bashio::config "client.jmin")" >> "${config}"
echo "Jmax = $(bashio::config "client.jmax")" >> "${config}"

echo "S1 = $(bashio::config "client.s1")" >> "${config}"
echo "S2 = $(bashio::config "client.s2")" >> "${config}"
echo "S3 = $(bashio::config "client.s3")" >> "${config}"
echo "S4 = $(bashio::config "client.s4")" >> "${config}"

echo "H1 = $(bashio::config "client.h1")" >> "${config}"
echo "H2 = $(bashio::config "client.h2")" >> "${config}"
echo "H3 = $(bashio::config "client.h3")" >> "${config}"
echo "H4 = $(bashio::config "client.h4")" >> "${config}"

value=$(bashio::config "client.i1")
if [[ -n "${value}" ]]; then
    echo "I1 = ${value}" >> "${config}"
fi

value=$(bashio::config "client.header_protection_key")
if [[ -n "${value}" ]]; then
    echo "HeaderProtectionKey = ${value}" >> "${config}"
fi

value=$(bashio::config "client.rekey_after_time")
if [[ -n "${value}" ]]; then
    echo "RekeyAfterTime = ${value}" >> "${config}"
fi

value=$(bashio::config "client.rekey_timeout")
if [[ -n "${value}" ]]; then
    echo "RekeyTimeout = ${value}" >> "${config}"
fi

value=$(bashio::config "client.reject_after_time")
if [[ -n "${value}" ]]; then
    echo "RejectAfterTime = ${value}" >> "${config}"
fi

value=$(bashio::config "client.keepalive_timeout")
if [[ -n "${value}" ]]; then
    echo "KeepaliveTimeout = ${value}" >> "${config}"
fi

value=$(bashio::config "client.max_handshake_attempts")
if [[ -n "${value}" ]]; then
    echo "MaxHandshakeAttempts = ${value}" >> "${config}"
fi

if [[ "$(bashio::config "client.random_trailers")" == "true" ]]; then
    echo "RandomTrailers = on" >> "${config}"
fi

if [[ "$(bashio::config "client.disable_cookies")" == "true" ]]; then
    echo "DisableCookies = on" >> "${config}"
fi

echo "" >> "${config}"

# ---------------------------------------------------------------------------
# Peer
# ---------------------------------------------------------------------------

echo "[Peer]" >> "${config}"

echo "PublicKey = $(bashio::config "client.peer.public_key")" >> "${config}"

value=$(bashio::config "client.peer.preshared_key")
if [[ -n "${value}" ]]; then
    echo "PresharedKey = ${value}" >> "${config}"
fi

allowed_ips=$(bashio::config "client.peer.allowed_ips | join(\", \")")
echo "AllowedIPs = ${allowed_ips}" >> "${config}"

echo "Endpoint = $(bashio::config "client.peer.endpoint")" >> "${config}"
echo "PersistentKeepalive = $(bashio::config "client.peer.persistent_keepalive")" >> "${config}"

echo "" >> "${config}"

bashio::log.info "AmneziaWG client configuration created:"
echo "--------------------------------------------------"
cat "${config}"
echo "--------------------------------------------------"