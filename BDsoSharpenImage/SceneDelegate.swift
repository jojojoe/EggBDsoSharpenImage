//
//  SceneDelegate.swift
//  BDsoSharpenImage
//
//  Created by JOJO on 2023/7/4.
//

import UIKit
import LGSideMenuController
import StoreKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let _ = BDsoToManager.default
        
        
        
        
        
        //
        guard let _ = (scene as? UIWindowScene) else { return }
        let currentVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"

        var showS = true
                
        if let saveVersion = UserDefaults.standard.string(forKey: "saveVersion") {
            if saveVersion == currentVersion {
                showS = false
            } else {
                UserDefaults.standard.set(currentVersion, forKey: "saveVersion")
            }
        } else {
            UserDefaults.standard.set(currentVersion, forKey: "saveVersion")
        }
        
#if DEBUG
//        showS = true
#endif
        
        if showS {
//            NEwBlueToolManager.default.isSplashBegin = true
            let splashVC = BDsoOpenGuideVC()
            let nav = UINavigationController.init(rootViewController: splashVC)
            nav.isNavigationBarHidden = true
            window?.rootViewController = nav
            window?.makeKeyAndVisible()
            splashVC.continueCloseBlock = {
                [weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    self.setupViewController(isShowingSplase: true)
                }
            }
        } else {
//            NEwBlueToolManager.default.isSplashBegin = false
            setupViewController(isShowingSplase: false)
        }
        
    }
    
    
    func setupViewController(isShowingSplase: Bool) {
        
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
        
        //
        BDsoSharSubscbeManager.default.checkIsPurchased {[weak self] purchased in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                debugPrint("purchased - \(purchased)")
                 
//                if isShowingSplase {
//                    SKStoreReviewController.requestReview()
//                } else {
                    if !BDsoSharSubscbeManager.default.inSubscription {
                        if isShowingSplase {
                            DispatchQueue.main.async {
//                                SKStoreReviewController.requestReview()
                            }
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                                [weak self] in
                                guard let `self` = self else {return}
                                
                                
                                let subsVC = BDsoSubscribeStoreVC()
                                subsVC.modalPresentationStyle = .fullScreen
                                vc.present(subsVC, animated: true)
                                subsVC.pageDisappearBlock = {
                                    [weak self] in
                                    guard let `self` = self else {return}
                                    DispatchQueue.main.async {
                                        SKStoreReviewController.requestReview()
                                    }
                                }
                            }
                        }
                        
                    } else {
                        NotificationCenter.default.post(
                            name: NSNotification.Name(rawValue: SubNotificationKeys.success),
                            object: nil,
                            userInfo: nil)
                        SKStoreReviewController.requestReview()
                    }
                }
                
//            }
        }
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

