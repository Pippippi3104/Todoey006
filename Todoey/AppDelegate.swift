//
//  AppDelegate.swift
//  Todoey
//
//  Created by DX推進 on 2020/07/29.
//  Copyright © 2020 DX推進. All rights reserved.
//

// CoreDataのimportが必要
import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    
    // MARK: UISceneSession Lifecycle
    
    func applicationWillTerminate(_ application: UIApplication){
        self.saveContext()
    }

    
    // MARK: - Core Data stack
    
    //CoreDataを新規で作成、必要な部分をコピー＆ペースト
    //・名称について
    //      OOP World   /   CoreData World   /   Database World
    //    ・Class       =   Entity           =   Table
    //    ・Property    =   Attribute        =   Field
    lazy var persistentContainer: NSPersistentContainer = {
        
        // name = DBファイルの名前
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
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

