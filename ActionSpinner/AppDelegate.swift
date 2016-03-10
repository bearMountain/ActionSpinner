




import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //MARK: - AppDelegate Methods
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupWindow()
        setupRootVC()
        return true
    }
    
    func setupWindow() {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
    }
    
    func setupRootVC() {
        window?.rootViewController = ViewController()
    }

}

