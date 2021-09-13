# @summary This class installs snapd and core snap.

# @param package_ensure The state of the snapd package.
# @param service_ensure The state of the snapd service.
# @param service_enable Run the system service on boot.
# @param core_snap_ensure The state of the snap `core`.
class snap (
  String[1]               $package_ensure   = 'installed',
  Stdlib::Ensure::Service $service_ensure   = 'running',
  Boolean                 $service_enable   = true,
  String[1]               $core_snap_ensure = 'installed'
) {
  if $facts['os']['family'] == 'RedHat' {
    class { 'epel': }
  }
  $package_require = $facts['os']['family'] ? {
    'RedHat' => Class['epel'],
    default  => undef,
  }

  package { 'snapd':
    ensure  => $package_ensure,
    require => $package_require,
  }

  service { 'snapd':
    ensure  => $service_ensure,
    enable  => $service_enable,
    require => Package['snapd'],
  }

  package { 'core':
    ensure   => $core_snap_ensure,
    provider => 'snap',
    require  => Service['snapd'],
  }
}
