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
        onlyif => "${::wp::params::core_is_installed}",
    }

    case $ensure {
        enabled: {
            exec { "wp install plugin ${slug}":
                command => "${basecmd} install ${slug}",
                unless  => "${basecmd} is-installed ${slug}",
                before  => Exec["wp activate plugin ${slug}"],
            }
            exec { "wp activate plugin ${slug}":
                command => "${basecmd} ${extra_args} activate ${slug}",
                unless  => "${basecmd} status ${slug}|grep \"Status: Active\"",
            }
        }
        disabled: {
            exec { "wp deactivate plugin ${slug}":
                command => "${basecmd} ${extra_args} deactivate ${slug}",
            }
        }
        default: {
            fail("Invalid ensure for ::wp::plugin")
        }
    }
}
