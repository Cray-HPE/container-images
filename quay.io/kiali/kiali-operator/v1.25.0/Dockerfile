FROM quay.io/kiali/kiali-operator:v1.25.0

USER 0

RUN yum -y upgrade && yum clean all

USER ${USER_UID}
