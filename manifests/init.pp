class mariadb (
  $distro_code_name    = $::lsbdistcodename,
  $distro              = $::operatingsystem,
  $mariadb_version     = 10.0,

  $root_password       = undef,
  $my_class            = undef,
  $source              = undef,
  $source_dir          = undef,
  $source_dir_purge    = undef,
  $template            = undef,
  $service_autorestart = undef,
  $options             = undef,
  $absent              = undef,
  $disable             = undef,
  $disableboot         = undef,
  $monitor             = undef,
  $monitor_tool        = undef,
  $monitor_target      = undef,
  $puppi               = undef,
  $puppi_helper        = undef,
  $firewall            = undef,
  $firewall_tool       = undef,
  $firewall_src        = undef,
  $firewall_dst        = undef,
  $debug               = undef,
  $audit_only          = undef,
  $service             = undef,
  $service_status      = undef,
  $process             = undef,
  $process_args        = undef,
  $process_user        = undef,
  $config_dir          = undef,
  $config_file         = undef,
  $config_file_mode    = undef,
  $config_file_owner   = undef,
  $config_file_group   = undef,
  $config_file_init    = undef,
  $pid_file            = undef,
  $data_dir            = undef,
  $log_dir             = undef,
  $log_file            = undef,
  $port                = undef,
  $protocol            = undef,
  ) {

  $distro_lc    = inline_template("<%= distro.downcase %>")
  $distro_url = "http://mirrors.supportex.net/mariadb/repo/$mariadb_version/$distro_lc"
  $package   = "mariadb-server-$mariadb_version"

  if ( ( $distro != 'debian' ) and ( $distro != 'ubuntu' ) ) {
    raise Puppet::ParseError, "Distro not supported."
  }

  apt::repository { "mariadb":
    url       => $distro_url,
    distro    => $distro_code_name,
    repository=> 'main',
    key       => 'dbart@askmonty.org',
    key_url   => '"http://keyserver.ubuntu.com:11371/pks/lookup?op=get&search=0xCBCB082A1BB943DB"',
 }

  exec {'mariadb_aptgetupdate':
    command   => 'apt-get update',
    onlyif    => "/bin/bash -c 'x=\$(apt-cache madison ${package} | \
                  grep \"${distro_url}\" | wc -l); test \"\$x\" = \"0\" -a \"\$x\" != \"\" '"
  }

  class { 'mysql' :
    root_password           => $root_password,
    my_class                => $my_class,
    source                  => $source,
    source_dir              => $source_dir,
    source_dir_purge        => $source_dir_purge,
    template                => $template,
    service_autorestart     => $service_autorestart,
    options                 => $options,
    absent                  => $absent,
    disable                 => $disable,
    disableboot             => $disableboot,
    monitor                 => $monitor,
    monitor_tool            => $monitor_tool,
    monitor_target          => $monitor_target,
    puppi                   => $puppi,
    puppi_helper            => $puppi_helper,
    firewall                => $firewall,
    firewall_tool           => $firewall_tool,
    firewall_src            => $firewall_src,
    firewall_dst            => $firewall_dst,
    debug                   => $debug,
    audit_only              => $audit_only,
    package                 => $package,
    service                 => $service,
    service_status          => $service_status,
    process                 => $process,
    process_args            => $process_args,
    process_user            => $process_user,
    config_dir              => $config_dir,
    config_file             => $config_file,
    config_file_mode        => $config_file_mode,
    config_file_owner       => $config_file_owner,
    config_file_group       => $config_file_group,
    config_file_init        => $config_file_init,
    pid_file                => $pid_file,
    data_dir                => $data_dir,
    log_dir                 => $log_dir,
    log_file                => $log_file,
    port                    => $port,
    protocol                => $protocol,
  }

  Apt::Repository['mariadb'] -> Exec['mariadb_aptgetupdate'] -> Class['mysql']


}
