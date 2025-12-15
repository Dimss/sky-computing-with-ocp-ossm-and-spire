source "$(dirname "$0")/01-define-exports.sh"

cat <<EOF | oc apply -f -
apiVersion: operator.openshift.io/v1alpha1
kind: SpireAgent
metadata:
  name: cluster
  annotations:
    ztwim.openshift.io/create-only: "true"
spec:
  trustDomain: $TRUST_DOMAIN
  clusterName: spiffe-eval
  nodeAttestor:
    k8sPSATEnabled: "true"
  workloadAttestors:
    k8sEnabled: "true"
    workloadAttestorsVerification:
      type: "auto"
EOF
until oc get daemonset/spire-agent -n ${ZTWIM_NS} &> /dev/null; do sleep 3; done
kubectl rollout status daemonset/spire-agent -n ${ZTWIM_NS} --timeout=300s
