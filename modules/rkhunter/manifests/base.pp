class rkhunter::base {
  package { 'rkhunter':
    ensure => present;
  }

  file {"/etc/rkhunter.conf":
    source => "puppet:///modules/rkhunter/rkhunter.conf",
    require => Package['rkhunter'],
    mode => 0400, owner => root, group => root;
  }
  case $::operatingsystem {
    debian: {
      case $::lsbdistcodename {
        'etch': { info("no need to init the database") }
        default: { include rkhunter::dbinit }
      }
    }
    default: { include rkhunter::dbinit }
  }

  file{'/usr/local/sbin/rkhunter_prelinker':
    source => 'puppet:///modules/rkhunter/prelinker.rb',
    require => File['/etc/rkhunter.conf'],
    owner => root, group => 0, mode => 0700;
  }
}
