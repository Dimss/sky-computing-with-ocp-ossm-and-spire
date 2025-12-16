source "$(dirname "$0")/01-define-exports.sh"

openssl genpkey \
   -algorithm RSA \
   -out "${CERTS_DIR}/ca.key.pem"

openssl req -new -x509 -days 365 \
  -key "${CERTS_DIR}/ca.key.pem" \
  -out "${CERTS_DIR}/ca.crt.pem" \
  -subj "/CN=${CA_CN}"

openssl genpkey -algorithm RSA \
  -out "${CERTS_DIR}/node-1.key.pem"

openssl req -new \
  -key "${CERTS_DIR}/node-1.key.pem" \
  -out "${CERTS_DIR}/node-1.csr.pem" \
  -subj "/CN=${CN_NODE_1}"

openssl x509 -req -days 365 \
 -in "${CERTS_DIR}/node-1.csr.pem" \
 -CA "${CERTS_DIR}/ca.crt.pem" \
 -CAkey "${CERTS_DIR}/ca.key.pem" \
 -CAcreateserial -out "${CERTS_DIR}/node-1.crt.pem"
