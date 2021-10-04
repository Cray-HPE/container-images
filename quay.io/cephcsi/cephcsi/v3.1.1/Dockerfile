FROM quay.io/cephcsi/cephcsi:v3.1.1

RUN yum install -y yum-plugin-versionlock\
    && yum versionlock ceph*\
    && yum versionlock python3-ceph*\
    && yum versionlock libceph*\
    && yum versionlock rbd*\
    && yum versionlock python3-rbd*\
    && yum versionlock librbd*\
    && yum versionlock python3-rgw*\
    && yum versionlock librgw*\
    && yum versionlock python3-rados*\
    && yum versionlock librados*\
    && yum -y upgrade && yum clean all
