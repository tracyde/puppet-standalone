class scheduledTasks {
  cron {
    "puppet-apply":
      ensure => present,
      command => '/usr/bin/puppet apply --logdest syslog $(puppet config print manifest)',
      user    => 'root',
      minute  => 30;
  }
}

class packages {
  package {
    'augeas': ensure => installed;
    'git':    ensure => installed;
    'tmux':    ensure => installed;
  }
}

class files {
  file {
    "/etc/puppet/hiera.yaml":
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => 644,
      content => '';
  }
  file {
    "/etc/localtime":
      ensure => 'link',
      target => '/usr/share/zoneinfo/US/Eastern',
  }
  file {
    "/root/.forward":
      ensure => present,
      owner  => 'root',
      group  => 'root',
      mode   => 0640,
      content => 'tracyde@gmail.com';
  }
}

class lockDown {
  augeas { 'sshd_config':
    context => '/files/etc/ssh/sshd_config',
    changes => [
      'set PermitRootLogin no',
    ],
  }
}

node default {
  include scheduledTasks
  include files
  include lockDown
  include epel
  include rkhunter
  include packages
  include golang
}
