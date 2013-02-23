
class scheduledTasks {
  cron {
    "puppet-apply":
      ensure => present,
      command => '/usr/bin/puppet apply ${puppet config print manifest)',
      user    => 'root',
      minute  => 30;
  }
}

class packages {
  package {
    'augeas': ensure => installed;
    'git':    ensure => installed;
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
  include packages
  include lockDown
}
