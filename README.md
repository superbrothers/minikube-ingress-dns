# minikube-ingress-dns

This repository contains the script files in order to configure and restart dnsmasq automatically for Kubernetes Ingress LB on minikube after running `minikube start`. For more details, see [this article](http://qiita.com/superbrothers/items/13d8ce012ef23e22cb74) (In Japanese).

## Installation

You can install minikube-ingress-dns with homebrew as follows:

```
$ brew tap superbrothers/minikube-ingress-dns git://github.com/superbrothers/minikube-ingress-dns.git
$ brew install minikube-ingress-dns
```

Otherwise you just clone this repository to install:

```
$ git clone https://github.com/superbrothers/minikube-ingress-dns.git /path/to/minikube-ingress-dns
```

## Requirement

To work minikube-ingress-dns requires dnsmasq. If you use macOS, you can install dnsmasq by using Homebrew.

```
$ brew install dnsmasq
```

If you use Ubuntu desktop, you don't need to install dnsmasq due to it is already installed.

## Usage

Choose the script file for your environment.

```sh
# macOS
alias minikube=/path/to/minikube-ingress-dns/minikube-ingress-dns-macos

# Ubuntu 16.04 LTS
alias minikube=/path/to/minikube-ingress-dns/minikube-ingress-dns-ubuntu16

# Ubuntu 14.04 LTS
alias minikube=/path/to/minikube-ingress-dns/minikube-ingress-dns-ubuntu14
```

The default base domain for Ingress LB is `minikube.dev`. For example, if you create an ingress object like the following, you can access http://nginx.minikube.dev/ directly with curl, browser or something.

```
$ minikube start
$ minikube addons enable ingress
$ kubectl create deployment nginx --image=nginx
$ kubectl expose deploy nginx --port=80 --target-port=80
$ cat <<EOL | kubectl apply -f -
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: nginx.minikube.dev
spec:
  rules:
  - host: nginx.minikube.dev
    http:
      paths:
      - backend:
          serviceName: nginx
          servicePort: 80
EOL
$ curl http://nginx.minikube.dev/
```

If you'd like to change the base domain from `minikube.dev`, set the new domain name to the `MINIKUBE_INGRESS_DNS_DOMAIN` environment variable.

```sh
export MINIKUBE_INGRESS_DNS_DOMAIN="minikube.local"
```

## License

These scripts are released under the MIT License.
