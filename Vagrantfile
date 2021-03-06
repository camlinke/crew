# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 8080, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  config.vm.define :local do |local|
    local.vm.box = "ubuntu/trusty64"
  end

  config.vm.hostname = 'chatfly'
  config.vm.define :digital_ocean do |digital_ocean|
    digital_ocean.vm.provider :digital_ocean do |provider, override|
      override.ssh.private_key_path = '~/.ssh/id_rsa'
      override.vm.box = 'digital_ocean'
      override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"

      provider.ssh_key_name = 'SSH Key'
      provider.token = ENV['DO_TOKEN']
      provider.image = 'ubuntu-14-04-x64'
      provider.region = 'nyc2'
      provider.size = '512mb'
    end
  end

  # config.trigger.after :reload do
  #   info "Restarting Screen Session"
  #   @machine.communicate.sudo("bash /vagrant/reload.sh")
  #   # run_remote "bash /vagrant/reload.sh"
  # end
  # config.vm.provision :reload, inline: <<-SHELL
  #   sudo service nginx restart
  #   screen -dm bash -c "cd /vagrant; node index.js;"
  # SHELL

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.26.1/install.sh | bash
  #   source ~/.nvm/nvm.sh
  #   nvm install node
  #   nvm alias default node

  #   sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
  #   echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
  #   sudo apt-get update
  #   sudo apt-get install -y mongodb-org
  #   sudo service mongod start

  #   sudo apt-get install -y nginx

  #   cd /vagrant
  #   npm install
  #   npm install -g nodemon
  #   nohup nodemon index.js &
  # SHELL

  config.vm.provision :shell, :path => "provision.sh"
  # config.vm.provision :shell, :path => "reload.sh", privileged: false
end
