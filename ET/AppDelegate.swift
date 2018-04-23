//
//  AppDelegate.swift
//  ET
//
//  Created by njoool  on 29/01/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import IQKeyboardManagerSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let NOTIFICATION_URL = "https://gcm-http.googleapis.com/gcm/send"
    static var DEVICEID = String()
    static let SERVERKEY = "AAAA2GVWX4g:APA91bFwFrWxKWEpRRY9S-Zd4ZQH_SUzWuzoGTcSyPREyzeI7i7mSYljTIi2-1xlfqjONq0b4dZQEqwLLBOaxO9B4T06D7Mk-9oaEotNYc9tWNUPhq-q_uv9Zu4VpnotffYuAZU-o_am"
    var ref:DatabaseReference?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        self.ref=Database.database().reference()
        IQKeyboardManager.shared.enable = true
        UNUserNotificationCenter.current().delegate=self
        UNUserNotificationCenter.current().requestAuthorization(options:[.alert,.sound]) { (success, error) in
            if error != nil {
                print("no auth")
                
            }  else{
                print("Auth")
            }
        }
        application.registerForRemoteNotifications()
        return true
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ET")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        guard  let newToken = InstanceID.instanceID().token() else {return}
        AppDelegate.DEVICEID = newToken
        if let user=Auth.auth().currentUser?.uid{
           // ref.child("Users/\(user)").child("token").setValue(token)
            ref?.child("Customers/\(user)").observe(.value, with: { (snapshot) in
                if snapshot.exists(){
                    self.ref?.child("Customers/\(user)").child("token").setValue(newToken)
                }else{
                    self.ref?.child("ServiceProviders/\(user)").child("token").setValue(newToken)
                }
            })
        }
        connectToFCM()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        guard let token = InstanceID.instanceID().token() else {return}        
        AppDelegate.DEVICEID = token
        if let user=Auth.auth().currentUser?.uid{
            ref?.child("Customers/\(user)").observe(.value, with: { (snapshot) in
                if snapshot.exists(){
                    self.ref?.child("Customers/\(user)").child("token").setValue(token)
                }else{
                    self.ref?.child("ServiceProviders/\(user)").child("token").setValue(token)
                }
            })
        }
        print("token!!!!!",token)
        connectToFCM()
    }
    func connectToFCM(){Messaging.messaging().shouldEstablishDirectChannel = true}
}
extension AppDelegate:UNUserNotificationCenterDelegate{

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

