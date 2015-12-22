# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'

def load_security
  fname = File.join(File.dirname(__FILE__), "security.yml")
  if !File.exist? fname
    $stderr.puts "security.yml not found - please run `./security-setup` and try again."
    exit 1
  end

  YAML.load_file(fname)
end

Vagrant.configure(2) do |config|
  # Prefer VirtualBox before VMware Fusion
  config.vm.provider "virtualbox"
  config.vm.provider "vmware_fusion"

  config.vm.box = "CiscoCloud/microservices-infrastructure"

  config.vm.synced_folder ".", "/vagrant", type: "rsync"

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--cpus', 1]
    vb.customize ['modifyvm', :id, '--memory', 2096]
  end

  N = 4

  (1..N).each do |node_id|
    config.vm.define "node#{node_id}" do |node|
      node.vm.hostname = "node#{node_id}"
      node.vm.network "private_network", ip: "192.168.242.#{50+node_id}"
      node.vm.provision "shell" do |s|
        s.path = "vagrant/provision.sh"
        s.args = "node#{node_id}"
      end

      if node_id == N
        node.vm.provision :ansible do |ansible|
          ansible.playbook = "vagrant.yml"
          ansible.limit = 'all'
          ansible.inventory_path = "vagrant/vagrant-inventory"
        end
      end
    end
  end

end

