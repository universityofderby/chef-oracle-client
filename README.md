[![Stories in Ready](https://badge.waffle.io/universityofderby/chef-oracle-client.png?label=ready&title=Ready)](https://waffle.io/universityofderby/chef-oracle-client)
# oracle-client cookbook

# Requirements

# Usage

## Node Attributes

## Resource
```
oracle_client '11.2.0.1' do
  ownername 'app1'
  groupname 'app_group'
  installer_url 'http://artifactrepo.company/client-11.2.0.1.zip'
  installer_file 'client-11.2.0.1.zip'
end
```

For more examples see `test/fixtures/cookbooks`

# Author
d.webb@derby.ac.uk
