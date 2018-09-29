//
//  AppDelegate.swift
//  Heart-up
//
//  Created by 前田啓 on 2018/08/21.
//  Copyright © 2018年 kei maeda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //ログイン判定
        //復帰に関係なくバッジが0じゃなければ0にする
        if application.applicationIconBadgeNumber != 0{
            application.applicationIconBadgeNumber = 0
        }

        // Override point for customization after application launch.
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        Messaging.messaging().isAutoInitEnabled = true
        return true
    }
    
    
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//        print("Firebase registration token: \(fcmToken)")
        
        //userIdがあったらfcmTokenと一緒にポストする
        if let userId = UserDefaults.standard.string(forKey: "user_id"){
            PushToken.postToken(userId: userId, fcmToken: fcmToken, callback: { error in
                if let error = error as! [String: Any]? {
                    print(error)
                    print("fcm_tokenのpost失敗!")
                }
            })
        }
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
    
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    /// ログインからメインへストーリーボードを切り替えます.
    func showMainStoryboard() {
        let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = mainVC
    }
    
    //メインからログインストーリーボードに切り替え
    func showLoginStoryboard() {
        let loginVC = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = loginVC
    }

}

