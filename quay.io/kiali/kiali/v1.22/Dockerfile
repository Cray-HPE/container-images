FROM quay.io/kiali/kiali:v1.22
USER root
RUN cd /tmp && \
    curl -o yum-3.4.3-168.el7.centos.noarch.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/yum-3.4.3-168.el7.centos.noarch.rpm && \
    curl -o yum-metadata-parser-1.1.4-10.el7.x86_64.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/yum-metadata-parser-1.1.4-10.el7.x86_64.rpm  && \
    curl -o cpio-2.11-28.el7.x86_64.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/cpio-2.11-28.el7.x86_64.rpm && \
    curl -o diffutils-3.3-5.el7.x86_64.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/diffutils-3.3-5.el7.x86_64.rpm && \
    curl -o yum-plugin-fastestmirror-1.1.31-54.el7_8.noarch.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/yum-plugin-fastestmirror-1.1.31-54.el7_8.noarch.rpm && \
    curl -o rpm-python-4.11.3-45.el7.x86_64.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/rpm-python-4.11.3-45.el7.x86_64.rpm && \
    curl -o pyxattr-0.5.1-5.el7.x86_64.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/pyxattr-0.5.1-5.el7.x86_64.rpm && \
    curl -o python-urlgrabber-3.10-10.el7.noarch.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/python-urlgrabber-3.10-10.el7.noarch.rpm && \
    curl -o iniparser-3.1-5.el7.x86_64.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/iniparser-3.1-5.el7.x86_64.rpm && \
    curl -o pygpgme-0.3-9.el7.x86_64.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/pygpgme-0.3-9.el7.x86_64.rpm &&\
    curl -o python-2.7.5-89.el7.x86_64.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/python-2.7.5-89.el7.x86_64.rpm && \
    curl -o pyliblzma-0.5.3-11.el7.x86_64.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/pyliblzma-0.5.3-11.el7.x86_64.rpm && \
    curl -o python-libs-2.7.5-89.el7.x86_64.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/python-libs-2.7.5-89.el7.x86_64.rpm && \
    curl -o python-pycurl-7.19.0-19.el7.x86_64.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/python-pycurl-7.19.0-19.el7.x86_64.rpm && \
    curl -o python-iniparse-0.4-9.el7.noarch.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/python-iniparse-0.4-9.el7.noarch.rpm && \
    curl -o rpm-python-4.11.3-45.el7.x86_64.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/rpm-python-4.11.3-45.el7.x86_64.rpm
RUN rpm -ivh /tmp/*.rpm --force --nodeps && yum update -y && yum clean all && rm -vf /tmp/*.rpm
USER kiali
