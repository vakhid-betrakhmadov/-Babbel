import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions)
    {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = window ?? UIWindow(windowScene: windowScene)
        window?.rootViewController = rootViewController()
        window?.makeKeyAndVisible()
    }
    
    private func rootViewController() -> UIViewController {
        let wordGameAssembly = WordGameAssemblyImpl()
        let (wordGameInterface, wordGameViewController) = wordGameAssembly.assemble()
        wordGameInterface.onFinish = {
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            exit(0)
        }
        return wordGameViewController
    }
}
