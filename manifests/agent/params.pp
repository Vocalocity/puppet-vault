# == Class vault::agent::params
#
# This class is meant to be called from vault.
# It sets variables according to platform.
#
class vault::agent::params {
  $user               = 'vault'
  $manage_user        = true
  $group              = 'vault'
  $manage_group       = true
  $service_name       = 'vault-agent'

  # These should always be undef as they are optional settings that
  # should not be configured unless explicitly declared.
  $method = undef
  $sinks  = undef


  $manage_service = true
  $service_enable = true
  $service_ensure = 'running'

  $service_provider = $facts['service_provider']

}
