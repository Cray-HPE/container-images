FROM quay.io/kiali/kiali-operator:v1.28.1

USER 0

RUN yum -y upgrade && yum clean all

USER ${USER_UID}
