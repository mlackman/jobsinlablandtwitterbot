include stdlib

package { "python3-virtualenv":
  name   => 'python3-venv',
  ensure => present,
}

user { "workinnordictwitter":
  ensure     => present,
  shell      => '/bin/bash',
  home       => '/home/workinnordictwitter',
  managehome => true,
  password   => '*',
}


