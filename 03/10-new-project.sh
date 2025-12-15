source "$(dirname "$0")/01-define-exports.sh"

oc create namespace "${TPJ}"
oc label namespace "${TPJ}" istio-injection=enabled