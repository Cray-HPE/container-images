FROM minio/mc:latest
ARG RPMFILE=glib2-2.56.4-10.el8_4.1.x86_64.rpm
ARG URLPATH="http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/${RPMFILE}"
RUN curl -o $RPMFILE ${URLPATH}
RUN rpm -Uvh /${RPMFILE} && rm -f /${RPMFILE}

