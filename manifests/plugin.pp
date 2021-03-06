#
# == Define: wp::plugin
#
# Enable or disable a Wordpress plugin
#
define wp::plugin
(
    $slug = $title,
    $location = $::wp::location,
    $ensure = enabled,
    $networkwide = false,
    $user = undef
)
{
    include ::wp::cli
    include ::wp::params

    $basecmd = "${::wp::params::wp} plugin ${::wp::params::args}"

    $extra_args = $networkwide ? {
        true  => '--network',
        false => undef,
    }

    Exec {
        cwd => $location,
        require => Class['::wp::cli'],
    }

    case $ensure {
        enabled: {
            exec { "${location} wp install plugin ${slug}":
                command => "${basecmd} install ${slug}",
                unless  => "${basecmd} is-installed ${slug}",
                before  => Exec["${location} wp activate plugin ${slug}"],
                onlyif  => $::wp::params::core_is_installed,
            }
            exec { "${location} wp activate plugin ${slug}":
                command => "${basecmd} ${extra_args} activate ${slug}",
                unless  => "${basecmd} status ${slug}|grep \"Status: Active\"",
                onlyif  => $::wp::params::core_is_installed,
            }
        }
        disabled: {
            exec { "${location} wp deactivate plugin ${slug}":
                command => "${basecmd} ${extra_args} deactivate ${slug}",
                onlyif  => $::wp::params::core_is_installed,
            }
        }
        default: {
            fail("Invalid ensure for ::wp::plugin")
        }
    }
}
