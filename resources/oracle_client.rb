#
# Cookbook Name:: oracle-client
# Resource:: oralcle_client
#
# Copyright (C) 2015 University of Derby
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
resource_name :oracle_client

property :version, String, name_property: true
property :groupname, String, default: 'oracle'
property :ownername, String, default: 'oracle'
property :cache_path, String, default: lazy { ::File.join(Chef::Config[:file_cache_path], "oracle-client-#{version}") }
property :silent_cookbook, String, default: 'oracle-client'
property :silent_file, String, default: lazy {
  if Gem::Version.new(version) < Gem::Version.new('12.1.0.1.0')
    'client-11.rsp'
  else
    'client-12.rsp'
  end
}
property :silent_path, String, default: lazy { ::File.join(cache_path, silent_file) }
property :installer_file, String, default: 'linuxamd64_12102_client.zip'
property :installer_path, String, default: lazy { ::File.join(cache_path, version) }
property :installer_url, String, default: lazy { ::File.join(node['common_artifact_repo'], "/oracle/client/#{version}/#{installer_file}") }
property :locale, String, default: 'en_GB'
property :inventory_location, String, default: lazy { node['oracle']['inventory']['location'] }
property :client_home, String, default: lazy { ::File.join(oracle_base, "oracle-client-#{version}") }
property :oracle_base, String, default: '/opt/oracle'
property :admin_dir, String, default: lazy { ::File.join(client_home, 'network', 'admin') }
property :tnsnames, String, default: lazy { ::File.join(admin_dir, 'tnsnames.ora') }
property :tnsnames_cookbook, String, default: 'oracle-client'
property :sqlnet, String, default: lazy { ::File.join(admin_dir, 'sqlnet.ora') }
property :sqlnet_cookbook, String, default: 'oracle-client'
property :override_temp, TrueClass

default_action :create

action :create do
  group new_resource.groupname

  user new_resource.ownername do
    group new_resource.groupname
  end

  group new_resource.groupname do
    append true
    members new_resource.ownername
  end

  ## For ARK
  package 'unzip' do
  end

  package 'rsync' do
  end

  # Install the correct set of client prerequisite packages
  if Gem::Version.new(new_resource.version) < Gem::Version.new('12.1.0.1.0')
    # Client 11
    client11_packages = %w(make binutils gcc libaio libaio-devel libstdc++ elfutils-libelf-devel sysstat libgcc libstdc++-devel unixODBC-devel unixODBC glibc elfutils-libelf glibc-common glibc-devel gcc-c++ compat-libstdc++-33 expat sysstat elfutils-libelf-devel)
    client11_packages.each do |p|
      package p
    end

    yum_package 'glibc' do
      arch 'i686'
    end
  else
    # Client 12 Packages
    client12_packages = %w(binutils compat-libcap1 compat-libstdc++-33.i686 compat-libstdc++-33.x86_64 gcc gcc-c++ glibc.i686 glibc.x86_64 glibc-devel.i686 glibc-devel.x86_64 ksh libaio.i686 libaio.x86_64 libaio-devel.i686 libaio-devel.x86_64 libgcc.i686 libgcc.x86_64 libstdc++.i686 libstdc++.x86_64 libstdc++-devel.i686 libstdc++-devel.x86_64 libXi.i686 libXi libXtst.i686 libXtst.x86_64 libXext.i686 libXext.x86_64 libX11.i686 libX11.x86_64 libXau.i686 libXau.x86_64 libxcb.i686 libxcb.x86_64 make sysstat)
    client12_packages.each do |p|
      package p
    end
  end
  # compat-libcap
  # compat-libstdc++-33

  include_recipe 'oracle-inventory'
  # Make sure the installer user is in the same group as the inventory
  group node['oracle']['inventory']['group'] do
    append true
    members new_resource.ownername
  end

  directory new_resource.cache_path do
    group new_resource.groupname
    owner new_resource.ownername
    recursive true
  end

  directory new_resource.oracle_base do
    group new_resource.groupname
    owner new_resource.ownername
    recursive true
  end

  directory new_resource.client_home do
    group new_resource.groupname
    owner new_resource.ownername
  end

  template new_resource.silent_path do
    cookbook new_resource.silent_cookbook
    group new_resource.groupname
    owner new_resource.ownername
    source new_resource.silent_file + '.erb'
    variables(
      groupname: new_resource.groupname,
      inventory_location: new_resource.inventory_location,
      client_home: new_resource.client_home,
      oracle_base: new_resource.oracle_base,
      locale: new_resource.locale
    )
  end

  ark 'oracle-client' do
    url new_resource.installer_url
    mode 02775
    version new_resource.version
    owner new_resource.ownername
    path new_resource.cache_path
    action :put
  end

  execute 'install' do
    cwd new_resource.cache_path
    user new_resource.ownername
    command "DISPLAY= #{new_resource.cache_path}/oracle-client/runInstaller -silent -waitforcompletion -ignoreprereq -noconfig -responseFile #{new_resource.silent_path} -ignoreSysprereqs -invPtrLoc  /etc/oraInst.loc"
    not_if { ::File.exist? ::File.join(new_resource.client_home, 'bin/sqlplus') }
	env ({'TEMP' => "#{new_resource.cache_path}"}) unless new_resource.override_temp.nil?
    returns [0, 253]
  end

  template new_resource.tnsnames do
    cookbook new_resource.tnsnames_cookbook
    mode '0755'
    owner new_resource.ownername
    group new_resource.groupname
    source 'new_resource.tnsnames.ora.erb'
    variables db: node['oracle']['client']['new_resource.tnsnames']
    only_if { node['oracle']['client']['new_resource.tnsnames'] }
  end

  template new_resource.sqlnet do
    cookbook new_resource.sqlnet_cookbook
    mode '0755'
    owner new_resource.ownername
    group new_resource.groupname
    source 'sqlnet.ora.erb'
    variables oracle_base: new_resource.oracle_base
  end
end
