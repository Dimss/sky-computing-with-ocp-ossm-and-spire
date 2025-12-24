source "$(dirname "$0")/01-define-exports.sh"

oc exec spire-server-0 \
 -c spire-server \
 -n "${ZTWIM_NS}" \
 -- /bin/sh -c "/spire-server bundle show -format pem > /tmp/bundle.crt"
oc cp "${ZTWIM_NS}"/spire-server-0:/tmp/bundle.crt "$(dirname "$0")/data/bundle.crt"

#oc exec spire-server-0 \
# -c spire-server \
# -n "${ZTWIM_NS}" \
# -- /bin/sh -c "/spire-server entry create \
#                    -parentID spiffe://sky.computing.ocp.one/spire/agent/x509pop/a42d40f140d4a4f400c2f703a23eeb9dcee19545 \
#                    -spiffeID spiffe://sky.computing.ocp.one/legacy-db-srv \
#                    -selector unix:uid:101"