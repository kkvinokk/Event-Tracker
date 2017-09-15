//
//  DetailEventViewController.swift
//  Event Tracker
//
//  Created by aryvart3 on 15/10/16.
//  Copyright © 2016 Vinoth. All rights reserved.
//

import UIKit
import CoreData

class DetailEventViewController: UIViewController {

    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var img_Picture: UIImageView!
    @IBOutlet var addToTrack: UIButton!
    @IBOutlet weak var lbl_Place: UILabel!
    @IBOutlet weak var lbl_PaidorFree: UILabel!
    
    var devices = [NSManagedObject]()
    var selEventDetails: [String: String]! //= [String: String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for EventDetails in Singleton.sharedInstance.dataOfArray {
            if NSDictionary(dictionary: EventDetails).isEqual(to: selEventDetails) {
                addToTrack.isSelected = true
            }
        }
        
        lbl_Title.text = selEventDetails["name"]
        img_Picture.image = UIImage(named: selEventDetails["image"]!)
        lbl_Place.text = selEventDetails["location"]
        if selEventDetails["type"] == "p" {
            lbl_PaidorFree.text = "Paid"
        }else{
            lbl_PaidorFree.text = "Free"
        }

        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(EventListViewController.handleSwipes(_:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Device")
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            devices = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

    }

    func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let trackListViewController = storyboard.instantiateViewController(withIdentifier: "trackListViewController")
        self.navigationController!.pushViewController(trackListViewController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Button Action
    
    @IBAction func backButton(_ sender: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func addTrackList(_ sender: AnyObject){
        
        if !addToTrack.isSelected {
            addToTrack.isSelected  = true
            var x = true
            for EventDetails in Singleton.sharedInstance.dataOfArray {
                if NSDictionary(dictionary: EventDetails).isEqual(to: selEventDetails) {
                    x = false
                }
            }
            
            if x==true {
                
                Singleton.sharedInstance.dataOfArray.append(selEventDetails)
                
                deleteAll()
                
                let appDelegate =
                    UIApplication.shared.delegate as! AppDelegate
                let managedContext = appDelegate.managedObjectContext
                let entity =  NSEntityDescription.entity(forEntityName: "Device",
                                                                in:managedContext)
                let device = NSManagedObject(entity: entity!,
                                             insertInto: managedContext)
                let data = NSKeyedArchiver.archivedData(withRootObject: Singleton.sharedInstance.dataOfArray)
                device.setValue(Singleton.sharedInstance.name, forKey: "name")
                device.setValue(data, forKey: "dataOfArray")
                do {
                    try managedContext.save()
                    devices.append(device)
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
            }

        }
        
    }
    
    func deleteAll(){
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Device")
        do {
            let results =
                try managedContext.fetch(request)
            if results.count != 0 {
                for result in results {
                    if (result as AnyObject).value(forKey: "name") as! String == Singleton.sharedInstance.name as String {
                        managedContext.delete(result as! NSManagedObject)
                    }
                }
                do {
                    try managedContext.save()
                    
                } catch {
                    print(error)
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
}







































