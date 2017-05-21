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

cron { 'runworkinnordictwitter':
  command => '/home/workinnordictwitter/rss2tweet/run.sh',
  user    => 'workinnordictwitter',
  hour    => ['3-15'],
  minute  => 0,
}
user { "workinnordictwitter":
  ensure     => present,
  shell      => '/bin/bash',
  home       => '/home/workinnordictwitter',
  managehome => true,
  password   => '*',
}


