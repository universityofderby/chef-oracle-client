oracle-client cookbook
======================
=======
[![Stories in Ready](https://badge.waffle.io/universityofderby/chef-oracle-client.png?label=ready&title=Ready)](https://waffle.io/universityofderby/chef-oracle-client)
# oracle-client cookbook

Scope
-----
This cookbook is concerned with a full installation of oracle-client. This will give access to oracle-cient, sqlplus etc.
You will need to accept the terms & conditions on the oracle site and download to an on-site artifact store: http://www.oracle.com/technetwork

this cookbook will setup the tnsnames file through the use of node attributes (detailed below).

This cookbook does not set up an oracle-client service.

Requirements
------------
 - Chef 12 or higher
 - oracle-client downloaded to an on-site location.

 Platform Support
 ----------------
 The following platforms have been tested with Test Kitchen:

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
Palace a dependency on the oracle-client cookbook in your cookbook's metadata file
```ruby
depends 'oracle-client', '~> 0.1.0'
```

Then in a recipe:
```ruby
oracle_client '11.2.0.1' do
  ownername 'app1'
  groupname 'app_group'
  installer_url 'http://artifactrepo.company/client-11.2.0.1.zip'
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
