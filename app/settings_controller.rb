class SettingsController < Formotion::FormController
  SETTINGS_HASH = {
      title: "Application",
      persist_as: :account_settings,
      sections: [{
        title: "Errbit Login",
        rows: [{
          title: "Server",
          subtitle: "Errbit URL",
          type: :string,
          key: :server,
          auto_correction: :no,
          auto_capitalization: :none,
          placeholder: 'http://errbit.example.com/',
        }, {
          title: "Username",
          type: :string,
          key: :username,
          secure: false,
          auto_correction: :no,
          auto_capitalization: :none,
          placeholder: 'yuri@example.com'
        }, {
          title: "Password",
          type: :string,
          key: :password,
          secure: true,
          auto_correction: :no,
          auto_capitalization: :none,
          placeholder: 'Password'
        }]
      }, {
        rows: [{
          title: "Save",
          type: :submit,
        }]
      }]
    }

  def initController
    f = Formotion::Form.persist(SETTINGS_HASH)
    f.on_submit do |form|
      form.active_row && form.active_row.text_field.resignFirstResponder
      data = form.render
      server = data[:server]
      username = data[:username]
      password = data[:password]
      presentingViewController.delegate.test_user_credentials(server,username,password) do |cookie|
        alert = UIAlertView.alloc.init
        alert.addButtonWithTitle("OK")
        if cookie
          alert.title = "Connection Succeeded"
          alert.message = "Cool."
          presentingViewController.dismissViewControllerAnimated(true, completion:nil)
        else
          alert.title = "Connection Failed"
          alert.message = "Please verify your settings."
        end
        alert.show
      end
    end
    initWithForm(f)
  end
end
