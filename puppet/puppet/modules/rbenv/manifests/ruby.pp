define rbenv::ruby($version=$title, $user) {
  include rbenv

  exec { "git clone https://github.com/sstephenson/rbenv.git /home/${user}/.rbenv":
    path    => '/usr/bin',
    user    => $user,
    creates => "/home/${user}/.rbenv",
  }->
  exec { "echo 'export PATH=\"\$HOME/.rbenv/bin:\$PATH\"' >> ~/.bash_profile":
    path    => '/bin',
    user    => $user,
    onlyif  => "test -n `grep -iE \"rbenv\" ~/.bash_profile`"
  }
}
