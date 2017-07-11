# Class: cloudwatch
# ===========================
#
# Installs AWS Cloudwatch Monitoring Scripts and sets up a cron entry to push
# monitoring information to Cloudwatch every minute.
#
# Read more about AWS Cloudwatch Monitoring Scripts:
#   http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/mon-scripts.html
#
# == Parameters
#
# [*access_key*]
#   The amazon user's access id that has permissions to upload cloudwatch data.
#   Does not create the credentials file if this is left undef.
#   Default: undef
#
# [*secret_key*]
#   The amazon user's secret key.
#   Does not create the credentials file if this is left undef.
#   Default: undef
#
# [*enable_mem_util*]
#   Collects and sends the MemoryUtilization metrics in percentages.
#   This option reports only memory allocated by applications and the operating
#   system, and excludes memory in cache and buffers.
#   Default: true
#
# [*enable_mem_used*]
#   Collects and sends the MemoryUsed metrics, reported in megabytes.
#   This option reports only memory allocated by applications and the operating
#   system, and excludes memory in cache and buffers.
#   Default: true
#
# [*enable_mem_avail*]
#   Collects and sends the MemoryAvailable metrics, reported in megabytes.
#   This option reports memory available for use by applications and the
#   operating system.
#   Default: true
#
# [*enable_swap_util*]
#   Collects and sends SwapUtilization metrics, reported in percentages.
#   Default: true
#
# [*enable_swap_used*]
#   Collects and sends SwapUsed metrics, reported in megabytes.
#   Default: true
#
# [*disk_path*]
#   Selects the disk on which to report.
#   Can specify a mount point or any file located on a mount point for the
#   filesystem that needs to be reported. For selecting multiple disks,
#   specify a --disk-path=PATH for each one of them.
#
#   Example:
#     To select a disk for the filesystems mounted on / and /home, use the
#     following parameters:
#
#   --disk-path=/ --disk-path=/home
#   Default: '/'
#
# [*disk_space_util*]
#   Collects and sends the DiskSpaceUtilization metric for the selected disks.
#   The metric is reported in percentages.
#   Note, ignored if disk_path is undef.
#   Default: true
#
#
# [*disk_space_used*]
#   Collects and sends the DiskSpaceUsed metric for the selected disks.
#   The metric is reported by default in gigabytes.
#   Note, ignored if disk_path is undef.
#   Default: true
#
# [*disk_space_avail*]
#   Collects and sends the DiskSpaceAvailable metric for the selected disks.
#   The metric is reported in gigabytes.
#   Note, ignored if disk_path is undef.
#   Default: true
#
# [*memory_units*]
#   Specifies units in which to report memory usage.
#   UNITS may be one of the following: bytes, kilobytes, megabytes, gigabytes.
#   Default: 'megabytes'
#
# [*disk_space_units*]
#   Specifies units in which to report disk space usage.
#   UNITS may be one of the following: bytes, kilobytes, megabytes, gigabytes.
#   Default: 'gigabytes'
#
# [*aggregated*]
#   Adds aggregated metrics for instance type, AMI ID, and overall for the
#   region.
#   Default: false
#
# [*aggregated_only*]
#   The script only aggregates metrics for instance type, AMI ID, and overall
#   for the region.
#   Default: false
#
# [*auto_scaling*]
#   Adds aggregated metrics for the Auto Scaling group.
#   Default: false
#
# [*auto_scaling_only*]
#   The script reports only Auto Scaling metrics.
#   Default:false
#
# [*cron_min*]
#   The minute at which to run the cron job.
#   The default is cron runs every minute.  To change to run every 5 minutes
#   use '*/5'
#   Default: '*'
#
# == Variables
#
# [*dest_dir*]
#  The directory to install the aws scripts.
#
# [*cred_file*]
#  The file that contains the IAM credentials
#
# [*zip_name*]
#   The name of the zip that contains the cloudwatch scripts.
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
class cloudwatch (
  $access_key        = undef,
  $secret_key        = undef,
  $enable_mem_util   = true,
  $enable_mem_used   = true,
  $enable_mem_avail  = true,
  $enable_swap_util  = true,
  $enable_swap_used  = true,
  $disk_path         = '/',
  $disk_space_util   = true,
  $disk_space_used   = true,
  $disk_space_avail  = true,
  $memory_units      = 'megabytes',
  $disk_space_units  = 'gigabytes',
  $aggregated        = false,
  $aggregated_only   = false,
  $auto_scaling      = false,
  $auto_scaling_only = false,
  $cron_min          = '*',
){

  $dest_dir  = '/opt/aws-scripts-mon'
  $cred_file = "${dest_dir}/awscreds.conf"
  $zip_name  = 'CloudWatchMonitoringScripts-1.2.1.zip'

  # Establish which packages are needed, depending on the OS family
  case $::operatingsystem {
    /(RedHat|CentOS|Fedora)$/: { $packages = [
      'perl-Switch', 'perl-DateTime', 'perl-Sys-Syslog',
      'perl-LWP-Protocol-https', 'perl-Digest-SHA', 'unzip'] }
    'Amazon': { $packages = ['perl-Switch', 'perl-DateTime',
      'perl-Sys-Syslog', 'perl-LWP-Protocol-https', 'unzip'] }
    /(Ubuntu|Debian)$/: { $packages = ['unzip', 'libwww-perl',
      'libdatetime-perl'] }
    default: {
      fail("Module cloudwatch is not supported on ${::operatingsystem}")
    }
  }

  # Install dependencies
  ensure_packages ($packages)

  # Download and extract the scripts from AWS
  archive { "/opt/${zip_name}":
    ensure       => present,
    extract      => true,
    extract_path => '/opt/',
    source       => "http://aws-cloudwatch.s3.amazonaws.com/downloads/\
${zip_name}",
    creates      => $dest_dir,
    require      => Package[$packages],
  }

  if $access_key and $secret_key {
    file{$cred_file:
      ensure  => file,
      content => template('cloudwatch/awscreds.conf.erb'),
      require => Archive["/opt/${zip_name}"],
      before  => Cron['cloudwatch'],
    }
    $creds_path = "--aws-credential-file=${cred_file}"
  }
  else { $creds_path = '' }

  # build command
  if $enable_mem_util {
    $mem_util = '--mem-util'
  }else{
    $mem_util = ''
  }

  if $enable_mem_used {
    $mem_used = '--mem-used'
  }else{
    $mem_used = ''
  }

  if $enable_mem_avail {
    $mem_avail = '--mem-avail'
  }else{
    $mem_avail = ''
  }

  if $enable_swap_util {
    $swap_util = '--swap-util'
  }else{
    $swap_util = ''
  }

  if $enable_swap_used {
    $swap_used = '--swap-used'
  }else{
    $swap_used = ''
  }

  $memory_units_val = "--memory-units=${memory_units}"

  if $disk_path {
    $disk_path_val = "--disk-path=${disk_path}"
    if $disk_space_util {
      $disk_space_util_val  = '--disk-space-util'
    }else{
      $disk_space_util_val = ''
    }
    if $disk_space_used {
      $disk_space_used_val  = '--disk-space-used'
    }else{
      $disk_space_used_val = ''
    }
    if $disk_space_avail {
      $disk_space_avail_val  = '--disk-space-avail'
    }else{
      $disk_space_avail_val = ''
    }
    $disk_space_units_val  = "--disk-space-units=${disk_space_units}"

  }else{
    $disk_path_val        = ''
    $disk_space_util_val  = ''
    $disk_space_used_val  = ''
    $disk_space_avail_val = ''
    $disk_space_units_val = ''
  }

  if $aggregated {
    if $aggregated_only {
      $aggregated_val = '--aggregated=only'
    }else{
      $aggregated_val = '--aggregated'
    }
  }else{
    $aggregated_val = ''
  }

  if $auto_scaling{
    if $auto_scaling_only {
      $auto_scaling_val = '--auto-scaling=only'
    }else{
      $auto_scaling_val = '--atuo-scaling'
    }
  }else{
    $auto_scaling_val = ''
  }

  $pl_path = "${dest_dir}/mon-put-instance-data.pl"
  $command = "${pl_path} ${mem_util} ${mem_used} ${mem_avail} ${swap_util}\
 ${swap_used} ${memory_units_val} ${disk_path_val} ${disk_space_util_val}\
 ${disk_space_used_val} ${disk_space_avail_val} ${disk_space_units_val}\
 ${aggregated_val} ${auto_scaling_val} ${creds_path} --from-cron"

  # Setup a cron to push the metrics to Cloudwatch every minute
  cron { 'cloudwatch':
    ensure   => present,
    name     => 'Push extra metrics to Cloudwatch',
    minute   => $cron_min,
    hour     => '*',
    monthday => '*',
    month    => '*',
    weekday  => '*',
    command  => $command,
    require  => Archive['/opt/CloudWatchMonitoringScripts-1.2.1.zip'],
  }
}
