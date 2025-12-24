source "$(dirname "$0")/01-define-exports.sh"

export VM_IP=(curl -s ifconfig.io)

cat <<EOF | oc apply -f -
apiVersion: networking.istio.io/v1beta1
kind: ServiceEntry
metadata:
  name: external-postgres-ip
  namespace: ${TPJ}
spec:
  hosts:
  - postgres-db.external
  addresses:
  - $VM_IP/32
  ports:
  - number: 5432
    name: tcp-postgres
    protocol: TCP
  location: MESH_INTERNAL
  resolution: STATIC
  endpoints:
  - address: "$VM_IP"
EOF

cat <<EOF | oc apply -f -
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: remote-postgres-mtls
  namespace: ${TPJ}
spec:
  host: postgres-db.external
  trafficPolicy:
    tls:
      mode: ISTIO_MUTUAL
EOF