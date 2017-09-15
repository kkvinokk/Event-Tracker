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
    
    @IBAction func submitButton(_ sender: AnyObject) {
        
        if txtName.text == "" {
            
            let alertView = UIAlertController(title: "Please enter your name", message: nil, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertView, animated: true, completion: nil)

        }else{
            
            Singleton.sharedInstance.name = (txtName.text?.lowercased())! as NSString
            
            let appDelegate =
                UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Device")
            
            do {
                let results =
                    try managedContext.fetch(fetchRequest)
                
                if results.count != 0 {
                    
                    for result in results {
                        
                        if (result as AnyObject).value(forKey: "name") as! String == Singleton.sharedInstance.name as String {
                            
                            let data = (result as AnyObject).value(forKey: "dataOfArray") as! Data
                            let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with: data)
                            let arrayObject = unarchiveObject as AnyObject! as! [[String: String]]
                            Singleton.sharedInstance.dataOfArray = arrayObject
                        }
                    }
                    
                }
                
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let eventListViewControllerOBJ = storyboard.instantiateViewController(withIdentifier: "eventListViewController")
            self.navigationController!.pushViewController(eventListViewControllerOBJ, animated: true)
            
        }
        
    }
}
