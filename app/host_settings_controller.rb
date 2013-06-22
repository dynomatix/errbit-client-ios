class HostSettingsController < Formotion::FormController

  def settings_hash
    {
      title: "Errbit Server",
      persist_as: :account_settings,
      sections: [{
        title: "Errbit Login",
        rows: [{
          title: "Name",
          type: :string,
          key: :name,
          value: (@host_settings.name rescue ''),
          auto_correction: :no,
          auto_capitalization: :none,
          placeholder: 'Errbit Server',
        },{
          title: "Host",
          subtitle: "Errbit URL",
          type: :string,
          key: :server,
          value: (@host_settings.server rescue ''),
          auto_correction: :no,
          auto_capitalization: :none,
          placeholder: 'http://errbit.example.com/',
        }, {
          title: "Username",
          type: :string,
          key: :username,
          value: (@host_settings.username rescue ''),
          secure: false,
          auto_correction: :no,
          auto_capitalization: :none,
          placeholder: 'yuri@example.com'
        }, {
          title: "Password",
          type: :string,
          key: :password,
          value: (@host_settings.password rescue ''),
          secure: true,
          auto_correction: :no,
          auto_capitalization: :none,
          placeholder: 'Password'
        }]
      }]
    }
  end

  def initController(host_settings)
    @host_settings = host_settings
    @form = Formotion::Form.new(settings_hash)

    rightButton = UIBarButtonItem.alloc.initWithTitle("Save", style:UIBarButtonItemStyleDone, target:self, action:"save_button_pressed:")
    self.navigationItem.rightBarButtonItem = rightButton
    initWithForm(@form)
  end

  def save_button_pressed(sender)
    form_data = @form.render
    if (@host_settings.server rescue false)
      HostSettingsStore.shared.update_server(@host_settings) do |host|
        host.name = form_data[:name]
        host.server = form_data[:server]
        host.username = form_data[:username]
        host.password = form_data[:password]
      end
    else
      HostSettingsStore.shared.add_host do |host|
        # We set up our new Location object here.
        host.name = form_data[:name]
        host.server = form_data[:server]
        host.username = form_data[:username]
        host.password = form_data[:password]
      end
    end
    self.navigationController.popViewControllerAnimated true
  end
end
