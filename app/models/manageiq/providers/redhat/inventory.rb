class ManageIQ::Providers::Redhat::Inventory < ManageIQ::Providers::Inventory
  require_nested :Collector
  require_nested :Parser
  require_nested :Persister

  def self.default_manager_name
    "InfraManager"
  end
end
