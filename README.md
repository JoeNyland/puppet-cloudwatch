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

Installs AWS Cloudwatch Monitoring Scripts and sets up a cron entry to push system metrics to Cloudwatch.

More info on the monitoring scripts can be found [here](http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/mon-scripts.html).

## Setup

### What cloudwatch affects

Creates a crontab entry in order to routinely push metrics to Cloudwatch.
This cron job defaults to being run as the user running Puppet or root.

The Cloudwatch monitoring scripts that this module installs are dependent on the following packages and they will be
installed automatically, unless `$manage_dependencies` is set to `false`.

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

Once this module has been installed and your manifest has been applied to your Puppet nodes, Cloudwatch metrics will
be pushed every minute by default.

You *must* setup AWS IAM credentials on your instances or assign an IAM role to your instances which has access to
push data to Cloudwatch. More info on this can be found [here](http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/mon-scripts.html#mon-scripts-getstarted).

### Beginning with cloudwatch

## Usage

  * Install the module: `puppet module install MasterRoot24-cloudwatch`
  * Include the module in your manifests: `node 'my-node.example.com' { include cloudwatch }`

## Class cloudwatch

### Parameters

#### `access_key`

IAM access key ID for a user that has permissions to push metrics to Cloudwatch.

Note: Both `access_key` _and_ `secret_key` must be set to use IAM user credentials.

Note: Cannot be used with `credential_file` or `iam_role`.

Default: `undef`

#### `secret_key`

IAM secret access key for a user that has permissions to push metrics to Cloudwatch.

Note: Both `access_key` _and_ `secret_key` must be set to use IAM user credentials.

Note: Cannot be used with `credential_file` or `iam_role`.

Default: `undef`

#### `credential_file`

Path to file containing IAM user credentials.

Note: Cannot be used with `access_key` _and_ `secret_key` or `iam_role`.

Example credential file:

    AWSAccessKeyId=my-access-key-id
    AWSSecretKey=my-secret-access-key

Default: `undef`

#### `iam_role`

IAM role used to provide AWS credentials.

Note: Cannot be used with `access_key` _and_ `secret_key` or `credential_file`.

Default: `undef`

#### `enable_mem_util`

Collects and sends the `MemoryUtilization` metric as a percentage.

This option reports only memory allocated by applications and the operating system, and excludes memory in cache and
buffers.

Default: `true`

#### `enable_mem_used`

Collects and sends the `MemoryUsed` metric.

This option reports only memory allocated by applications and the operating system, and excludes memory in cache and
buffers.

Default: `true`

#### `enable_mem_avail`

Collects and sends the `MemoryAvailable` metric.

This option reports memory available for use by applications and the operating system.

Default: `true`

#### `enable_swap_util`

Collects and sends `SwapUtilization` metric as a percentage.

Default: `true`

#### `enable_swap_used`

Collects and sends `SwapUsed` metric.

Default: `true`

#### `disk_path`

Selects the disks on which to report.

It's possible to specify a mount point or any file located on a mount point for the filesystem that needs to be
reported.

To select multiple disks, add additional elements to the array. E.g. `['/', '/home']`

Default: `['/']`

#### `enable_disk_space_util`

Collects and sends the `DiskSpaceUtilization` metric for the selected disks.

The metric is reported as a percentage.

Default: `true`

#### `enable_disk_space_used`

Collects and sends the `DiskSpaceUsed` metric for the selected disks.

Default: `true`

#### `enable_disk_space_avail`

Collects and sends the `DiskSpaceAvailable` metric for the selected disks.

Default: `true`

#### `memory_units`

Specifies units in which to report memory usage.

Units may be one of the following: `bytes`, `kilobytes`, `megabytes`, `gigabytes`.

Default: `'megabytes'`

#### `disk_space_units`

Specifies units in which to report disk space usage.

Units may be one of the following: `bytes`, `kilobytes`, `megabytes`, `gigabytes`.

Default: `'gigabytes'`

#### `aggregated`

Adds aggregated metrics for instance type, AMI ID, and overall for the region.

Default: `false`

#### `aggregated_only`

The script only aggregates metrics for instance type, AMI ID, and overall for the region.

Default: `false`

#### `auto_scaling`

Adds aggregated metrics for the Auto Scaling group.

Default: `false`

#### `auto_scaling_only`

The script reports only Auto Scaling metrics.

Default: `false`

#### `cron_min`

The minute at which to run the cron job, specified an cron format. e.g. `'*/5'` would push metrics to Cloudwatch
every 5 minutes.

Default: `'*'` (every minute)

#### `install_target`

The directory to install the AWS scripts into.

Default: `/opt`

#### `manage_dependencies`

Whether or not this module should manage the installation of the packages which the AWS scripts depend on.

Default: `true`

#### `zip_url`

URL to the Cloudwatch scripts zip file.

Default: `http://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.2.zip`

## Development

Please feel free to file an issue on the GitHub repo or create a PR if there's something here that you'd like to fix.

I'll try to fix issues as and when they arise as soon as I can.

## Release Notes/Contributors/Etc.

See the [CHANGELOG](CHANGELOG.md).
