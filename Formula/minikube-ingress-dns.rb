class MinikubeIngressDns < Formula
  desc "Configure and restart dnsmasq automatically for Kubernetes Ingress LB on minikube"
  homepage "https://github.com/superbrothers/minikube-ingress-dns"
  head "https://github.com/superbrothers/minikube-ingress-dns.git", branch: "master"

  def install
    (prefix/"etc/minikube-ingress-dns").install %w(
      minikube-ingress-dns-macos
      minikube-ingress-dns-ubuntu16
      minikube-ingress-dns-ubuntu14
      common.sh
    )
  end

  def caveats; <<-EOS.undent
    Add the following line to your ~/.bash_profile:
    # macOS
    alias minikube=#{etc}/minikube-ingress-dns/minikube-ingress-dns-macos
    # Ubuntu 16.04 LTS
    alias minikube=#{etc}/minikube-ingress-dns/minikube-ingress-dns-ubuntu16
    # Ubuntu 14.04 LTS
    alias minikube=#{etc}/minikube-ingress-dns/minikube-ingress-dns-ubuntu14
    EOS
  end
end
# vim: set fenc=utf-8 :
