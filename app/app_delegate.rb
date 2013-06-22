class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @servers_controller = ServersController.alloc.init
    @navigation_controller = UINavigationController.alloc.initWithRootViewController(@servers_controller)
    @navigation_controller.wantsFullScreenLayout = true
    @navigation_controller.delegate = self
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = @navigation_controller
    @window.makeKeyAndVisible

    true
  end
end
