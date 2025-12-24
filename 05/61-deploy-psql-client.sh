source "$(dirname "$0")/01-define-exports.sh"


cat <<EOF | oc apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: psql
  namespace: ${TPJ}
spec:
  selector:
    matchLabels:
      app: psql
      version: v1
  template:
    metadata:
      annotations:
        inject.istio.io/templates: "sidecar,spire"
        envoy-jwt-auth-helper/audience: "sky-computing-demo"
      labels:
        app: psql
        version: v1
    spec:
      containers:
      - image: postgres:16.9
        imagePullPolicy: IfNotPresent
        name: psql
        command:
          - /bin/bash
          - -c
          - sleep inf
EOF


# test connection:  psql -h 85.250.185.9 -U postgres -c "\\l"