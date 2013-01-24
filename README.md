# vagrant-cloner

Copy down production resources to your new Vagrant VM.

## Installation

Use vagrant's built-in gem system:

    vagrant gem install vagrant-cloner

## Usage

You will need to add a `config.vm.provision :cloner` section to your config in
order for Cloner to work.

The following config entries must be present, though they are all listed in
the below example for the purpose of documentation.

- `cloner.enabled` (boolean)
- `cloner.remote_user` (string)
- `cloner.remote_password` (string)
- `cloner.remote_host` (string)
- `cloner.remote_db_user` (string)
- `cloner.remote_db_password` (string)

```
Vagrant::Config.run do |config|

    # ...
  end

  config.vm.provision :cloner do |cloner|
    cloner.enabled = true
    cloner.remote_user = 'user'
    cloner.remote_password = 'password'
    cloner.remote_host = 'server.host.com'
    cloner.remote_port = 25

    cloner.remote_db_user = 'user'
    cloner.remote_db_password = 'password'

    cloner.local_db_user = 'user'
    cloner.local_db_password = 'password'

    cloner.databases_to_backup = '*'
  end
end

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
