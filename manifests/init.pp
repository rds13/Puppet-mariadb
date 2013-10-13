class mariadb (
  # https://github.com/example42/puppi/issues/60
  $version = hiera( 'mysql_version', '' ),
  $package = hiera( 'mysql_package', '' )
) {

  if ( ( $mariadb::version == '' ) or ( $mariadb::version == undef ) ) {
    fail( 'Invalid or no version supplied' )
  }

  $distro_lc  = inline_template("<%= operatingsystem.downcase %>")
  $repo_version = inline_template('<%=@version.to_s.match(/\d+.\d+/)[0] %>')
  $distro_url = "http://mirrors.supportex.net/mariadb/repo/${repo_version}/${distro_lc}"

  if ( ( $::operatingsystem != 'debian' ) and ( $::operatingsystem != 'ubuntu' ) ) {
    fail( "Distro ${::operatingsystem} not supported." )
  }

  apt::source { "mariadb":
    location    => $distro_url,
    release     => $::lsbdistcodename,
    repos       => 'main',
    key         => 'dbart@askmonty.org',
    key_source  => 'http://keyserver.ubuntu.com:11371/pks/lookup?op=get&search=0xCBCB082A1BB943DB',
 }

  exec {'mariadb_aptgetupdate':
    command   => '/usr/bin/apt-get update',
    onlyif    => "/bin/bash -c 'x=\$(apt-cache madison $mariadb::package | \
                  grep \"${distro_url}\" | wc -l); test \"\$x\" = \"0\" -a \"\$x\" != \"\" '"
  }

  Apt::Source['mariadb'] -> Exec['mariadb_aptgetupdate'] -> Package['mysql']

}
