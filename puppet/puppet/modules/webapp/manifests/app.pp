define webapp::app (
  $nginx_path,
  $port,
  $python_version,
  $user,
  $uwsgi_module
) {
  include webapp
  include pyenv

  $app_path = "/srv/${title}"

  file { "${app_path}":
    ensure   => directory,
    mode     => "644",
    owner    => $user,
    require  => User[$user]
  }
  if ! defined(Pyenv::Install["${user}"]) {
    pyenv::install { "${user}":
      rc  => '.bash_profile'
    }
  }

  if ! defined(Pyenv::Compile["${python_version} ${user}"]) {
    pyenv::compile { "${python_version} ${user}":
      user    => $user,
      python  => $python_version,
      global  => false,
      require => Pyenv::Install[$user]
    }
  }

  $virtual_env_name = "${python_version}_${title}"
  $path = "/home/${user}/.pyenv/versions/${virtual_env_name}"

  pyenv::virtualenv { "${virtual_env_name}":
    user                  => $user,
    python_source_version => $python_version,
    require               => Pyenv::Compile["${python_version} ${user}"],
  }->
  pyenv::local { "${virtual_env_name}":
    user => $user,
    path => $app_path
  }->
  pyenv::pip { "uwsgi for ${virtual_env_name}":
    virtual_env_name => $virtual_env_name,
    user             => $user,
    package          => "uwsgi",
  }

  nginx::location { "${title}":
    path    => $nginx_path,
    configs => [
      "include uwsgi_params;",
      "uwsgi_pass unix:/tmp/${title}.sock;"
    ]
  }

  #
  # systemd unit file
  #
  # bin_path should come from pyenv::virtualenv resource!!!
  file { "/etc/systemd/system/${title}.service":
    ensure    => present,
    content   => template('webapp/app_service.erb'),
  }

  #
  # UWSGI ini file
  #
  file { "${app_path}/${title}.ini":
    ensure    => present,
    content   => template("webapp/uwsgi.ini"),
  }
}

