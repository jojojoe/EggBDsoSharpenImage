//
//  AppDelegate.swift
//  BDsoSharpenImage
//
//  Created by JOJO on 2023/7/4.
//

import UIKit
import TenjinSDK
import AppTrackingTransparency

/*
 产品名    Sharpen Image
 包名    com.sharpen.image
 App ID    6451093147
 Contact邮箱    EburhardtHomburg001@outlook.com
     
 Terms of Use    https://sites.google.com/view/sharpenimage-terms-of-use/home
 Privacy Policy    https://sites.google.com/view/sharpenimage-privacy-policy/home
 */

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        TenjinSDK.getInstance("D5HDNUEHUKUH1YEZGNWVXKJUJWZCZAMU")
        
#if DEBUG
// 打印所有字体名称
for familyName in UIFont.familyNames {
    let fontNames = UIFont.fontNames(forFamilyName: familyName)
    for fontName in fontNames {
        debugPrint("***fontName = \(fontName)")
    }
}

        TenjinSDK.debugLogs()
#endif
        
        
        
        BDsoSharSubscbeManager.default.completeTransactions()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    if status == .authorized {
                        TenjinSDK.connect()
                    }
                })
            } else {
                TenjinSDK.connect()
            }
        }

        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
         
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
         
    }


}

