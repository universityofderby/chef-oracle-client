[![Stories in Ready](https://badge.waffle.io/universityofderby/chef-oracle-client.png?label=ready&title=Ready)](https://waffle.io/universityofderby/chef-oracle-client)
# oracle-client cookbook

[![Join the chat at https://gitter.im/universityofderby/chef-oracle-client](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/universityofderby/chef-oracle-client?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

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
