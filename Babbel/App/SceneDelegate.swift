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
        let (_, wordGameViewController) = wordGameAssembly.assemble()
        return wordGameViewController
    }
}
