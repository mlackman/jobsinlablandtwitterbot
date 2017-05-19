class build_essential {
  package {['zlib', 'zlib-devel', 'gcc-c++', 'patch', 'readline', 'readline-devel',
            'libyaml-devel', 'libffi-devel', 'openssl-devel', 'make', 'bzip2', 'bzip2-devel',
            'autoconf', 'automake', 'libtool', 'bison', 'curl', 'sqlite-devel', 'ncurses-devel',
            'tk-devel', 'gdbm-devel', 'libpcap-devel', 'xz-devel', 'git']:
    ensure => present,
  }
}
