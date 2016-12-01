#
# Cookbook Name:: k8s-debian-base
# Recipe:: default
#
# Copyright (c) 2016 Patrick McClory, All Rights Reserved.

include_recipe 'apt'
include_recipe 'onerun::packages'

execute 'dkms remove' do
  command 'dkms remove ixgbevf/3.2.2 --all > /tmp/dkms-remove'
  creates '/tmp/dkms-remove'
  user 'root'
end

package 'dkms' do
  action :purge
end

package ['linux-headers-3.16.0-4-common', 'libgcc-4.8-dev', 'gcc-4.8', 'cpp', 'cpp-4.9'] do
  action :remove
end

remote_file '/tmp/docker.deb' do
  source "#{node['docker']['deb_url']}"
  checksum "#{node['docker']['deb_checksum']}"
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

dpkg_package 'docker' do
  source '/tmp/docker.deb'
end

template '/etc/apt/apt.conf.d/20auto-upgrades' do
  source '20auto-upgrades.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

directory '/etc/cloud/cloud.cfg.d/' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  recursive true
  notifies :create, 'template[/etc/cloud/cloud.cfg.d/99_kubernetes.cfg]', :immediately
end

template '/etc/cloud/cloud.cfg.d/99_kubernetes.cfg' do
  source '99_kubernetes.cfg.erb'
  owner 'root'
  group 'root'
  mode '0755'
  action :nothing
end

template '/etc/default/grub' do
  source 'grub.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :run, 'execute[update grub]', :immediately
end

execute 'update grub' do
  command 'update-grub2'
  action :nothing
  user 'root'
  notifies :run, 'execute[apt-get dist-upgrade]', :immediately
end

execute 'apt-get dist-upgrade' do
  command 'apt-get update -y && apt-get dist-upgrade -y'
  ignore_failure true
  action :nothing
end

execute 'apt-get autoremove' do
  command 'apt-get autoremove'
  ignore_failure true
end

file '/etc/machine-id' do
  action :delete
end

directory '/etc/systemd/system/debian-fixup.service.d/' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  recursive true
  notifies :create, 'template[/etc/systemd/system/debian-fixup.service.d/10-machineid.conf]', :immediately
end

template '/etc/systemd/system/debian-fixup.service.d/10-machineid.conf' do
   source '10-machineid.conf.erb'
   owner 'root'
   group 'root'
   mode '0755'
   action :nothing
end

execute 'install systemd-journal' do
  command 'install -d -g systemd-journal /var/log/journal > /tmp/systemd-journal'
  creates '/tmp/systemd-journal'
  user 'root'
end

execute 'setfacl journal' do
  command 'setfacl -R -nm g:adm:rx,d:g:adm:rx /var/log/journal > /tmp/setfacl-journal'
  creates '/tmp/setfacl-journal'
  user 'root'
end
