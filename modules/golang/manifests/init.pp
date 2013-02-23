
class golang($version = '1.0.3') {

  $golang_archive = "go${version}.linux-amd64.tar.gz"
  $golang_binary_archive = "http://go.googlecode.com/files/${golang_archive}"

  file {
    '/home/golang':
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0700';
  }

  file { '/etc/profile.d/golang.sh':
    ensure  => present,
    content => 'export PATH=$PATH:/usr/local/go/bin',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { '/etc/profile.d/gopath.sh':
    ensure  => present,
    content => 'export GOPATH=$HOME/mygo; export PATH=$GOPATH/bin',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  exec { 'download-golang':
    path     => '/bin:/usr/bin:/usr/local/bin',
    cwd      => '/home/golang',
    command  => "wget ${golang_binary_archive} -O ${golang_archive}",
    creates  => "/home/golang/${golang_archive}",
    notify   => Exec['install-golang'],
    require  => File['/home/golang'],
  }

  exec { 'remove-golang':
    path     => '/bin:/usr/bin:/usr/local/bin',
    cwd      => '/usr/local',
    command  => 'rm -r ./go',
    refreshonly => true,
  }

  exec { 'install-golang':
    path     => '/bin:/usr/bin:/usr/local/bin',
    cwd      => '/home/golang',
    command  => "tar -C /usr/local -xzf ${golang_archive}",
    require  => [ Exec['download-golang'], Exec['remove-golang'] ],
    refreshonly => true,
  }

}
