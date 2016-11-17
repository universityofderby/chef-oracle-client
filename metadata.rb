name 'oracle-client'
maintainer 'Dan Webb, Luke Bradbury'
maintainer_email 'ai@derby.ac.uk'
license 'Apache 2.0'
description 'Installs/Configures oracle-client'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.3.0'
source_url 'https://github.com/universityofderby/chef-oracle-client'
issues_url 'https://github.com/universityofderby/chef-oracle-client/issues'

depends 'ark'
depends 'compat_resource'
depends 'oracle-inventory'
