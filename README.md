# cloudwatch

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with cloudwatch](#setup)
    * [What cloudwatch affects](#what-cloudwatch-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with cloudwatch](#beginning-with-cloudwatch)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Installs AWS Cloudwatch Monitoring Scripts and sets up a cron entry to 
push monitoring information to Cloudwatch every minute.

More info on the monitoring scripts can be found [here](http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/mon-scripts.html).

## Setup

### What cloudwatch affects

Creates a crontab entry in order to routinely push metrics to Cloudwatch.
This cron job defaults to being run as the user running Puppet or root. 

The Cloudwatch montitoring scripts that this module installs are
dependent on the following packages and they will be installed automatically:

  * RHEL/CentOS/Fedora:
    * `perl-Switch`
    * `perl-DateTime`
    * `perl-Sys-Syslog`
    * `perl-LWP-Protocol-https`
    * `perl-Digest-SHA`
    * `unzip`
      
  * Amazon Linux:
    * `perl-Switch`
    * `perl-DateTime`
    * `perl-Sys-Syslog`
    * `perl-LWP-Protocol-https`
    * `unzip`
      
  * Debian/Ubuntu:
    * `libwww-perl`
    * `libdatetime-perl`
    * `unzip`

### Setup Requirements

Once this module has been installed and your manifest has been applied to your
Puppet nodes, Cloudwatch metrics will be pushed every minute. You *must* setup
AWS IAM credentials on your instances or assign an IAM role to your instances
that has access to push data to Cloudwatch. More info on this can be found
[here](http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/mon-scripts.html#mon-scripts-getstarted).  

### Beginning with cloudwatch

## Usage

  * Install the module: `sudo puppet module install masterroot24-cloudwatch`
  * Include the module in your manifests: `node 'my-node.example.com' { include cloudwatch }`

## Class cloudwatch

### Parameters

#### `access_key`
The amazon user's access id that has permissions to upload cloudwatch data.
Does not create the credentials file if this is left undef.  
Default: undef

#### `secret_key`
The amazon user's secret key.
Does not create the credentials file if this is left undef.  
Default: undef

#### `enable_mem_util`
Collects and sends the MemoryUtilization metrics in percentages.
This option reports only memory allocated by applications and the operating
system, and excludes memory in cache and buffers.  
Default: true

#### `enable_mem_used`
Collects and sends the MemoryUsed metrics, reported in megabytes.
This option reports only memory allocated by applications and the operating
system, and excludes memory in cache and buffers.
Default: true  

#### `enable_mem_avail`
Collects and sends the MemoryAvailable metrics, reported in megabytes.
This option reports memory available for use by applications and the
operating system.  
Default: true

#### `enable_swap_util`
Collects and sends SwapUtilization metrics, reported in percentages.  
Default: true

#### `enable_swap_used`
Collects and sends SwapUsed metrics, reported in megabytes.  
Default: true

#### `disk_path`
Selects the disk on which to report.
Can specify a mount point or any file located on a mount point for the
filesystem that needs to be reported. For selecting multiple disks,
specify a --disk-path=PATH for each one of them.

##### Example:  
To select a disk for the filesystems mounted on / and /home, use the
following parameters:

   --disk-path=/ --disk-path=/home

Default: '/'

#### `disk_space_util`
Collects and sends the DiskSpaceUtilization metric for the selected disks.
The metric is reported in percentages.
Note, ignored if disk_path is undef.  
Default: true

#### `disk_space_used`
Collects and sends the DiskSpaceUsed metric for the selected disks.
The metric is reported by default in gigabytes.
Note, ignored if disk_path is undef.  
Default: true

#### `disk_space_avail`
Collects and sends the DiskSpaceAvailable metric for the selected disks.
The metric is reported in gigabytes.
Note, ignored if disk_path is undef.  
Default: true

#### `memory_units`
Specifies units in which to report memory usage.
UNITS may be one of the following: bytes, kilobytes, megabytes, gigabytes.  
Default: 'megabytes'

#### `disk_space_units`
Specifies units in which to report disk space usage.
UNITS may be one of the following: bytes, kilobytes, megabytes, gigabytes.  
Default: 'gigabytes'

#### `aggregated`
Adds aggregated metrics for instance type, AMI ID, and overall for the region.  
Default: false

#### `aggregated_only`
The script only aggregates metrics for instance type, AMI ID, and overall for the region.  
Default: false

#### `auto_scaling`
Adds aggregated metrics for the Auto Scaling group.  
Default: false

#### `auto_scaling_only`
The script reports only Auto Scaling metrics.  
Default:false

## Limitations

Tested on CentOS 7, Debian 7, Debian 8, Ubuntu 12.04, Ubuntu 14.04 and Amazon Linux 2015.03.
Tested with Puppet 4.x and 3.x.

## Development

Please feel free to file an issue on the GitHub repo or create a PR if
there's something here that you'd like to fix. I'll try to fix issues
as and when they arise as soon as I can.

## Release Notes/Contributors/Etc.

See the [CHANGELOG](CHANGELOG.md).
