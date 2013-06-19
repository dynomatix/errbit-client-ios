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

    true
  end
end
