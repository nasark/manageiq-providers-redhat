class ManageIQ::Providers::Redhat::Inventory::Parser::InfraManager < ManageIQ::Providers::Ovirt::Inventory::Parser::InfraManager

  def datacenters
    collector.datacenters.each do |datacenter|
      ems_ref = ManageIQ::Providers::Redhat::InfraManager.make_ems_ref(datacenter.href)

      persister.ems_folders.find_or_build('root_dc').assign_attributes(
        :name    => 'Datacenters',
        :type    => 'ManageIQ::Providers::Redhat::InfraManager::Folder',
        :uid_ems => 'root_dc',
        :hidden  => true,
        :parent  => nil,
      )

      uid = datacenter.id
      persister.ems_folders.find_or_build(ems_ref).assign_attributes(
        :name    => datacenter.name,
        :type    => 'ManageIQ::Providers::Redhat::InfraManager::Datacenter',
        :ems_ref => ems_ref,
        :uid_ems => uid,
        :parent  => persister.ems_folders.lazy_find("root_dc")
      )

      host_folder_uid = "#{uid}_host"
      persister.ems_folders.find_or_build(host_folder_uid).assign_attributes(
        :name    => 'host',
        :type    => 'ManageIQ::Providers::Redhat::InfraManager::Folder',
        :uid_ems => host_folder_uid,
        :hidden  => true,
        :parent  => persister.ems_folders.lazy_find(ems_ref)
      )

      vm_folder_uid = "#{uid}_vm"
      persister.ems_folders.find_or_build(vm_folder_uid).assign_attributes(
        :name    => 'vm',
        :type    => 'ManageIQ::Providers::Redhat::InfraManager::Folder',
        :uid_ems => vm_folder_uid,
        :hidden  => true,
        :parent  => persister.ems_folders.lazy_find(ems_ref)
      )
    end
  end
end
