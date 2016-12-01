# # encoding: utf-8

# Inspec test for recipe k8s-debian-base::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

unless os.windows?
  describe user('root') do
    it { should exist }
    skip 'This is an example test, replace with your own test.'
  end
end

describe file('/etc/systemd/system/debian-fixup.service.d/10-machineid.conf') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_mode 755 }
  it { should be_grouped_into 'root' }
end

describe file('/etc/grub/default') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_mode 644 }
  it { should be_grouped_into 'root' }
end

describe file('/etc/cloud/cloud.cfg.d/99_kubernetes.cfg') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_mode 755 }
  it { should be_grouped_into 'root' }
end

describe file('/etc/apt/apt.conf.d/20auto-upgrades') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_mode 755 }
  it { should be_grouped_into 'root' }
end

describe service('docker') do
  it { should be_enabled }
end

describe file('/etc/machine-id') do
  it { should_not exist }
end

describe file('/tmp/systemd-journal') do
  it { should exist }
end

describe file('/tmp/setfacl-journal') do
  it { should exist }
end

describe file('/tmp/dkms-remove') do
  it { should exist }
end
