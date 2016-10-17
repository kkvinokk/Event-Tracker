//
//  InputViewController.swift
//  Event Tracker
//
//  Created by aryvart3 on 15/10/16.
//  Copyright © 2016 Vinoth. All rights reserved.
//

import UIKit
import CoreData

class InputViewController: UIViewController {

    @IBOutlet var txtName: UITextField!
    
    var devices = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
        // MARK: - Button Action
    
    @IBAction func submitButton(sender: AnyObject) {
        
        if txtName.text == "" {
            
            let alertView = UIAlertController(title: "Please enter your name", message: nil, preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "Done", style: .Default, handler: nil))
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertView, animated: true, completion: nil)

        }else{
            
            Singleton.sharedInstance.name = (txtName.text?.lowercaseString)!
            
            let appDelegate =
                UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let fetchRequest = NSFetchRequest(entityName: "Device")
            
            do {
                let results =
                    try managedContext.executeFetchRequest(fetchRequest)
                
                if results.count != 0 {
                    
                    for result in results {
                        
                        if result.valueForKey("name") as! String == Singleton.sharedInstance.name {
                            
                            let data = result.valueForKey("dataOfArray") as! NSData
                            let unarchiveObject = NSKeyedUnarchiver.unarchiveObjectWithData(data)
                            let arrayObject = unarchiveObject as AnyObject! as! [[String: String]]
                            Singleton.sharedInstance.dataOfArray = arrayObject
                        }
                    }
                    
                }
                
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let eventListViewControllerOBJ = storyboard.instantiateViewControllerWithIdentifier("eventListViewController")
            self.navigationController!.pushViewController(eventListViewControllerOBJ, animated: true)
            
        }
        
    }
}
