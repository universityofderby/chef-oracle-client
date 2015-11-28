node.default['oracle']['client']['tnsnames']['ktst']['host'] = 'k-test-unicon'
node.default['oracle']['client']['tnsnames']['ktst']['port'] = 13_870
node.default['oracle']['client']['tnsnames']['ktst']['service_name'] = 'ktst'

oracle_client '12.1.0.2' do
  ownername 'oracle'
  groupname 'oracle'
  installer_file 'linuxamd64_12102_client.zip'
end
