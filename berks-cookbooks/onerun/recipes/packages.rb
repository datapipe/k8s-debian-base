
# these packages are generally useful
package ['rsync', 'vim', 'screen']

# needed for docker
package ['iptables', 'libapparmor1', 'libltdl7']

# packages for the aws image...
package ['python-boto', 'python3-boto', 'ncurses-term', 'parted', 'bootlogd', 'cloud-init', 'cloud-utils', 'gdisk', 'sysvinit', 'systemd', 'systemd-sysv', 'htop', 'tcpdump', 'iotop', 'ethtool', 'sysstat' ]

package ['aufs-tools', 'curl', 'python-yaml', 'git', 'nfs-common', 'bridge-utils', 'logrotate', 'socat', 'python-apt', 'apt-transport-https', 'unattended-upgrades', 'lvm2', 'btrfs-tools']

package ['cloud-initramfs-growroot', 'python-pip']

remote_file '/tmp/kopeio.gpg.key' do
  source 'https://dist-kope-io.s3.amazonaws.com/apt/kopeio.gpg.key'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  notifies :run, 'execute[apt-key add kopeio]', :immediately
end

execute 'apt-key add kopeio' do
  command 'apt-key add /tmp/kopeio.gpg.key'
  user 'root'
  notifies :create, 'template[/etc/apt/sources.list.d/kopeio.list]', :immediately
end

template '/etc/apt/sources.list.d/kopeio.list' do
  source 'kopeio.list.erb'
  owner 'root'
  group 'root'
  mode '0755'
  notifies :run, 'execute[apt-get-update]', :immediately
  action :nothing
end

execute "apt-get-update" do
  command "apt-get update -y"
  ignore_failure true
  action :nothing
end

execute 'install awscli' do
  command 'pip install awscli'
  user 'root'
end

package ['linux-image-k8s', 'linux-headers-k8s']
