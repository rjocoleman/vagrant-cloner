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

Each cloner has its own section inside the configuration, and this is the
recommended way to set them:

``` ruby
Vagrant::Config.run do |config|

  config.vm.provision :chef_solo do |chef|
    # ...
  end

  config.vm.provision :cloner do |cfg|
    cfg.cloner.mysql.tap do |c|
      # Set options here.
      c.enabled = true
      c.run_order = 10
      # ...
    end
  end
end
```

The following keys are valid:

- **cloner**
    - **(all cloners)**
        - **enabled** - Required: Boolean whether to use this cloner or not. Defaults to false.
        - **run_order** - Suggested: Integer value that dictates which order cloners run in. Lower orders run first. Defaults to 1000.
    - **mysql**
        - **remote_host** - String containing the remote server's FQDN.
        - **remote_user** - Username to connect to remote server.
        - **remote_password** - Optional: Password to connect to remote server. (Can be ignored if using publickey auth.)
        - **remote_db_user** - Username to remote database server.
        - **remote_db_password** - Password to remote database server.
        - **vm_db_user** - Username to database server on VM.
        - **vm_db_password** - Password to database server on VM.
        - **databases_to_clone** - Optional: Array of databases to copy down. Defaults to 'all'.
        - **remote_backup_path** - Optional: Where to dump databases to on remote server. Defaults to '/tmp'.
        - **local_backup_path** - Optional: Where to store databases on host machine. Defaults to '/tmp'.
        - **vm_backup_path** - Optional: Where to upload databases on VM. Defaults to '/tmp'.
        - **backup_file** - Optional: Name for database dump. Defaults to mysql-dump-YYYY-MM-DD.sql.
        - **disable_cleanup** - Optional: Don't remove database dumps after completion. Defaults to false.
    - **testcloner**
        - **foo** - String containing a message to print to console.
    - **mysqlcleaner**
        - **scripts** -- Array containing strings of URLs of remote SQL files to be run against the VM's database.
        - **vm_db_user** - Username to database server on VM.
        - **vm_db_password** - Password to database server on VM.

If you have some concern about storing passwords in this file (i.e. your Vagrantfile
is under version control), remember that the Vagrantfile is fully executed, so you can
simply require a file from elsewhere or read values in.

## Current List of Supplied Cloners

- `mysql` - Import a MySQL database(s)
- `testcloner` - A simple example of a cloner not meant for use.
- `mysqlcleaner` - Runs arbitrary SQL scripts against the MySQL server. Useful for sanitizing databases imported by the `mysql` cloner.

## Extra Cloners

You can write your own cloners to use with the tool. Unfortunately, because of how Vagrant loads its configuration settings, it's not possible to store these in a directory that is not in the gem itself.

Our suggestion is as follows:

1. Fork the gem and git-clone it;
2. Add your own cloner inside lib/vagrant-cloner/cloners/;
3. Add your configuration settings inside your Vagrantfile;
4. Run `rake build`;
5. Run `vagrant gem install vagrant-cloner --local ./pkg/`
6. Resume using vagrant as usual.

If you make an error in your script, you may have a hard time uninstalling it with `vagrant gem uninstall`. In a trice, you can remove directories in `~/.vagrant.d/gems/gems/` to manually remove troublesome gems. (Note that this was tested on a Linux distribution, so this may vary for Mac and Windows users.)

## How to Write a Cloner

To operate as a cloner, a class must inherit from `Vagrant::Cloners::Cloner`, and implement at a bare minimum these methods:

- `name` - Returns a string representation of the cloner's name; used for namespacing config.
- `validate(machine, errors)` - Can be used to call `errors.add` if there are validations that need to be performed on configuration values.
- `call` - Executes the cloner's routine.

A cloner must also be registered in the config to be run. This is best done after the class has been closed, at the bottom of the file:

`Vagrant::ClonerContainer.instance.send("#{<Class>.instance.name}=".to_sym, <Class>.instance)`

So for the MySQL cloner (which is `Vagrant::Cloners::MysqlCloner`), the line would read 

`Vagrant::ClonerContainer.instance.send("#{Vagrant::Cloners::MysqlCloner.instance.name}=".to_sym, Vagrant::Cloners::MysqlCloner.instance)`

A very minimal example [can be found in the cloners directory](lib/vagrant-cloner/cloners/testcloner.rb). For more detailed examples, look at the other cloners there!

### How is this possibly useful for me?

`Cloner` exposes the `ssh`, `scp`, and `vm` methods to your class, so, in combination with `Kernel#system`, you can do pretty much anything on either host, VM, or remote server that you can do in (z|ba)sh.

The `vm` method, as an aside, is just a reference to the SSH communicator of Vagrant, so you can see what it provides [here](https://github.com/mitchellh/vagrant/blob/master/plugins/communicators/ssh/communicator.rb). If you need to actually access the environment, that is made available through the `env` method.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
6. Explain why you think this belongs in the code here, and not inside your own gem that requires this one.

Pull requests most graciously accepted.
