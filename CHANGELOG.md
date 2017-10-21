## Release [0.5.2](https://github.com/JoeNyland/puppet-cloudwatch/releases/tag/0.5.2)

* Use cron instead of cronie on Debian/Ubuntu OSes
* Relax version constraint for archive module (#25)
* Update the AWS scripts version to 1.2.2 (#27)

## Release [0.5.1](https://github.com/JoeNyland/puppet-cloudwatch/releases/tag/0.5.1)

* No changes in this release

## Release [0.5.0](https://github.com/JoeNyland/puppet-cloudwatch/releases/tag/0.5.0)

* Remove erroneous quote from cron command
* Ensure that unzip is installed before extracting the archive containing Cloudwatch scripts (only when `$manage_dependencies` is enabled)
* Ensure that cron is installed before creating the cron entry (only when `$manage_dependencies` is enabled)
* Update supported OS versions
* Remove Fedora as a supported OS
* Revise error message for unsupported OS

## Release [0.4.0](https://github.com/JoeNyland/puppet-cloudwatch/releases/tag/0.4.0)

* Remove extra spaces from command that's added to crontab
* Improve documentation
* Rename disk space related parameters
* Add ability to customise installation location
* Add support for using a specific IAM role
* Add the ability to disable the installation of system packages in the module
* Add the ability to provide a credentials file

## Release [0.3.1](https://github.com/JoeNyland/puppet-cloudwatch/releases/tag/0.3.1)

* Replace unsupported `unless` when evaluating `$disk_path`

## Release [0.3.0](https://github.com/JoeNyland/puppet-cloudwatch/releases/tag/0.3.0)

* Allow multiple disk paths to be reported to CloudWatch
* Allow the use of IAM instance profiles by omitting AWS credentials

## Release [0.2.0](https://github.com/JoeNyland/puppet-cloudwatch/releases/tag/0.2.0)

* Change my GitHub username.
* Changed to `puppet-archives` module.
* Added configuration to manage the credentials file.
* Added parameters to control the metrics to be monitored.

## Release [0.1.1](https://github.com/JoeNyland/puppet-cloudwatch/releases/tag/0.1.1)

* Fixes in the test suite.

## Release [0.1.0](https://github.com/JoeNyland/puppet-cloudwatch/releases/tag/0.1.0)

* Initial release of the module.
