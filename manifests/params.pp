# == Class jupyterhub::params
#
# This class is meant to be called from jupyterhub.
# It sets variables according to platform.
#
class jupyterhub::params {
  $ssl_key_path               = undef
  $ssl_cert_path              = undef
  case $::osfamily {
    'Debian': {
      $service_name           = 'jupyterhub'
      $jupyterhub_username    = '_jupyter'
      $jupyterhub_dir         = '/opt/jupyterhub'
      $pyvenv                 = '/opt/jupyterhub/pyvenv'
      $allowed_users          = undef
    }
    'RedHat', 'Amazon': {
      $service_name           = 'jupyterhub'
      $jupyterhub_username    = '_jupyter'
      $jupyterhub_dir         = '/opt/jupyterhub'
      $pyvenv                 = '/opt/jupyterhub/pyvenv'
      $allowed_users          = undef
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
