# # encoding: utf-8

# Inspec test for recipe k8s-debian-base::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

packages_installed = ['rsync', 'vim', 'screen', 'iptables', 'libapparmor1', 'libltdl7', 'python-boto', 'python3-boto', 'ncurses-term', 'parted', 'bootlogd', 'cloud-init', 'cloud-utils', 'gdisk', 'sysvinit', 'systemd', 'systemd-sysv', 'htop', 'tcpdump', 'iotop', 'ethtool', 'sysstat', 'aufs-tools', 'curl', 'python-yaml', 'git', 'nfs-common', 'bridge-utils', 'logrotate', 'socat', 'python-apt', 'apt-transport-https', 'unattended-upgrades', 'lvm2', 'btrfs-tools', 'cloud-initramfs-growroot', 'python-pip', 'linux-image-k8s', 'linux-headers-k8s']
packages_removed = ['dkms', 'linux-headers-3.16.0-4-common', 'libgcc-4.8-dev', 'gcc-4.8', 'cpp', 'cpp-4.9']

for pkg in packages_installed
  describe package("#{pkg}") do
    it { should be_installed }
  end
end

for pkg in packages_removed
  describe package("#{pkg}") do
    it { should_not be_installed }
  end
end
