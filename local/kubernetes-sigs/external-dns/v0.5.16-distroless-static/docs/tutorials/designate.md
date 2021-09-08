# Setting up ExternalDNS for Services on OpenStack Designate

This tutorial describes how to setup ExternalDNS for usage within a Kubernetes cluster using OpenStack Designate DNS.

## Authenticating with OpenStack

We are going to use OpenStack CLI - `openstack` utility, which is an umbrella application for most of OpenStack clients including `designate`.

All OpenStack CLIs require authentication parameters to be provided. These parameters include:
* URL of the OpenStack identity service (`keystone`) which is responsible for user authentication and also served as a registry for other
  OpenStack services. Designate endpoints must be registered in `keystone` in order to ExternalDNS and OpenStack CLI be able to find them.
* OpenStack region name
* User login name.
* User project (tenant) name.
* User domain (only when using keystone API v3)

Although these parameters can be passed explicitly through the CLI flags, traditionally it is done by sourcing `openrc` file (`source ~/openrc`) that is a
shell snippet that sets environment variables that all OpenStack CLI understand by convention.

Recent versions of OpenStack Dashboard have a nice UI to download `openrc` file for both v2 and v3 auth protocols. Both protocols can be used with ExternalDNS.
v3 is generally preferred over v2, but might not be available in some OpenStack installations.

## Installing OpenStack Designate

Please refer to the Designate deployment [tutorial](https://docs.openstack.org/project-install-guide/dns/ocata/install.html) for instructions on how
to install and test Designate with BIND backend. You will be required to have admin rights in existing OpenStack installation to do this. One convenient
way to get yourself an OpenStack installation to play with is to use [DevStack](https://docs.openstack.org/devstack/latest/).

## Creating DNS zones

All domain names that are ExternalDNS is going to create must belong to one of DNS zones created in advance. Here is an example of how to create `example.com` DNS zone:
```console
$ openstack zone create --email dnsmaster@example.com example.com.
```

It is important to manually create all the zones that are going to be used for kubernetes entities (ExternalDNS sources) before starting ExternalDNS.

## Deploy ExternalDNS

Create a deployment file called `externaldns.yaml` with the following contents:

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: external-dns
spec:
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: external-dns
    spec:
      containers:
      - name: external-dns
        image: registry.opensource.zalan.do/teapot/external-dns
        args:
        - --source=service # ingress is also possible
        - --domain-filter=example.com # (optional) limit to only example.com domains; change to match the zone created above.
        - --provider=designate
        env: # values from openrc file
        - name: OS_AUTH_URL
          value: http://controller/identity/v3
        - name: OS_REGION_NAME
          value: RegionOne
        - name: OS_USERNAME
          value: admin
        - name: OS_PASSWORD
          value: p@ssw0rd
        - name: OS_PROJECT_NAME
          value: demo
        - name: OS_USER_DOMAIN_NAME
          value: Default
```

Create the deployment for ExternalDNS:

```console
$ kubectl create -f externaldns.yaml
```

## Deploying an Nginx Service

Create a service file called 'nginx.yaml' with the following contents:

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: nginx
spec:
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - image: nginx
        name: nginx
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: nginx
  annotations:
    external-dns.alpha.kubernetes.io/hostname: my-app.example.com
spec:
  selector:
    app: nginx
  type: LoadBalancer
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

Note the annotation on the service; use the same hostname as the DNS zone created above.

ExternalDNS uses this annotation to determine what services should be registered with DNS. Removing the annotation will cause ExternalDNS to remove the corresponding DNS records.

Create the deployment and service:

```console
$ kubectl create -f nginx.yaml
```


Once the service has an external IP assigned, ExternalDNS will notice the new service IP address and notify Designate,
which in turn synchronize DNS records with underlying DNS server backend.

## Verifying DNS records

To verify that DNS record was indeed created, you can use the following command:

```console
$ openstack recordset list example.com.
```

There should be a record for my-app.example.com having `ACTIVE` status. And of course, the ultimate method to verify is to issue a DNS query:

```console
$ dig my-app.example.com @controller
```

## Cleanup

Now that we have verified that ExternalDNS created all DNS records, we can delete the tutorial's example:

```console
$ kubectl delete service -f nginx.yaml
$ kubectl delete service -f externaldns.yaml
```
