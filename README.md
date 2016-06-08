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

## Limitations

Tested on CentOS 7, Debian 7, Debian 8, Ubuntu 12.04, Ubuntu 14.04 and Amazon Linux 2015.03.
Tested with Puppet 4.x and 3.x.

## Development

Please feel free to file an issue on the GitHub repo or create a PR if
there's something here that you'd like to fix. I'll try to fix issues
as and when they arise as soon as I can.

## Release Notes/Contributors/Etc.

See the [CHANGELOG](CHANGELOG.md).
