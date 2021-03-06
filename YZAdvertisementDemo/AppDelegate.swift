//
//  AppDelegate.swift
//  YZAdvertisementDemo
//
//  Created by zhang liangwang on 16/6/22.
//  Copyright © 2016年 zhangliangwang. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        self.window = UIWindow.init(frame:UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
        let nav = UINavigationController.init(rootViewController:ViewController.init())
        self.window!.rootViewController = nav
        
        
        let filePath = self.getFilePathWithImageName(UserDefaults.standard.value(forKey: kImageName) as? String)
        if self.isFileExistWithPath(filePath) {
            
            let adverView = YZLaunchAdverView.init(frame: self.window!.bounds, type: AdvertiseType.advertiseType_Full, imageUrl: filePath)
            adverView.show()
        }
        self.getAdvertisingImage()
        
        
        return true
    }
    
    

    /**
     *  判断文件是否存在
     */
    func isFileExistWithPath(_ filePath: String) -> Bool {
        
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: filePath)
    }
    
    func getAdvertisingImage() {
        
        let imageUrl = "http://imgsrc.baidu.com/forum/pic/item/9213b07eca80653846dc8fab97dda144ad348257.jpg"
        let imageName = imageUrl.components(separatedBy: "/").last
        let filePath = self.getFilePathWithImageName(imageName)
        if !self.isFileExistWithPath(filePath) {
            self.downloadAdImageWithUrl(imageUrl, imageName: imageName!)
        }
    }
    
    
    func downloadAdImageWithUrl(_ imageUrl: String,imageName: String) {
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async { 
            
            let url = URL(string: imageUrl)
            let data = try? Data.init(contentsOf: url!)
            print("-----",data)
            let image = UIImage.init(data: data!)
            
            let filePath = self.getFilePathWithImageName(imageName)
            if (((try? UIImagePNGRepresentation(image!)?.write(to: URL(fileURLWithPath: filePath), options: [.atomic])) != nil) != nil) {
                print("save success")
                self.deleteOldImage()
                UserDefaults.standard.setValue(imageName, forKey:kImageName)
                UserDefaults.standard.synchronize()
            } else {
                
            }
            
            
        }
    }
    
    /**
     *  删除旧图片
     */
    func deleteOldImage() {
        
        let imageName = UserDefaults.standard.value(forKey: kImageName)
        if (imageName != nil) {
            let filePath = self.getFilePathWithImageName(imageName as? String)
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(atPath: filePath)
            }catch {
                print("delete fair")
            }
            
        }
    }
    
    /**
     *  根据图片名拼接文件路径
     */
    func getFilePathWithImageName(_ imageName: String?) -> String {
        
        if (imageName != nil) {
        
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as NSArray
            let filePath = (paths[0] as! NSString).appendingPathComponent(imageName!)
            
            return filePath
        }
//
        return ""
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.tomtop.keepPage.YZAdvertisementDemo" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "YZAdvertisementDemo", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

