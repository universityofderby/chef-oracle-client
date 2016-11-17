oracle-client cookbook
======================
[![Stories in Ready](https://badge.waffle.io/universityofderby/chef-oracle-client.png?label=ready&title=Ready)](https://waffle.io/universityofderby/chef-oracle-client)
[![Join the chat at https://gitter.im/universityofderby/chef-oracle-client](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/universityofderby/chef-oracle-client?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Scope
-----
This cookbook is concerned with a full installation of oracle-client. This will give access to oracle-cient, sqlplus etc.
You will need to accept the terms & conditions on the oracle site and download to an on-site artifact store: http://www.oracle.com/technetwork

This cookbook will setup the tnsnames file through the use of node attributes (detailed below).

This cookbook does not set up an oracle-client service.

Requirements
------------
 - Chef 12 or higher
 - oracle-client downloaded to an on-site location.

Platform Support
----------------
The following platforms have been tested with Test Kitchen:
=======

```
|----------------+------------+------------|
|                | 12.1.0.1.0 | 11.2.0.1.0 |
|----------------+------------+------------|
| ubuntu-10.04   |            |            |
|----------------+------------+------------|
| ubuntu-12.04   |            |            |
|----------------+------------+------------|
| ubuntu-14.04   |            |            |
|----------------+------------+------------|
| centos-5       |     X      |      X     |
|----------------+------------+------------|
| centos-6       |     X      |      X     |
|----------------+------------+------------|
```
If your Operating system is not on this list please submit a pull request with an update kitchen file and related tests.

Cookbook Dependencies
---------------------
 - ark
 - resrouce
 - oracle-inventory

Usage
--------
This cookbook uses the common_artifact_repo pattern.

The download URL is worked out from `node.common_artifact_repo` + installer_file
This allows you to have a common artifact store url accross an environment or accross a single application.

To override this pattern simple supply the `installer_url:` in the oracle_client resource.

Place a dependency on the oracle-client cookbook in your cookbook's metadata file
```ruby
depends 'oracle-client', '~> 0.3.0'
```

Then in a recipe:
```ruby
node.default['common_artifact_url'] = 'htttp://artifact.home/software'

oracle_client '11.2.0.1' do
  ownername 'app1'
  groupname 'app_group'
  installer_file 'client-11.2.0.1.zip'
end
```

Add the following before your `oracle_client` resource to set the `tnsnames.ora` file.

```ruby
node.default['oracle']['client']['tnsnames']['ktst']['host'] = 'k-test-unicon'
node.default['oracle']['client']['tnsnames']['ktst']['port'] = 13_870
node.default['oracle']['client']['tnsnames']['ktst']['service_name'] = 'ktst'
```

For more examples see `test/fixtures/cookbooks`

Authors
------
- Dan Webb
- Luke Bradbury
