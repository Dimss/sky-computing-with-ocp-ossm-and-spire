source "$(dirname "$0")/01-define-exports.sh"

cat <<EOF | oc apply -f -
apiVersion: operator.openshift.io/v1alpha1
kind: SpireServer
metadata:
  name: cluster
  annotations:
    ztwim.openshift.io/create-only: "true"
spec:
  trustDomain: $TRUST_DOMAIN
  clusterName: spiffe-eval
  caSubject:
    commonName: spiffe-eval
    country: "US"
    organization: "RH"
  persistence:
    type: pvc
    size: "5Gi"
    accessMode: ReadWriteOnce
  datastore:
    databaseType: sqlite3
    connectionString: "/run/spire/data/datastore.sqlite3"
    maxOpenConns: 100
    maxIdleConns: 2
    connMaxLifetime: 3600
  jwtIssuer: https://oidc-discovery.$TRUST_DOMAIN
EOF

kubectl rollout status statefulset/spire-server -n "${ZTWIM_NS}" --timeout=300s