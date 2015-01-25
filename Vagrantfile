# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'konsti/trusty-docker'

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.define 'passenger-docker' do |node|
    node.vm.hostname = 'passenger-docker.local'
    node.vm.network 'private_network', ip: '10.0.0.10'
  end
end
