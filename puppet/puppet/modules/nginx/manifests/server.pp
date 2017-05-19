define nginx::server($host=$title,$port=80, $docroot, $filename) {
  include nginx

  file { "/etc/nginx/conf.d/${filename}":
    ensure => file,
    mode   => "644",
    content => template("nginx/server.conf.erb"),
  }
  ~>
  Service['nginx']
}

