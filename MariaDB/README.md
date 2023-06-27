# Using MariaDB


## Tools / How to work with MariaDB

### Windows
<details>
<summary><samp>&#9776;</samp> Click to expand </summary>

<br>

#### 1. Download [MySQL Installer](https://dev.mysql.com/downloads/installer/)

> **Warning** Unlike the standard MySQL Installer, the smaller web-community version does not bundle any MySQL applications, but downloads only the MySQL products you choose to install.

#### 2. Determine the setup type to use for the initial installation of MySQL products. For example:
   - Developer Default: Provides a setup type that includes the selected version of MySQL Server and other MySQL tools related to MySQL development, such as MySQL Workbench.
   - Server Only: Provides a setup for the selected version of MySQL Server without other products.
   - Custom: Enables you to select any version of MySQL Server and other MySQL products.

Install the server instance (and products) and then begin the server configuration by following the onscreen instructions. For more information about each individual step, see [Section 2.3.3.3.1, “MySQL Server Configuration with MySQL Installer”.](https://dev.mysql.com/doc/refman/8.0/en/mysql-installer-workflow.html#mysql-installer-workflow-server)

<br>
</details>

<br>

### MacOS
<details>
<summary><samp>&#9776;</samp> Click to expand </summary>

<br>

#### 1. For a list of macOS versions that the MySQL server supports, see [this](https://www.mysql.com/support/supportedplatforms/database.html)

#### 2. You should keep the following issues and notes in mind:

`Homebrew`
- For example, if you installed MySQL Server using Homebrew to its default location then the MySQL installer installs to a different location and won't upgrade the version from Homebrew. In this scenario you would end up with multiple MySQL installations that, by default, attempt to use the same ports. Stop the other MySQL Server instances before running this installer, such as executing brew services stop mysql to stop the Homebrew's MySQL service. Follow this:
  ```ruby
  brew install mysql
  brew services list
  brew services start mysql
  brew cask install mysqlworkbench
  ```

<br>

`Installer package`
- To install MySQL using the package installer:
  - Download the disk image (.dmg) file (the community version is available [here](https://dev.mysql.com/downloads/mysql/)) that contains the MySQL package installer. Double-click the file to mount the disk image and see its contents.
  - Double-click the MySQL installer package from the disk. It is named according to the version of MySQL you have downloaded. For example, for MySQL server 8.0.33 it might be named `mysql-8.0.33-macos-10.13-x86_64.pkg.`
  - The initial wizard introduction screen references the MySQL server version to install. Click `Continue`
  - The MySQL community edition shows a copy of the relevant GNU General Public License. Click `Continue` -> `Agree`
  - From the **`Installation Type`** page you can either click `Install` to using all defaults, `Customize` to alter which components to install (MySQL server, MySQL Test, Preference Pane, Launchd Support -- all but MySQL Test are enabled by default).
  > **Warning** Although the **`Change Install Location`** option is visible, the installation location cannot be changed.
  - After a successful new MySQL Server installation, complete the configuration steps by choosing the default encryption type for passwords, define the root password, and also enable (or disable) MySQL server at startup.

<br>

`Aliases`
- You might want to add aliases to your shell's resource file to make it easier to access commonly used programs such as mysql and mysqladmin from the command line. The syntax for bash is:
  ```bash
  alias mysql=/usr/local/mysql/bin/mysql
  alias mysqladmin=/usr/local/mysql/bin/mysqladmin
  ```

<br>

`tcsh`
- For tcsh, use:
  ```bash
  alias mysql /usr/local/mysql/bin/mysql
  alias mysqladmin /usr/local/mysql/bin/mysqladmin
  ```

<br>
</details>

<br>

### Linux
<details>
<summary><samp>&#9776;</samp> Click to expand </summary>

<br>

#### Its too long so I'll list it and some `command` over here

- [Installing MySQL on Linux Using the MySQL Yum Repository](https://dev.mysql.com/doc/refman/8.0/en/linux-installation-yum-repo.html)
  ```ruby
  sudo yum install platform-and-version-specific-package-name.rpm
  
  #For an EL6-based system, the command is in the form of:
  sudo yum install mysql80-community-release-el6-{version-number}.noarch.rpm
  
  #For an EL7-based system:
  sudo yum install mysql80-community-release-el7-{version-number}.noarch.rpm
  
  #For an EL8-based system:
  sudo yum install mysql80-community-release-el8-{version-number}.noarch.rpm
  
  #For an EL9-based system:
  sudo yum install mysql80-community-release-el9-{version-number}.noarch.rpm
  
  #For Fedora 36:
  sudo dnf install mysql80-community-release-fc36-{version-number}.noarch.rpm
  
  #For Fedora 37:
  sudo dnf install mysql80-community-release-fc37-{version-number}.noarch.rpm
  ```
- [Installing MySQL on Linux Using the MySQL APT Repository](https://dev.mysql.com/doc/refman/8.0/en/linux-installation-apt-repo.html)
- [Installing MySQL on Linux Using the MySQL SLES Repository](https://dev.mysql.com/doc/refman/8.0/en/linux-installation-apt-repo.html)
- [Installing MySQL on Linux Using RPM Packages from Oracle](https://dev.mysql.com/doc/refman/8.0/en/linux-installation-rpm.html)
- [Installing MySQL on Linux Using Debian Packages from Oracle](https://dev.mysql.com/doc/refman/8.0/en/linux-installation-debian.html)
- [Installing MySQL on Linux from the Native Software Repositories](https://dev.mysql.com/doc/refman/8.0/en/linux-installation-native.html)
- [Installing MySQL on Linux with Juju](https://dev.mysql.com/doc/refman/8.0/en/linux-installation-juju.html)

<br>
</details>
