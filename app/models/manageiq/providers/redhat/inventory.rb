class ManageIQ::Providers::Redhat::Inventory < ManageIQ::Providers::Inventory
  def self.default_manager_name
    "InfraManager"
  end
end
