require 'serverspec'

set :backend, :exec

describe group('oracle') do
  it { should exist }
end

describe group('dba') do
  it { should exist }
end

describe user('oracle') do
  it { should exist }
  it { should belong_to_group 'oracle' }
  it { should belong_to_group 'dba' }
end

describe file('/tmp/kitchen/cache/oracle-client-11.2.0.1') do
  it { should be_a_directory }
  it { should be_owned_by 'oracle' }
  it { should be_grouped_into 'oracle' }
end

describe file('/tmp/kitchen/cache/oracle-client-11.2.0.1/client-11.rsp') do
  it { should be_a_file }
  it { should be_owned_by 'oracle' }
  it { should be_grouped_into 'oracle' }
  it { should contain 'UNIX_GROUP_NAME=oracle' }
  it { should contain 'INVENTORY_LOCATION=/opt/oracle/inventory' }
  it { should contain 'ORACLE_HOME=' }
  it { should contain 'ORACLE_BASE=' }
end

# TODO: guard
# Oracle Base
describe file('/opt/oracle') do
  it { should be_a_directory }
  it { should be_owned_by 'oracle' }
  it { should be_grouped_into 'oracle' }
end

# Oracle Client Dir
describe file('/opt/oracle/oracle-client-11.2.0.1') do
  it { should be_a_directory }
  it { should be_owned_by 'oracle' }
  it { should be_grouped_into 'oracle' }
end

# Oracle TNS Names
describe file('/opt/oracle/oracle-client-11.2.0.1/network/admin') do
  it { should be_a_directory }
  it { should be_owned_by 'oracle' }
end

describe file('/opt/oracle/oracle-client-11.2.0.1/network/admin/tnsnames.ora') do
  it { should be_a_file }
  it { should be_owned_by 'oracle' }
  it { should be_grouped_into 'oracle' }
  it { should contain 'k-test-unicon' }
  it { should contain '13870' }
  it { should contain 'ktst' }
end

describe file('/opt/oracle/oracle-client-11.2.0.1/network/admin/sqlnet.ora') do
  it { should be_a_file }
  it { should be_owned_by 'oracle' }
  it { should be_grouped_into 'oracle' }
  it { should contain '/opt/oracle' }
  it { should contain 'NAMES.DIRECTORY_PATH= (TNSNAMES, EZCONNECT)' }
end
