define python::install($version=$title) {
  include python

  exec { "curl -O https://www.python.org/ftp/python/${version}/Python-${version}.tgz":
    cwd     => '/tmp',
    path    => '/usr/bin',
    unless  => "test -e /usr/local/bin/python3",
    creates => "/tmp/Python-${version}.tgz"
  }->
  exec { "tar xf Python-${version}.tgz":
    cwd     => '/tmp',
    path    => '/usr/bin',
    creates => "/tmp/Python-${version}"
  }->
  exec { "configure":
    command => "/tmp/Python-${version}/configure --prefix=/usr/local --enable-shared",
    cwd     => "/tmp/Python-${version}",
    creates => "/tmp/Python-${version}/Makefile",
  }->
  exec { "cd /tmp/Python-${version} && make && make install":
    cwd   => "/tmp/Python-${version}",
    path  => "/usr/bin",
    creates => "/usr/local/bin/python3",
  }->
  exec {"echo /usr/local/lib >> /etc/ld.so.conf.d/local.conf":
    path    => "/usr/bin",
    onlyif  => "test -n `grep -iE \"/usr/local/lib\" /etc/ld.so.conf.d/local.conf`"
  }->
  exec {"ldconfig":
    path => "/usr/sbin",
  }
}

