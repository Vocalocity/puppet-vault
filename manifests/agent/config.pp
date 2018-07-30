# == Class vault::agent::config
#
# This class is called from vault for service config.
#
class vault::agent::config {

  $agent_config_hash = delete_undef_values({
    'pid_file'  => $::vault::agent::pid_file,
    'auto_auth' => {
      'method' => $::vault::agent::method,
      'sink'   => $::vault::agent::sinks,
    }
  })

  file { "${::vault::config_dir}/agent-config.json":
    content => to_json_pretty($agent_config_hash),
    owner   => $::vault::agent::user,
    group   => $::vault::agent::group,
  }

  # If nothing is specified for manage_service_file, defaults will be used
  # depending on the install_method.
  # If a value is passed, it will be interpretted as a boolean.
  if $::vault::agent::manage_service_file == undef {
    case $::vault::install_method {
      'archive': { $real_manage_service_file = true  }
      'repo':    { $real_manage_service_file = false }
      default:   { $real_manage_service_file = false }
    }
  } else {
    validate_bool($::vault::agent::manage_service_file)
    $real_manage_service_file = $::vault::agent::manage_service_file
  }


  if $real_manage_service_file {
    case $::vault::service_provider {
      'upstart': {
        file { '/etc/init/vault-agent.conf':
          ensure  => file,
          mode    => '0444',
          owner   => 'root',
          group   => 'root',
          content => template('vault/vault-agent.upstart.erb'),
        }
        file { '/etc/init.d/vault-agent':
          ensure => link,
          target => '/lib/init/upstart-job',
          owner  => 'root',
          group  => 'root',
          mode   => '0755',
        }
      }
      'systemd': {
        ::systemd::unit_file{'vault-agent.service':
          content => template('vault/vault-agent.systemd.erb'),
        }
      }
      /(redhat|sysv|init)/: {
        file { '/etc/init.d/vault-agent':
          ensure  => file,
          owner   => 'root',
          group   => 'root',
          mode    => '0755',
          content => template('vault/vault-agent.initd.erb'),
        }
      }
      default: {
        fail("vault::service_provider '${::vault::service_provider}' is not valid")
      }
    }
  }
}
