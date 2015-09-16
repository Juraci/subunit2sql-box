# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define :subunit_box do |subunit_config|
    subunit_config.vm.box = 'ubuntu/trusty64'
    subunit_config.vm.network :private_network, ip: '192.168.33.53'

    subunit_config.vm.provision 'ansible' do |ansible|
      ansible.playbook = 'subunit_servers.yaml'
      ansible.limit = 'subunit-box'
      ansible.sudo = true
      ansible.inventory_path = 'hosts'
      ansible.extra_vars = {
        ansible_ssh_user: 'vagrant'
      }
    end

    subunit_config.vm.provider 'virtualbox' do |v|
      v.memory = 1024
    end
  end
end
