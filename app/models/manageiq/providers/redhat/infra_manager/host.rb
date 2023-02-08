ManageIQ::Providers::Ovirt::InfraManager::Host.include(ActsAsStiLeafClass)

class ManageIQ::Providers::Redhat::InfraManager::Host < ManageIQ::Providers::Ovirt::InfraManager::Host
  def provider_object(connection = nil)
    ManageIQ::Providers::Redhat::InfraManager::OvirtServices::V4.new(:ems => ext_management_system).get_host_proxy(self, connection)
  end

  supports :update
  supports :quick_stats do
    unless ext_management_system.supports?(:quick_stats)
      unsupported_reason_add(:quick_stats, 'RHV API version does not support quick_stats')
    end
  end

  def params_for_update
    {
      :fields => [
        {
          :component => 'sub-form',
          :id        => 'endpoints-subform',
          :name      => 'endpoints-subform',
          :title     => _("Endpoints"),
          :fields    => [
            :component => 'tabs',
            :name      => 'tabs',
            :fields    => [
              {
                :component => 'tab-item',
                :id        => 'remote-tab',
                :name      => 'remote-tab',
                :title     => _('Remote Login'),
                :fields    => [
                  {
                    :component  => 'validate-host-credentials',
                    :id         => 'endpoints.remote.valid',
                    :name       => 'endpoints.remote.valid',
                    :skipSubmit => true,
                    :isRequired => true,
                    :fields     => [
                      {
                        :component  => "text-field",
                        :id         => "authentications.remote.userid",
                        :name       => "authentications.remote.userid",
                        :label      => _("Username"),
                        :isRequired => true,
                        :validate   => [{:type => "required"}],
                      },
                      {
                        :component  => "password-field",
                        :id         => "authentications.remote.password",
                        :name       => "authentications.remote.password",
                        :label      => _("Password"),
                        :type       => "password",
                        :isRequired => true,
                        :validate   => [{:type => "required"}],
                        :helperText => _('Required if SSH login is disabled for the Default account.')
                      },
                    ],
                  },
                ],
              },
              {
                :component => 'tab-item',
                :id        => 'ws-tab',
                :name      => 'ws-tab',
                :title     => _('Web Service'),
                :fields    => [
                  {
                    :component  => 'validate-host-credentials',
                    :id         => 'endpoints.ws.valid',
                    :name       => 'endpoints.ws.valid',
                    :skipSubmit => true,
                    :isRequired => true,
                    :fields     => [
                      {
                        :component  => "text-field",
                        :id         => "authentications.ws.userid",
                        :name       => "authentications.ws.userid",
                        :label      => _("Username"),
                        :isRequired => true,
                        :validate   => [{:type => "required"}],
                      },
                      {
                        :component  => "password-field",
                        :id         => "authentications.ws.password",
                        :name       => "authentications.ws.password",
                        :label      => _("Password"),
                        :type       => "password",
                        :isRequired => true,
                        :validate   => [{:type => "required"}],
                        :helperText => _('Used for access to Web Services.')
                      },
                    ],
                  },
                ],
              },
            ]
          ]
        },
      ]
    }
  end

  def self.display_name(number = 1)
    n_('Host (Redhat)', 'Hosts (Redhat)', number)
  end
end
