source "$(dirname "$0")/01-define-exports.sh"

oc new-project "${OSSM_NS}"
# Create Istiod
cat <<EOF | oc apply -f -
apiVersion: sailoperator.io/v1
kind: Istio
metadata:
  name: default
spec:
  namespace: istio-system
  updateStrategy:
    type: InPlace
  values:
    pilot:
      jwksResolverExtraRootCA: |
${EXTRA_ROOT_CA}
      env:
        PILOT_JWT_ENABLE_REMOTE_JWKS: "true"
    meshConfig:
      trustDomain: $TRUST_DOMAIN
    sidecarInjectorWebhook:
      templates:
        spire: |
          spec:
            containers:
            - name: istio-proxy
              volumeMounts:
              - name: workload-socket
                mountPath: /run/secrets/workload-spiffe-uds
                readOnly: true
            - name: envoy-jwt-auth-helper
              image: dimssss/envoy-jwt-auth-helper:latest
              env:
              - name: SPIRE_ENVOY_JWT_HELPER_AUDIENCE
                valueFrom:
                  fieldRef:
                    fieldPath: metadata.annotations['envoy-jwt-auth-helper/audience']
              - name: SPIRE_ENVOY_JWT_HELPER_JWT_MODE
                value: jwt_injection
              - name: SPIRE_ENVOY_JWT_HELPER_SOCKET_PATH
                value: unix:///run/secrets/workload-spiffe-uds/socket
              volumeMounts:
              - name: workload-socket
                mountPath: /run/secrets/workload-spiffe-uds
                readOnly: true
            volumes:
              - name: workload-socket
                csi:
                  driver: "csi.spiffe.io"
                  readOnly: true
EOF
# Wait till it successfully installed
until oc get deployment istiod -n "${OSSM_NS}" &> /dev/null; do sleep 3; done
oc wait --for=condition=Available deployment/istiod -n "${OSSM_NS}" --timeout=300s
