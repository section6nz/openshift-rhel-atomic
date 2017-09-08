FROM registry.access.redhat.com/rhel-atomic:7

ENV S2I_SCRIPTS_PATH="${S2I_SCRIPTS_PATH:-/usr/libexec/s2i}" \
  S2I_DESTINATION="${S2I_SCRIPTS_DESTINATION:-/tmp}" \
  BUILD_USER_ID=1001 \
  OPENSHIFT_DEPLOYMENTS_DIR="${OPENSHIFT_DEPLOYMENTS_DIR:-/opt/openshift}" \
  OPENSHIFT_SOURCE_DIR="${OPENSHIFT_SOURCE_DIR:-/opt/source}"

LABEL vendor="Red Hat" \
      name="RHEL Atomic Base Image" \
      version="7" \
      io.k8s.description="RHEL base image with common packages and certs" \
      io.k8s.display-name="Red Hat Atomic Linux" \
      io.openshift.tags="base,os,rhel,atomic" \
      io.openshift.s2i.scripts-url="image://${S2I_SCRIPTS_PATH}" \
      io.openshift.s2i.destination="${S2I_DESTINATION}" \
      com.redhat.deployments-dir="${OPENSHIFT_DEPLOYMENTS_DIR}"

COPY assets/certs /etc/pki/ca-trust/source/anchors

RUN update-ca-trust extract \
    && microdnf install \
        --enablerepo=rhel-7-server-rpms \
        --nodocs \
        shadow-utils tar gzip unzip bc which lsof ca-certificates \
    && microdnf clean all \
    && install -d -m ug+rwx -o ${BUILD_USER_ID} -g 0 \
      ${OPENSHIFT_SOURCE_DIR} \
      ${OPENSHIFT_DEPLOYMENTS_DIR} \
    && install -d ${S2I_SCRIPTS_PATH}
