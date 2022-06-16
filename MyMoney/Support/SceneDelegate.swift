//
//  SceneDelegate.swift
//  ExpenseTracker
//
//  Created by Piyush Mandaliya on 2022-03-10.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private(set) static var shared: SceneDelegate?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        Self.shared = self
        
        guard let windowScene = (scene as? UIWindowScene) else { return }

        self.window = UIWindow(windowScene: windowScene)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootVC: UIViewController?
        
        if AppManager.shared.isFirstLaunch {
            rootVC = storyboard.instantiateViewController(identifier: "onBoardViewController") as? OnBoardViewController
            AccountManager().initDefaultValue()
            CategoryManager().initDefaultValue()
            AppManager.shared.isFirstLaunch = true
            
        }else{
            rootVC = storyboard.instantiateViewController(identifier: "tapBarViewController")
        }

        let rootNC = UINavigationController(rootViewController: rootVC!)
        self.window?.rootViewController = rootNC
        rootVC?.navigationController?.setNavigationBarHidden(true, animated: false)
        self.window?.makeKeyAndVisible()
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        StorageManager().save()
    }


}

