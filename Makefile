
.PHONY: install-rh-ztwim
install-rh-ztwim:
	01-install-ztwim/10-install-ztwim-operator.sh
	01-install-ztwim/20-install-spire-server.sh
	01-install-ztwim/30-install-spire-agent.sh
	01-install-ztwim/40-patch-spire-agent-config.sh
	01-install-ztwim/50-spiffe-csi-driver.sh
	01-install-ztwim/60-oidc-discovery-provider.sh
	01-install-ztwim/70-verify-ztwim-installation.sh


.PHONY: install-rh-ossm
install-rh-ossm:
	02-install-ossm/01-define-exports.sh
	02-install-ossm/10-install-ossm-operator.sh
	02-install-ossm/20-install-istio-cni.sh
	02-install-ossm/30-install-istiod.sh
	02-install-ossm/40-verify-ossm-installation.sh

.PHONY: 03
03:
	03-secure-mesh-with-ztwim-and-ossm/01-define-exports.sh
	03-secure-mesh-with-ztwim-and-ossm/10-new-project.sh
	03-secure-mesh-with-ztwim-and-ossm/20-install-httpbin.sh
	03-secure-mesh-with-ztwim-and-ossm/30-install-curl-client.sh
	03-secure-mesh-with-ztwim-and-ossm/40-make-http-call.sh
	03-secure-mesh-with-ztwim-and-ossm/50-strict-peer-auth.sh
	03-secure-mesh-with-ztwim-and-ossm/60-make-http-call.sh

.PHONY: 04
04:
	04/01-define-exports.sh
	04/10-req-auth-and-authz-policy.sh
	04/20-make-http-call.sh
	04/30-envoy-filter.sh
	04/40-make-http-call.sh