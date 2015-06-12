class wp::params {
    $user = 'www-data'
    $wp = '/usr/bin/wp'
    $args = '--allow-root --no-color'
    $core_is_installed = "${wp} core ${args} is-installed"
}
