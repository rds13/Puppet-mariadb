MariaDB
-------

This is the MariaDB module for [Puppet](http://puppetlabs.com/);

Currently, only Debian based systems are supported. We gladly accept Pull Requests ;)

You can use this module best by defining the following hiera values (replace 5.5 by actual desired version):
  mysql_package: mariadb-server-5.5
  mysql_version: 5.5
  mysql_my_class: mariadb

In your manifest you can then simply include class mysql.



License
-------
This module is distributed under the Three-Clause BSD license. See also the LICENSE file included in this module.


Contact
-------
Feedback is welcome! Feel free to contact us via [GitHub](http://github.com/enrise/Puppet-mariadb/).


Support
-------
Please log tickets and issues at our [Projects site](http://github.com/enrise/Puppet-mariadb/).

