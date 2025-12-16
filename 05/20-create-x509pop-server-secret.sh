source "$(dirname "$0")/01-define-exports.sh"

export CA_CRT_PEM=$(sed 's/^/    /' < "$(dirname "$0")/certs/ca.crt.pem" )

cat <<EOF | oc apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: x509pop-ca
  namespace: "$ZTWIM_NS"
stringData:
  ca.crt.pem: |
${CA_CRT_PEM}
EOF
#
#kubectl patch statefulset spire-server -n "${ZTWIM_NS}" --patch '
#spec:
#  template:
#    spec:
#      volumes:
#      - name: x509pop-ca
#        secret:
#          secretName: x509pop-ca
#      containers:
#      - name: spire-server
#        volumeMounts:
#        - name: x509pop-ca
#          mountPath: /tmp/x509pop-ca
#          readOnly: true
#'
#
#export NEW_ATTESTOR='{"x509pop": {"plugin_data": {"ca_bundle_path": "/tmp/x509pop-ca/ca.crt.pem"}}}'
#
#kubectl get configmap spire-server -n "${ZTWIM_NS}" -o json | \
#jq --argjson new "$NEW_ATTESTOR" \
#   '.data["server.conf"] |= (fromjson | .plugins.NodeAttestor += [$new] | tojson)' | \
#kubectl apply -f -