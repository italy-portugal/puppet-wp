#
define wp::command (
  $location,
  $command,
  $refreshonly = false,
) {
  include wp::cli

  exec {"${location} wp ${command}":
    command => "/usr/bin/wp ${command}",
    cwd     => $location,
    user    => $::wp::user,
    require => [ Class['wp::cli'] ],
    onlyif  => '/usr/bin/wp core is-installed',
    refreshonly => $refreshonly,
  }


}
