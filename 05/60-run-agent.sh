source "$(dirname "$0")/01-define-exports.sh"


cat << EOF > "$(dirname "$0")/data/agent.conf"
agent {
    data_dir = "/tmp/data"
    log_level = "DEBUG"
    server_address = "${SPIRE_SERVER_DOMAIN}"
    server_port = "443"
    socket_path ="/tmp/spire-agent/socket"
    trust_bundle_path = "/opt/spire/data/bundle.crt"
    trust_domain = "sky.computing.ocp.one"
}

plugins {
    NodeAttestor "x509pop" {
        plugin_data {
            private_key_path = "/opt/spire/data/${LEGACY_DB_SRV}.key.pem"
            certificate_path = "/opt/spire/data/${LEGACY_DB_SRV}.crt.pem"
        }
    }
    KeyManager "disk" {
        plugin_data {
            directory = "data"
        }
    }
    WorkloadAttestor "unix" {
        plugin_data {
        }
    }
}
EOF


podman pod create \
  --name spire-agent-envoy-pod \
  --share pid,net,ipc,uts \
  -p 8443:8443

podman volume create spire-socket

podman run --pod spire-agent-envoy-pod \
  -v spire-socket:/tmp/spire-agent \
  -v "$(pwd)/data":/opt/spire/data \
  -v spire-socket:/tmp/spire-agent \
  ghcr.io/spiffe/spire-agent:1.14.0 \
  -config /opt/spire/data/agent.conf

podman run --pod spire-agent-envoy-pod  \
  -v spire-socket:/tmp/spire-agent \
  -v "$(pwd)/config.yaml":/etc/envoy/envoy.yaml \
  docker.io/envoyproxy/envoy:v1.36.2 \
  -c /etc/envoy/envoy.yaml

