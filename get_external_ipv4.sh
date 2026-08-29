IP_CHECK_SERVICES_URL=(
    "https://api4.ipify.org"
    "https://ipv4.icanhazip.com"
    "https://v4.api.ipinfo.io/ip"
    "https://ipv4.myexternalip.com/raw"
    "https://4.ident.me"
    "https://check-host.net/ip"
    "http://ifconfig.me"
    "https://checkip.amazonaws.com"
)

echo "🌎 Getting external IPv4"
for ip_address in "${IP_CHECK_SERVICES_URL[@]}"; do
    EXTERNAL_IPv4=$(curl -s --max-time 3 "${ip_address}" 2>/dev/null | tr -d '[:space:]')
    if [[ -n "${EXTERNAL_IPv4}" ]]; then
        break
    fi
done


if [ -z "$EXTERNAL_IPv4" ]; then
    echo "⚠️ Failed to get external server IPv4"
    exit 1
fi

echo "🌎 External IPv4 is ${EXTERNAL_IPv4}"
