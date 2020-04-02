# InSpec test for recipe clough_systems_ca::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

def certificate_path
  case os.family
  when 'debian'
      '/usr/local/share/ca-certificates'
  when 'suse'
      '/etc/pki/trust/anchors/'
  else # probably RHEL
      '/etc/pki/ca-trust/source/anchors'
  end
end

describe file("#{certificate_path}/new_ca.crt") do
  it { should exist }
  it { should be_file }
end
describe file("#{certificate_path}/old_ca.crt") do
  it { should_not exist }
end

if os.family == 'debian'
  describe file('/etc/ssl/certs/new_ca.pem') do
    it { should exist }
    it { should be_symlink }
    its('shallow_link_path') { should eq "/usr/local/share/ca-certificates/new_ca.crt"}
  end
  describe file('/etc/ssl/certs/old_ca.pem') do
    it { should_not exist }
  end
end
