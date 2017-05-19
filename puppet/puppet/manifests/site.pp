include stdlib

user { "workinnordictwitter":
  ensure     => present,
  shell      => '/bin/bash',
  home       => '/home/workinnordictwitter',
  managehome => true,
  password   => '*',
}


