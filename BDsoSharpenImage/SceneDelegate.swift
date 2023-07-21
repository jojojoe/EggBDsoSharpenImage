//
//  SceneDelegate.swift
//  BDsoSharpenImage
//
//  Created by JOJO on 2023/7/4.
//

import UIKit
import LGSideMenuController

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let _ = BDsoToManager.default
        //
        let vc = ViewController()
        let rootNavigationController = UINavigationController(rootViewController: vc)
        rootNavigationController.isNavigationBarHidden = true
        let leftViewController = BDsoShareSettingVC()
        let sideMenuController = LGSideMenuController(rootViewController: rootNavigationController, leftViewController: leftViewController)
        sideMenuController.leftViewPresentationStyle = .slideAbove
        sideMenuController.leftViewWidth = 310.0
        sideMenuController.isLeftViewSwipeGestureDisabled = true
        sideMenuController.isLeftViewStatusBarHidden = true
        sideMenuController.leftViewBackgroundEffectView?.isHidden = true
        self.window!.rootViewController = sideMenuController
        self.window!.makeKeyAndVisible()
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
         
    }


}

