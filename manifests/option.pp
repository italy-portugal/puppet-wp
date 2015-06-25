define wp::option
(
    $location = $::wp::location,
    $key = $title,
    $value = undef,
    $ensure = present
)
{
    include ::wp::params

    $basecmd = "${::wp::params::wp} option ${::wp::params::args}"

    Exec {
        cwd => $location,
        require => Class['::wp::cli'],
        onlyif => "${::wp::params::core_is_installed}",
    }

    case $ensure {
        equal: {
            exec { "wp option update ${key} ${value}":
                command => "${basecmd} update ${key} \"${value}\""
            }
        }
        absent: {
            exec { "wp option delete ${key}":
                command => "${basecmd} delete ${key}",
            }
        }
        default: {
            fail('Invalid option operation')
        }
    }
}
