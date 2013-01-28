# vagrant-cloner

Copy down production resources to your new Vagrant VM.

## Installation

Use vagrant's built-in gem system:

    vagrant gem install vagrant-cloner

## Usage

You will need to add a `config.vm.provision :cloner` section to your config in
order for Cloner to work. This should come after your other provisioners; if
Cloner runs before Chef or Puppet, for example, it's quite conceivable there 
would be no database to restore to!

These are the configuration keys required / optional to modify Cloner's behaviour:

```
# [Required] Which cloners should we use? (Empty array permitted)
:cloners,

# [Required] The FQDN of the host where data is to be synced from
:remote_host,

# [Required] The username and password to access the remote host
:remote_user,
:remote_password,

# [Required] The database user and password to access the remote database
:remote_db_user,
:remote_db_password,

# [Required] The user and password to the database on the VM
:vm_db_user,
:vm_db_password,

# [Optional] The databases that we should clone
# - An empty array indicates we should clone all
# - An array containing '*' will clone all as well;
# - An array containing a list of database names will clone only those.
:databases_to_clone,

# [Optional] The location to temporarily store the database backup on the remote machine
:remote_backup_path,

# [Optional] The location to temporarily store the database backup on our machine
:local_backup_path,

# [Optional] The location to temporarily store the database backup on the VM
:vm_backup_path,

# [Optional] The name of the backup file
:backup_file,

# [Optional] Override to change the arguments passed to Net::SSH and Net::SCP.
:remote_credentials

```

These options must be configured inside your `Vagrantfile`:

```
Vagrant::Config.run do |config|

    # ...
  end

  config.vm.provision :cloner do |cloner|
    cloner.cloners = %w(mysql)
    cloners.remote_host = 'myserver.com'

    # ...
  end
end
```

If you have some concern about storing passwords in this file (i.e. your Vagrantfile
is under version control), remember that the Vagrantfile is fully executed, so you can
simply require a file from elsewhere or read values in.

## Current List of Cloners

- `mysql` -- import a MySQL database(s)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
