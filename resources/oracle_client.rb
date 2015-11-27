resource_name :oracle_client

property :version, String, name_property: true
property :groupname, String, default: { 'oracle' }
property :ownername, String, default: { 'oracle' }
property :cache_path, String, default: lazy { ::File.join(Chef::Config[:file_cache_path], "oracle-client-#{version}") }
property :silent_file, String, default: lazy{
    if Gem::Version.new(version) < Gem::Version.new('12.1.0.1.0')
      'client-11.rsp'
    else
      'client-12.rsp'
    end
}
property :silent_path, String, default: { ::File.join(cache_path, silent_file) }
property :installer_file, String, default: { 'V38499-01.zip' }
property :installer_path, String, default: { ::File.join(cache_path, version) }
property :installer_url, String, default: lazy { ::File.join(node['common_artifact_repo'], "/oracle/client/#{version}/#{installer_file}") }
property :locale, String, default: { 'en_GB' }
property :inventory_location, String, default: { node['oracle']['inventory']['location'] }
property :client_home, String, default: { ::File.join(oracle_base, "oracle-client-#{version}") }
property :oracle_base, String, default: { '/opt/oracle' }
property :admin_dir, String, default: { File.join(client_home, 'network', 'admin') }
property :tnsnames, String, default: { File.join(admin_dir, 'tnsnames.ora') }
property :sqlnet, String, default { File.join(admin_dir, 'sqlnet.ora') }

action :create do
  group groupname

  user ownername do
    group groupname
  end

  group groupname do
    append true
    members ownername
  end

  ## For ARK
  package 'unzip' do
  end

  package 'rsync' do
  end

  # Install the correct set of client prerequisite packages
  if Gem::Version.new(version) < Gem::Version.new('12.1.0.1.0')
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
    client12_packages = %w(binutils  compat-libstdc++-33 gcc gcc-c++ glibc glibc glibc-devel glibc-devel ksh libgcc libgcc libstdc++ libstdc++ libstdc++ libstdc++ libaio libaio libaio-devel libaio-devel libXext libXext libXtst libXtst libX11 libX11 libXau libXau libxcb libxcb libXi libXi make sysstat)
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
    members ownername
  end

  directory cache_path do
    group groupname
    owner ownername
    recursive true
  end

  directory oracle_base do
    group groupname
    owner ownername
    recursive true
  end

  directory client_home do
    group groupname
    owner ownername
  end

  template silent_path do
    group groupname
    owner ownername
    source silent_file + '.erb'
    cookbook 'oracle-client'
    variables(
      groupname: groupname,
      inventory_location: inventory_location,
      client_home: client_home,
      oracle_base: oracle_base,
      locale: locale
    )
  end

  ark 'oracle-client' do
    url installer_url
    mode 02775
    version version
    owner ownername
    path cache_path
    action :put
  end

  execute 'install' do
    cwd cache_path
    user ownername
    command "DISPLAY= #{cache_path}/oracle-client/runInstaller -silent -waitforcompletion -ignoreprereq -noconfig -responseFile #{silent_path} -ignoreSysprereqs -invPtrLoc  /etc/oraInst.loc"
    not_if { ::File.exist? ::File.join(client_home, 'bin/sqlplus') }
    returns [0, 253]
  end

  template tnsnames do
    mode 00755
    owner ownername
    group groupname
    source 'tnsnames.ora.erb'
    variables db: node['oracle']['client']['tnsnames']
    only_if { node['oracle']['client']['tnsnames'] }
    cookbook 'oracle-client'
  end

  template sqlnet do
    mode 00755
    owner ownername
    group groupname
    source 'sqlnet.ora.erb'
    cookbook 'oracle-client'
    variables oracle_base: oracle_base
  end
end
