source "$(dirname "$0")/01-define-exports.sh"

cat <<EOF | oc apply -f -
apiVersion: security.istio.io/v1
kind: RequestAuthentication
metadata:
  name: httpbin
  namespace: ${TPJ}
spec:
  selector:
    matchLabels:
      app: httpbin
  jwtRules:
    - issuer: "https://oidc-discovery.${TRUST_DOMAIN}"
      jwksUri: https://spire-spiffe-oidc-discovery-provider.${ZTWIM_NS}.svc/keys
      audiences:
      - sky-computing-demo
      forwardOriginalToken: true
---
apiVersion: security.istio.io/v1
kind: AuthorizationPolicy
metadata:
  name: httpbin
  namespace: ${TPJ}
spec:
  selector:
    matchLabels:
      app: httpbin
  rules:
    - from:
        - source:
            requestPrincipals: ["https://oidc-discovery.$TRUST_DOMAIN/*"]
EOF
