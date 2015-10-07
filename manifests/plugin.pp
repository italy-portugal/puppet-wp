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
    'present': {
      $command = "install ${slug}"
      $unless = "/usr/bin/wp plugin is-installed${slug}"
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

  exec { "${location} plugin ${slug} ${ensure}":
    command => '/usr/bin/wp $args',
    unless  => $unless,
    onlyif  => [$onlyif,'/usr/bin/wp core is-installed'],
  }
}
