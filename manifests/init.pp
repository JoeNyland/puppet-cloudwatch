# Class: cloudwatch
# ===========================
#
# Installs AWS Cloudwatch Monitoring Scripts and sets up a cron entry to push
# monitoring information to Cloudwatch every minute.
#
# Read more about AWS Cloudwatch Monitoring Scripts:
#   http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/mon-scripts.html
#
# Authors
# -------
#
# Joe Nyland <contact@joenyland.me>
#
# Copyright
# ---------
#
# Copyright 2016 Joe Nyland, unless otherwise noted.
#
class cloudwatch {

  # Establish which packages are needed, depending on the OS family
  case $operatingsystem {
    /(RedHat|CentOS|Fedora)$/: { $packages = [
      'perl-Switch', 'perl-DateTime', 'perl-Sys-Syslog',
      'perl-LWP-Protocol-https', 'perl-Digest-SHA', 'unzip'] }
    'Amazon': { $packages = ['perl-Switch', 'perl-DateTime',
      'perl-Sys-Syslog', 'perl-LWP-Protocol-https', 'unzip'] }
    /(Ubuntu|Debian)$/: { $packages = ['unzip', 'libwww-perl',
      'libdatetime-perl'] }
  }

  # Install dependencies
  package { $packages :
    ensure => present
  }

  # Download and extract the scripts from AWS
  archive { 'CloudWatchMonitoringScripts-1.2.1':
    ensure        => present,
    url           => 'http://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.1.zip',
    extension     => 'zip',
    target        => '/opt',
    digest_string => '939508e2fed7620625ba43fbd2668c6b',
    src_target    => '/tmp'
  }

  # Setup a cron to push the metrics to Cloudwatch every minute
  cron { 'cloudwatch':
    ensure   => present,
    name     => 'Push extra metrics to Cloudwatch',
    minute   => '*',
    hour     => '*',
    monthday => '*',
    month    => '*',
    weekday  => '*',
    command  => '/opt/aws-scripts-mon/mon-put-instance-data.pl --mem-util --mem-used --mem-avail --swap-util --swap-used --disk-path=/ --disk-space-util --disk-space-used --disk-space-avail --from-cron',
  }

}
