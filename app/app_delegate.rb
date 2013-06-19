class AppDelegate
  attr_accessor :settings
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @problems = ProblemsController.alloc.init
    @nav = UINavigationController.alloc.initWithRootViewController(@problems)
    @nav.wantsFullScreenLayout = true
    @nav.delegate = self
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = @nav
    @window.makeKeyAndVisible

    @settings = NSUserDefaults.standardUserDefaults
    @problems.load_data if ensure_credentials
    true
  end

  def ensure_credentials
    if @settings.stringForKey('cookie')
      return true
    else
      show_credentials_dialog
      return false
    end
  end

  def show_credentials_dialog
    settings_controller = SettingsController.alloc.initController
    @nav.presentViewController(settings_controller, animated:true, completion: nil)
  end

  def test_user_credentials(server,username,password, &block)
    puts "Testing credentials... #{username}:[FILTERED] @ #{server}"
    credentials = {user: {email: username, password: password}}
    BW::HTTP.post("#{server}users/sign_in", {payload: credentials}) do |response|
      if response.ok?
        cookie = response.url.lastPathComponent !~ /sign_in/ ? response.headers['Set-Cookie'] : nil
        @settings.setObject(cookie, forKey:'cookie')
        @settings.synchronize
      end
      block.call cookie
    end
  end
end
