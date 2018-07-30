# Class: vault::agent
# ===========================
#
# Full description of class vault::agent here.
#
# Parameters
# ----------
#
# * `user`
#   Customise the user vault runs as, will also create the user unless `manage_user` is false.
#
# * `manage_user`
#   Whether or not the module should create the user.
#
# * `group`
#   Customise the group vault runs as, will also create the user unless `manage_group` is false.
#
# * `manage_group`
#   Whether or not the module should create the group.
#
# * `service_name`
#   Customise the name of the system service
#
# * `service_provider`
#   Customise the name of the system service provider; this
#   also controls the init configuration files that are installed.
#
# * `service_options`
#   Extra argument to pass to `vault server`, as per:
#   `vault server --help`

# * `manage_service`
#   Instruct puppet to manage service or not
#
class vault::agent (
  $user                                = $::vault::agent::params::user,
  $manage_user                         = $::vault::agent::params::manage_user,
  $group                               = $::vault::agent::params::group,
  $manage_group                        = $::vault::agent::params::manage_group,
  $service_name                        = $::vault::agent::params::service_name,
  $service_enable                      = $::vault::agent::params::service_enable,
  $service_ensure                      = $::vault::agent::params::service_ensure,
  $service_provider                    = $::vault::agent::params::service_provider,
  $manage_service                      = $::vault::agent::params::manage_service,
  $manage_service_file                 = $::vault::agent::params::manage_service_file,
  Hash $method                         = $::vault::agent::params::method,
  [Hash] $sinks                        = $::vault::agent::params::sinks,
  $service_options                     = '',
) inherits ::vault::agent::params {

  require ::vault

  contain ::vault::agent::config
  contain ::vault::agent::service

  Class['vault::agent::config'] ~> Class['vault::agent::service']

}
