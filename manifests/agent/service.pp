# == Class vault::agent::service
class vault::agent::service {
  if $::vault::agent::manage_service {
    service { $::vault::agent::service_name:
      ensure   => $::vault::agent::service_ensure,
      enable   => $::vault::agent::service_enable,
      provider => $::vault::agent::service_provider,
    }
  }
}
