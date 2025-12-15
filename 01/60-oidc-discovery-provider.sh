source "$(dirname "$0")/01-define-exports.sh"

cat <<EOF | oc apply -f -
apiVersion: operator.openshift.io/v1alpha1
kind: SpireOIDCDiscoveryProvider
metadata:
  name: cluster
spec:
  trustDomain: $TRUST_DOMAIN
  agentSocketName: 'socket'
  jwtIssuer: https://oidc-discovery.$TRUST_DOMAIN
EOF

until oc get deployment spire-spiffe-oidc-discovery-provider -n "${ZTWIM_NS}" &> /dev/null; do sleep 3; done
oc wait --for=condition=Available deployment/spire-spiffe-oidc-discovery-provider -n "${ZTWIM_NS}" --timeout=300s