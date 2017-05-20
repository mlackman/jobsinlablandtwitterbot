include stdlib

package { "python3-virtualenv":
  name   => 'python3-venv',
  ensure => present,
}
package { "python3-pip":
  name   => "python3-pip",
  ensure => present,
}->
exec { "upgrade-pip":
  cwd     => '/',
  path    => ['/usr/bin'],
  command => 'sudo pip3 install --upgrade pip'
}

user { "workinnordictwitter":
  ensure     => present,
  shell      => '/bin/bash',
  home       => '/home/workinnordictwitter',
  managehome => true,
  password   => '*',
}


