class ManageIQ::Providers::Redhat::InfraManager::FuturesCollector < ManageIQ::Providers::Ovirt::InfraManager::FuturesCollector
  DEFAULT_PARALLEL_PROCESSING_CAPACITY = ::Settings.ems_refresh.rhevm.pipeline * ::Settings.ems_refresh.rhevm.connections

  def initialize(args)
    @keyed_futures_queue = []
    @keyed_requests_queue = []
    @parallel_processing_capacity = args[:batch_size] || DEFAULT_PARALLEL_PROCESSING_CAPACITY
    @result_hash = {}
  end
end
