# == Class jupyterhub::install
#
# This class is called from jupyterhub for install.
#
class jupyterhub::install {
  require ::python
  require ::nodejs

  user { $::jupyterhub::jupyterhub_username:
    ensure => present,
    password => '!!',
    home => $::jupyterhub::jupyterhub_dir,
    managehome => true
  }
  ->
  file { $::jupyterhub::jupyterhub_dir:
    ensure => directory,
    owner   => $::jupyterhub::jupyterhub_username,
  }
  ->
  python::pyvenv { $::jupyterhub::pyvenv:
    ensure  => present,
    version => '3.5',
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

    package { 'configurable-http-proxy':
    ensure   => 'present',
      provider => 'npm',
      require => Class["nodejs"]
  }
}
