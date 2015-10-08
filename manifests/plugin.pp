#
define wp::plugin (
  $location,
  $slug = $title,
  $ensure = 'enabled',
  $networkwide = false
) {
  include wp::cli

  case $ensure {
    'enabled': {
      $command = "install ${slug} --activate"
      $unless = "/usr/bin/wp plugin is-installed ${slug}"
    }
    'disabled': {
      $command = "deactivate ${slug}"
      $onlyif = "/usr/bin/wp plugin is-installed ${slug}"
    }
    'purged': {
      $command = "delete ${slug}"
      $onlyif = "/usr/bin/wp plugin is-installed ${slug}"
    }
    default: {
      fail('Invalid ensure for wp::plugin')
    }
  }

  if $networkwide {
    $args = "plugin ${command} --network"
  }
  else {
    $args = "plugin ${command}"
  }

if $unless {
  exec { "${location} plugin ${slug} ${ensure}":
    command => '/usr/bin/wp $args',
    unless  => $unless,
    onlyif  => '/usr/bin/wp core is-installed',
  }
} elsif $onlyif {
  exec { "${location} plugin ${slug} ${ensure}":
    command => '/usr/bin/wp $args',
    onlyif  => [$onlyif,'/usr/bin/wp core is-installed'],
  }
}

}
