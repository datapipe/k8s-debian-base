name 'onerun'
maintainer 'Patrick McClory'
maintainer_email 'pmcclory@datapipe.com'
license 'ISC'
description 'Debian base image for deploying kubernetes on AWS via kube-deploy'
long_description 'Image build for Debian Jesse + Docker + Kubernetes + updates.'
version '0.1.0'
issues_url 'https://github.com/datapipe/k8s-debian-base/issues'
source_url 'https://github.com/datapipe/k8s-debian-base'

%w{ apt docker }.each do |cookbook|
  depends cookbook
end

supports 'debian'
