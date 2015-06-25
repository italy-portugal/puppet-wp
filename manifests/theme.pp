#
# == Define: wp::theme
#
# Activate a Wordpress theme
#
define wp::theme
(
    $location = $::wp::location,
    $ensure = enabled
)
{
    include ::wp::cli
    include ::wp::params

    $basecmd = "${::wp::params::wp} theme ${::wp::params::args}"

    Exec {
        cwd => $location,
        require => Class['::wp::cli'],
        onlyif => "${::wp::params::core_is_installed}",
    }

    case $ensure {
        'enabled': {
            exec { "wp theme activate ${title}":
                command => "${basecmd} activate ${title}",
                onlyif  => "${basecmd} is-installed ${title}",
            }
        }
        default: {
            fail('Invalid ensure for ::wp::theme')
        }
    }
}
