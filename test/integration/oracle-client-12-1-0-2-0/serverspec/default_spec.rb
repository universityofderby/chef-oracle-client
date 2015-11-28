require 'serverspec'

set :backend, :exec

describe user('oracle') do
  it { should exist }
  it { should belong_to_group 'oracle' }
end

describe group('oracle') do
  it { should exist }
end

describe file('/tmp/kitchen/cache/oracle-client-12.1.0.2') do
  it { should be_a_directory }
  it { should be_owned_by 'oracle' }
  it { should be_grouped_into 'oracle' }
end

describe file('/tmp/kitchen/cache/oracle-client-12.1.0.2/client-12.rsp') do
  it { should be_a_file }
  it { should be_owned_by 'oracle' }
  it { should be_grouped_into 'oracle' }
  it { should contain 'UNIX_GROUP_NAME=oracle' }
  it { should contain 'INVENTORY_LOCATION=/opt/oracle/inventory' }
  it { should contain 'ORACLE_HOME=' }
  it { should contain 'ORACLE_BASE=' }
end

# Oracle Base
describe file('/opt/oracle') do
  it { should be_a_directory }
  it { should be_owned_by 'oracle' }
  it { should be_grouped_into 'oracle' }
end

# Oracle Client Dir
describe file('/opt/oracle/oracle-client-12.1.0.2') do
  it { should be_a_directory }
  it { should be_owned_by 'oracle' }
  it { should be_grouped_into 'oracle' }
end

describe file('/opt/oracle/oracle-client-12.1.0.2/bin/sqlplus') do
  it { should be_a_file }
  it { should be_owned_by 'oracle' }
end
