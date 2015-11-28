node.default['oracle']['client']['tnsnames']['ktst']['host'] = 'k-test-unicon'
node.default['oracle']['client']['tnsnames']['ktst']['port'] = 13_870
node.default['oracle']['client']['tnsnames']['ktst']['service_name'] = 'ktst'

oracle_client '11.2.0.1' do
  ownername 'oracle'
  groupname 'oracle'
  installer_file 'linux.x64_11gR2_client.zip'
end
