## v0.5.16 - 2019-08-16

  - Fix flaky unit test in provider package (#1151) @tariq1890
  - Dockerfile: Update version of base images (#1148) @tariq1890
  - DigitalOcean: Update `godo` to the latest stable version (#1145) @tariq1890
  - Fix build pipeline for Go v1.13 (#1142) @linki
  - AWS: Add Hosted Zone ID to logging output (#1129) @helgi
  - IstioGateway: Support namespaces on hostnames (#1124) @dcherman
  - AWS: Document `--prefer-cname` flag (#1123) @dbluxo
  - Add Tutorial for DNSimple provider (#1121) @marc-sensenich
  - Update Go version and golangci-lint to the latest release (#1120) @njuettner
  - Allow compilation on 32bit machines (#1116) @mylesagray
  - AWS: Allow to force usage of CNAME over ALIAS (#1103) @linki
  - CoreDNS: add option to specify prefix name (#1102) @xunpan
  - New provider: Rancher DNS (RDNS) (#1098) @Jason-ZW
  - Document where e2e tests are currently located (#1094) @jaypipes
  - Add initial KEP for ExternalDNS (#1092) @Raffo
  - Update Dockerfiles to follow best practices (#1091) @taharah
  - New Source: Heptio Contour IngressRoute (#1084) @jonasrmichel
  - AWS: Add dualstack support with ALB ingress controllers (#1079) @twilfong
  - Allow handling of multiple Oracle Cloud (OCI) zones (#1061) @suman-ganta
  - Namespace exposed metrics with the external_dns prefix (#794) @linki

## v0.5.15 - 2019-07-03

  - RFC2136: Fix when merging multiple targets (#1082) @hachh
  - New provider VinylDNS (#1080) @dgrizzanti 
  - Core: Fix for DomainFilter exclusions (#1059) @cmattoon
  - Core: Update aws-go-sdk to be compatible with kube-aws-iam-controller (#1054) @mikkeloscar
  - RFC2136: Log RR adds/deletes as Info (#1041) @gclawes
  - Docs: Cloudflare set ttl annotation for proxied entries to 1 (#1039) @MiniJerome
  - Core: Install ca-certificates (#1038) @dryewo
  - Cloudflare: Fix provider to return a single endpoint for each name/type (#1034) @shasderias
  - Core: Sanitize dockerfiles for external-dns (#1033) @tariq1890
  - Core: Add empty source (#1032) @anandkumarpatel
  - Google: Zones should be filter by their ID and Name (#1031) @simonswine
  - Core: Fix panic on empty targets for custom resources (#1029) @arturo-c
  - Core: Support externalTrafficPolicy annotation with "local" mode for NodePort service (#1023) @yverbin
  - Core: Add support for ExternalName services (#1018) @mironov

## v0.5.14 - 2019-05-14

  - Docs: Update aws.md (#1009) @pawelprazak 
  - New provider TransIP (#1007) @skoef
  - Docs: Add docker image faq (#1006) @Raffo 
  - DNSimple: Support apex records (#1004) @jbowes
  - NS1: Add --ns1-endpoint and --ns1-ignoressl flags (#1002) @mburtless
  - AWS: Cache the endpoints on the controller loop (#1001) @fraenkel 
  - Core: Supress Kubernetes logs (#991) @njuettner
  - Core: distroless/static image (#989) @jharshman
  - Core: Headless service missing DNS entry (#984) @yverbin 
  - New provider NS1 (#963) @mburtless 
  - Core: Add Cloud Foundry routes as a source (#955) @dgrizzanti 

## v0.5.13 - 2019-04-18

  - Azure: Support multiple A targets (#987) @michaelfig
  - Core: Fixing what seems an obvious omission of /github.com/ dir in Dockerfile (#985) @llamahunter
  - Docs: GKE tutorial remove disable-addon argument (#978) @ggordan
  - Docs: Alibaba Cloud config file missing by enable sts token (#977) @xianlubird
  - Docs: Alibaba Cloud fix wrong arg in manifest (#976) @iamzhout
  - AWS: Set a default TTL for Alias records (#975) @fraenkel
  - Cloudflare: Add support for multiple target addresses (#970) @nta
  - AWS: Adding China ELB endpoints and hosted zone id's (#968) @jfillo
  - AWS: Streamline ApplyChanges (#966) @fraenkel
  - Core: Switch to go modules (#960) @njuettner
  - Docs: AWS how to check if your cluster has a RBAC (#959) @confiq
  - Docs: AWS remove superfluous trailing period from hostname (#952) @hobti01
  - Core: Add generic logic to remove secrets from logs (#951) @dsbrng25b
  - RFC2136: Remove unnecessary parameter (#948) @ChristianMoesl
  - Infoblox: Reduce verbosity of logs (#945) @dsbrng25b

## v0.5.12 - 2019-03-26

  - Bumping istio to 1.1.0 (#942) @venezia
  - Docs: Added stability matrix and minor improvements to README (#938) @Raffo
  - Docs: Added a reference to a blogpost which uses ExternalDNS in a CI/CD setup (#928) @vanhumbeecka
  - Use k8s informer cache instead of making active API GET requests (#917) @jlamillan
  - Docs: Tiny clarification about two available deployment methods (#935) @przemolb
  - Add support for multiple Istio IngressGateway LoadBalancer Services (#907) @LorbusChris
  - Set log level to debug when axfr is disabled (#932) @arief-hidayat
  - Infoblox provider support for DNS view (#895) @dsbrng25b
  - Add RcodeZero Anycast DNS provider (#874) @dklesev
  - Docs: Dropping owners (#929) @njuettner
  - Docs: Added description for multiple dns name (#911) @st1t
  - Docs: Clarify that hosted zone identifier is to be used (#915) @dirkgomez
  - Docs: Make dep step which may be needed to run make build (#913) @dirkgomez
  - PowerDNS: Fixed Domain Filter Bug (#827) @anandsinghkunwar
  - Allow hostname annotations to be ignored (#745) @anandkumarpatel
  - RFC2136: Fixed typo in debug output (#899) @hpandeycodeit

## v0.5.11 - 2019-02-11

  - Fix constant updating issue introduced with v0.5.10 (#886) @jhohertz
  - Ignore evaluate target health for calculating changes for AWS (#880) @linki
  - Pagination for cloudflare zones (#873) @njuettner

## v0.5.10 - 2019-01-28

  - Docs: Improve documentation regarding Alias (#868) @alexnederlof
  - Adds a new flag `--aws-api-retries` which allows overriding the number of retries (#858) @viafoura
  - Docs: Make awscli commands use JSON output (#849) @ifosch
  - Docs: Add missing apiVersion to Ingress resource (#847) @shlao
  - Fix for AWS private DNS zone (#844) @xianlubird
  - Add support for AWS ELBs in eu-north-1 (#843) @argoyle
  - Create a SECURITY_CONTACTS file (#842) @njuettner
  - Use correct product name for Google Cloud DNS (#841) @seils
  - Change default AWSBatchChangeSize to 1000 (#839) @medzin
  - Fix dry-run mode in rfc2136 provider (#838) @lachlancooper
  - Fix typos in rfc2136 provider (#837) @lachlancooper
  - rfc2136 provider: one IP Target per RRSET (#836) @ivanfilippov
  - Normalize DNS names during planning (#833) @justinsb
  - Implement Stringer for planTableRow (#832) @justinsb
  - Docs: Better security granularity concerning external dns service principal for Azure (#829) @DenisBiondic
  - Docs: Update links in Cloudflare docs (#824) @PascalKu
  - Docs: Add metrics info to FAQ (#822) @zachyam
  - Docs: Update nameserver IPs in coredns.md (#820) @mozhuli
  - Docs: Fix commands to cleanup Cloudflare (#818) @acrogenesis
  - Avoid unnecessary updating for CRD resource (#810) @xunpan
  - Fix issues with CoreDNS provider and more than 1 targets (#807) @xunpan
  - AWS: Add zone tag filter (#804) @csrwng
  - Docs: Update CoreDNS tutorial with RBAC manifest (#803) @Lujeni
  - Use SOAP API to improve DYN's provider's performance (#799) @sanyu
  - Expose managed resources and records as metrics (#793) @linki
  - Docs: Updating Azure tutorial (#788) @pelithne
  - Improve errors in Records() of Infoblox provider (#785) @dsbrng25b
  - Change default apiVersion of CRD Source (#774) @dsbrng25b
  - Allow setting Cloudflare proxying on a per-Ingress basis (#650) @eswets
  - Support A record for multiple IPs for headless services (#645) @toshipp

## v0.5.9 - 2018-11-22

  - Core: Update delivery.yaml to new format (#782) @linki
  - Core: Adjust gometalinter timeout by setting env var (#778) @njuettner
  - Provider **Google**: Panic assignment to entry in nil map (#776) @njuettner
  - Docs: Fix typos (#769) @mooncak
  - Docs: Remove duplicated words (#768) @mooncak
  - Provider **Alibaba**: Alibaba Cloud Provider Fix Multiple Subdomains Bug (#767) @xianlubird
  - Core: Add Traefik to the supported list of ingress controllers (#764) @coderanger
  - Provider **Dyn**: Fix some typos in returned messages in dyn.go (#760) @AdamDang
  - Docs: Update Azure documentation (#756) @pascalgn
  - Provider **Oracle**: Oracle doc fix (add "key:" to secret) (#750) @CaptTofu
  - Core: Docker MAINTAINER is deprecated - using LABEL instead (#747) @helgi
  - Core: Feature add alias annotation (#742) @vaegt
  - Provider **RFC2136**: Fix rfc2136 - setup fails issue and small docs (#741) @antlad
  - Core: Fix nil map access of endpoint labels (#739) @shashidharatd
  - Provider **PowerDNS**: PowerDNS Add DomainFilter support (#737) @ottoyiu
  - Core: Fix domain-filter matching logic to not match similar domain names (#736) @ottoyiu
  - Core: Matching entire string for wildcard in txt records with prefixes (#727) @etopeter
  - Provider **Designate**: Fix TLS issue with OpenStack auth (#717) @FestivalBobcats
  - Provider **AWS**: Add helper script to update route53 txt owner entries (#697) @efranford
  - Provider **CoreDNS**: Migrate to use etcd client v3 for CoreDNS provider (#686) @shashidharatd
  - Core: Create a non-root user to run the container process (#684) @coderanger
  - Core: Do not replace TXT records with A/CNAME records in planner (#581) @jchv

## v0.5.8 - 2018-10-11

  - New Provider: RFC2136 (#702) @antlad
  - Add Linode to list of supported providers (#730) @cliedeman
  - Correctly populate target health check on existing records (#724) @linki
  - Don't erase Endpoint labels (#713) @sebastien-prudhomme

## v0.5.7 - 2018-09-27

  - Pass all relevant CLI flags to AWS provider (#719) @linki
  - Replace glog with a noop logger (#714) @linki
  - Fix handling of custom TTL values with Google DNS. (#704) @kevinmdavis
  - Continue even if node listing fails (#701) @pascalgn
  - Fix Host field in HTTP request when using pdns provider (#700) @peterbale
  - Allow AWS batching to fully sync on each run (#699) @bartelsielski

## v0.5.6 - 2018-09-07
  
  - Alibaba Cloud (#696) @xianlubird  
  - Add Source implementation for Istio Gateway (#694) @jonasrmichel
  - CRD source based on getting endpoints from CRD (#657) @shashidharatd
  - Add filter by service type feature (#653) @Devatoria
  - Add generic metrics for Source & Registry Errors (#652) @wleese

## v0.5.5 - 2018-08-17

  - Configure req timeout calling k8s APIs (#681) @jvassev
  - Adding assume role to aws_sd provider (#676) @lb-saildrone
  - Dyn: cache records per zone using zone's serial number (#675) @jvassev
  - Linode provider (#674) @cliedeman
  - Cloudflare Link Language Specificity (#673) @christopherhein
  - Retry calls to dyn on ErrRateLimited (#671) @jvassev
  - Add support to configure TTLs on DigitalOcean (#667) @andrewsomething
  - Log level warning option (#664) @george-angel
  - Fix usage of k8s.io/client-go package (#655) @shashidharatd
  - Fix for empty target annotation (#647) @rdrgmnzs
  - Fix log message for #592 when no updates in hosted zones (#634) @audip
  - Add aws-evaluate-target-health flag (#628) @peterbale
  - Exoscale provider (#625) @FaKod @greut
  - Oracle Cloud Infrastructure DNS provider (#626) @prydie
  - Update DO CNAME type API request to prevent error 422 (#624) @nenadilic84
  - Fix typo in cloudflare.md (#623) @derekperkins
  - Infoblox-go-client was only setting timeout for http.Transport.ResponseHeaderTimeout instead of for http.Client (#615) @khrisrichardson
  - Adding a flag to optionally publish hostIP instead of podIP for headless services (#597) @Arttii

## v0.5.4 - 2018-06-28

  - Only store endpoints with their labels in the cache (#612) @njuettner
  - Read hostnames from spec.tls.hosts on Ingress object (#611) @ysoldak
  - Reorder provider/aws suitable-zones tests (#608) @elordahl
  - Adds TLS flags for pdns provider (#607) @jhoch-palantir
  - Update RBAC for external-dns to list nodes (#600) @njuettner
  - Add aws max change count flag (#596) @peterbale
  - AWS provider: Properly check suitable domains (#594) @elordahl
  - Annotation with upper-case hostnames block further updates (#579) @njuettner
  
## v0.5.3 - 2018-06-15

  - Print a message if no hosted zones match (aws provider) (#592) @svend
  - Add support for NodePort services (#559) @grimmy
  - Update azure.md to fix protocol value (#593) @JasonvanBrackel
  - Add cache to limit calls to providers (#589) @jessfraz
  - Add Azure MSI support (#578) @r7vme
  - CoreDNS/SkyDNS provider (#253) @istalker2

## v0.5.2 - 2018-05-31

  - DNSimple: Make DNSimple tolerant of unknown zones (#574) @jbowes
  - Cloudflare: Custom record TTL (#572) @njuettner
  - AWS ServiceDiscovery: Implementation of AWS ServiceDiscovery provider (#483) @vanekjar
  - Update docs to latest changes (#563) @Raffo
  - New source - connector (#552) @shashidharatd
  - Update AWS SDK dependency to v1.13.7 @vanekjar

## v0.5.1 - 2018-05-16

  - Refactor implementation of sync loop to use `time.Ticker` (#553) @r0fls
  - Document how ExternalDNS gets permission to change AWS Route53 entries (#557) @hjacobs
  - Fix CNAME support for the PowerDNS provider (#547) @kciredor
  - Add support for hostname annotation in Ingress resource (#545) @rajatjindal
  - Fix for TTLs being ignored on headless Services (#546) @danbondd
  - Fix failing tests by giving linters more time to do their work (#548) @linki
  - Fix misspelled flag for the OpenStack Designate provider (#542) @zentale
  - Document additional RBAC rules needed to read Pods (#538) @danbondd

## v0.5.0 - 2018-04-23

  - Google: Correctly filter records that don't match all filters (#533) @prydie @linki
  - AWS: add support for AWS Network Load Balancers (#531) @linki
  - Add a flag that allows FQDN template and annotations to combine (#513) @helgi
  - Fix: Use PodIP instead of HostIP for headless Services (#498) @nrobert13
  - Support a comma separated list for the FQDN template (#512) @helgi
  - Google Provider: Add auto-detection of Google Project when running on GCP (#492) @drzero42
  - Add custom TTL support for DNSimple (#477) @jbowes
  - Fix docker build and delete vendor files which were not deleted (#473) @njuettner
  - DigitalOcean: DigitalOcean creates entries with host in them twice (#459) @njuettner
  - Bugfix: Retrive all DNSimple response pages (#468) @jbowes
  - external-dns does now provide support for multiple targets for A records. This is currently only supported by the Google Cloud DNS provider (#418) @dereulenspiegel
  - Graceful handling of misconfigure password for dyn provider (#470) @jvassev
  - Don't log sensitive data on start (#463) @jvassev
  - Google: Improve logging to help trace misconfigurations (#388) @stealthybox
  - AWS: In addition to the one best public hosted zone, records will be added to all matching private hosted zones (#356) @coreypobrien
  - Every record managed by External DNS is now mapped to a kubernetes resource (service/ingress) @ideahitme
    - New field is stored in TXT DNS record which reflects which kubernetes resource has acquired the DNS name
    - Target of DNS record is changed only if corresponding kubernetes resource target changes
    - If kubernetes resource is deleted, then another resource may acquire DNS name
    - "Flapping" target issue is resolved by providing a consistent and defined mechanism for choosing a target
  - New `--zone-id-filter` parameter allows filtering by zone id (#422) @vboginskey
  - TTL annotation check for azure records (#436) @stromming
  - Switch from glide to dep (#435) @bkochendorfer

## v0.4.8 - 2017-11-22

  - Allow filtering by source annotation via `--annotation-filter` (#354) @khrisrichardson
  - Add support for Headless hostPort services (#324) @Arttii
  - AWS: Added change batch limiting to a maximum of 4000 Route53 updates in one API call.  Changes exceeding the limit will be dropped but all related changes by hostname are preserved within the limit. (#368) @bitvector2
  - Google: Support configuring TTL by annotation: `external-dns.alpha.kubernetes.io/ttl`. (#389) @stealthybox
  - Infoblox: add option `--no-infoblox-ssl-verify` (#378) @khrisrichardson
  - Inmemory: add support to specify zones for inmemory provider via command line (#366) @ffledgling

## v0.4.7 - 2017-10-18

  - CloudFlare: Disable proxy mode for TXT and others (#361) @dunglas

## v0.4.6 - 2017-10-12

  - [AWS Route53 provider] Support customization of DNS record TTL through the use of annotation `external-dns.alpha.kubernetes.io/ttl` on services or ingresses (#320) @kevinjqiu
  - Added support for [DNSimple](https://dnsimple.com/) as DNS provider (#224) @jose5918
  - Added support for [Infoblox](https://www.infoblox.com/products/dns/) as DNS provider (#349) @khrisrichardson

## v0.4.5 - 2017-09-24

  - Add `--log-level` flag to control log verbosity and remove `--debug` flag in favour of `--log-level=debug` (#339) @ultimateboy
  - AWS: Allow filtering for private and public zones via `--aws-zone-type` flag (#329) @linki
  - CloudFlare: Add `--cloudflare-proxied` flag to toggle CloudFlare proxy feature (#340) @dunglas
  - Kops Compatibility: Isolate ALIAS type in AWS provider (#248) @sethpollack

## v0.4.4 - 2017-08-17

  - ExternalDNS now services of type `ClusterIP` with the use of the `--publish-internal-services`.  Enabling this will now create the apprioriate A records for the given service's internal ip.  @jrnt30
  - Fix to have external target annotations on ingress resources replace existing endpoints instead of appending to them (#318)

## v0.4.3 - 2017-08-10

  - Support new `external-dns.alpha.kubernetes.io/target` annotation for Ingress (#312)
  - Fix for wildcard domains in Route53 (#302)

## v0.4.2 - 2017-08-03

  - Fix to support multiple hostnames for Molecule Software's [route53-kubernetes](https://github.com/wearemolecule/route53-kubernetes) compatibility (#301)

## v0.4.1 - 2017-07-28

  - Fix incorrect order of constructor parameters (#298)

## v0.4.0 - 2017-07-21

  - ExternalDNS now supports three more DNS providers:
    * [AzureDNS](https://azure.microsoft.com/en-us/services/dns) @peterhuene
    * [CloudFlare](https://www.cloudflare.com/de/dns) @njuettner
    * [DigitalOcean](https://www.digitalocean.com/products/networking) @njuettner
  - Fixed a bug that prevented ExternalDNS to be run on Tectonic clusters @sstarcher
  - ExternalDNS is now a full replace for Molecule Software's `route53-kubernetes` @iterion
  - The `external-dns.alpha.kubernetes.io/hostname` annotation accepts now a comma separated list of hostnames and a trailing period is not required anymore. @totallyunknown
  - The flag `--domain-filter` can be repeated multiple times like `--domain-filter=example.com --domain-filter=company.org.`. @totallyunknown
  - A trailing period is not required anymore for `--domain-filter` when AWS (or any other) provider is used. @totallyunknown
  - We added a FakeSource that generates random endpoints and allows to run ExternalDNS without a Kubernetes cluster (e.g. for testing providers) @ismith
  - All HTTP requests to external APIs (e.g. DNS providers) generate client side metrics. @linki
  - The `--zone` parameter was removed in favor of a provider independent `--domain-filter` flag. @linki
  - All flags can now also be set via environment variables. @linki

## v0.3.0 - 2017-05-08

Features:

  - Changed the flags to the v0.3 semantics, the following has changed:
    1. The TXT registry is used by default and has an owner ID of `default`
    2. `--dry-run` is disabled by default
    3. The `--compatibility` flag was added and takes a string instead of a boolean
    4. The `--in-cluster` flag has been dropped for auto-detection
    5. The `--zone` specifier has been replaced by a `--domain-filter` that filters domains by suffix
  - Improved logging output
  - Generate DNS Name from template for services/ingress if annotation is missing but `--fqdn-template` is specified
  - Route 53, Google CloudDNS: Support creation of records in multiple hosted zones.
  - Route 53: Support creation of ALIAS records when endpoint target is a ELB/ALB.
  - Ownership via TXT records
    1. Create TXT records to mark the records managed by External DNS
    2. Supported for AWS Route53 and Google CloudDNS
    3. Configurable TXT record DNS name format
  - Add support for altering the DNS record modification behavior via policies.

## v0.2.0 - 2017-04-07

Features:

  - Support creation of CNAME records when endpoint target is a hostname.
  - Allow omitting the trailing dot in Service annotations.
  - Expose basic Go metrics via Prometheus.

Documentation:

  - Add documentation on how to setup ExternalDNS for Services on AWS.

## v0.1.1 - 2017-04-03

Bug fixes:

  - AWS Route 53: Do not submit request when there are no changes.

## v0.1.0 - 2017-03-30 (KubeCon)

Features:

  - Manage DNS records for Services with `Type=LoadBalancer` on Google CloudDNS.
