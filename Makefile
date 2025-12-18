.PHONY: 01
01:
	01/10-install-ztwim-operator.sh
	01/20-install-spire-server.sh
	01/30-install-spire-agent.sh
	01/40-patch-spire-agent-config.sh
	01/50-spiffe-csi-driver.sh
	01/60-oidc-discovery-provider.sh
	01/70-verify-ztwim-installation.sh

.PHONY: 02
02:
	02/01-define-exports.sh
	02/10-install-ossm-operator.sh
	02/20-install-istio-cni.sh
	02/30-install-istiod.sh
	02/40-verify-ossm-installation.sh

.PHONY: 03
03:
	03/01-define-exports.sh
	03/10-new-project.sh
	03/20-install-httpbin.sh
	03/30-install-curl-client.sh
	03/40-make-http-call.sh
	03/50-strict-peer-auth.sh
	03/60-make-http-call.sh

.PHONY: 04
04:
	04/01-define-exports.sh
	04/10-req-auth-and-authz-policy.sh
	04/20-make-http-call.sh
	04/30-envoy-filter.sh
	04/40-make-http-call.sh

.PHONY: 05
05:
	05/10-certs-gen.sh
	05/20-create-x509pop-server-secret.sh
	05/30-patch-server-and-config.sh
	05/40-get-trust-bundle.sh
	05/50-route-for-spire.sh

