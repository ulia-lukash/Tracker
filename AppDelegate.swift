//
//  AppDelegate.swift
//  Tracker
//
//  Created by Uliana Lukash on 25.11.2023.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DaysValueTransformer.register()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        ValueTransformer.setValueTransformer(
            DaysValueTransformer(),
            forName: NSValueTransformerName("DaysValueTransformer")
        )
      let container = NSPersistentContainer(name: "Tracker")
      // swiftlint:disable:next trailing_closure unused_closure_parameter
      container.loadPersistentStores(completionHandler: { storeDescription, error in
        if let error = error as NSError? {
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
          let nserror = error as NSError
          fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
      }
    }
}

