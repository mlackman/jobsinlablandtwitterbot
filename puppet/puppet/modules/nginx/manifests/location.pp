define nginx::location($path, $configs) {
  include nginx

  file { "/etc/nginx/applocations/${title}.location":
    mode    => "0644",
    content => template('nginx/location.erb'),
    notify => Service['nginx']
  }
}
