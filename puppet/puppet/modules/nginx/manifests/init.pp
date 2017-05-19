class nginx {
  file {'/etc/yum.repos.d/nginx.repo':
    mode     => 644,
    content  => template('nginx/nginx.repo.erb'),
    before   => Package['nginx'],
  }

  package { 'nginx':
    ensure => present,
  }
  ->
  file { '/etc/nginx/sites-available/default':
    ensure => absent,
  }
  ->
  file { '/etc/nginx/sites-enabled/default':
    ensure => absent,
  }->
  file { '/etc/nginx/applocations/':
    ensure => directory,
  }

  service { 'nginx':
    ensure => running,
    enable => true,
  }
}
