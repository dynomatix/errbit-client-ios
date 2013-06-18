class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    nav = UINavigationController.alloc.initWithRootViewController(ProblemsController.alloc.init)
    nav.wantsFullScreenLayout = true
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = nav
    @window.makeKeyAndVisible

    @settings = NSUserDefaults.standardUserDefaults
    ensure_credentials
    true
  end

  def ensure_credentials
    if credentials = @settings.dictionaryForKey('credentials')
    else
      show_credentials_dialog
    end
  end

  def show_credentials_dialog
    alert = UIAlertView.alloc.initWithTitle "NoCredentials"
    alert.show
  end
end
