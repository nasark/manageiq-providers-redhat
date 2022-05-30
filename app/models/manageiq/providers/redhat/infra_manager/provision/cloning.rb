module ManageIQ::Providers::Redhat::InfraManager::Provision::Cloning
  def find_destination_in_vmdb(ems_ref)
    if source.template?
      ManageIQ::Providers::Redhat::InfraManager::Vm.find_by(:name => dest_name, :ems_ref => ems_ref)
    else
      ManageIQ::Providers::Redhat::InfraManager::Template.find_by(:name => dest_name, :ems_ref => ems_ref)
    end
  end
end
