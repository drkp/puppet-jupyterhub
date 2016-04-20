# == Class jupyterhub::install
#
# This class is called from jupyterhub for install.
#
class jupyterhub::install {

  user { $::jupyterhub::jupyterhub_username:
    ensure => present,
    password => '!!',
    home => '/var/lib/jupyterhub',
    manage_home => true
  }
  ->
  file { $::jupyterhub::jupyterhub_dir:
    ensure => directory,
    owner   => $::jupyterhub::jupyterhub_username,
  }
  ->
  package { 'python3-venv': }
  ->
  python::pyvenv { $::jupyterhub::pyvenv:
    ensure  => present,
    version => 'system',
    owner   => $::jupyterhub::jupyterhub_username,
  }

  python::pip { 'jupyter':
    pkgname    => 'jupyter',
    virtualenv => "$::jupyterhub::pyvenv",
    owner      => $::jupyterhub::jupyterhub_username,
    require    => Python::Pyvenv[ $::jupyterhub::pyvenv ],
  }

  python::pip { 'jupyterhub':
    pkgname    => 'jupyterhub',
    virtualenv => "$::jupyterhub::pyvenv",
    owner      => $::jupyterhub::jupyterhub_username,
    require    => Python::Pyvenv[ $::jupyterhub::pyvenv ],
  }

  python::pip { 'sudospawner':
    pkgname    => 'git+https://github.com/jupyter/sudospawner',
    virtualenv => "$::jupyterhub::pyvenv",
    owner      => $::jupyterhub::jupyterhub_username,
    require    => Python::Pyvenv[ $::jupyterhub::pyvenv ],
  }

  ensure_packages(['nodejs-legacy'])

  class { 'nodejs': }
  ->
  package { 'configurable-http-proxy':
    ensure   => 'present',
    provider => 'npm',
  }
}
