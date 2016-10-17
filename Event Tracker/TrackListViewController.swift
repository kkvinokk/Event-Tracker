//
//  TrackListViewController.swift
//  Event Tracker
//
//  Created by aryvart3 on 15/10/16.
//  Copyright © 2016 Vinoth. All rights reserved.
//
import UIKit
import CoreData

class TrackListViewController: UIViewController{
    
    var devices = [NSManagedObject]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
           let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(TrackListViewController.handleSwipes(_:)))
           rightSwipe.direction = .Right
           view.addGestureRecognizer(rightSwipe)
        tableView.editing = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Singleton.sharedInstance.dataOfArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if let theLabel = cell.viewWithTag(1) as? UILabel {
            theLabel.text = Singleton.sharedInstance.dataOfArray[indexPath.row]["name"]
        }
        
        if let theImageView = cell.viewWithTag(5) as? UIImageView {
            theImageView.image = UIImage(imageLiteral: Singleton.sharedInstance.dataOfArray[indexPath.row]["image"]!)
        }
        if let placeLabel = cell.viewWithTag(2) as? UILabel {
            placeLabel.text = Singleton.sharedInstance.dataOfArray[indexPath.row]["location"]
        }
        if let dateLabel = cell.viewWithTag(3) as? UILabel {
            
            if Singleton.sharedInstance.dataOfArray[indexPath.row]["type"] == "p" {
                dateLabel.text = "Paid"
            }else{
                dateLabel.text = "Free"
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.Blue
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let DetailEventViewControllerrOBJ = self.storyboard!.instantiateViewControllerWithIdentifier("detailEventViewController") as! DetailEventViewController
        DetailEventViewControllerrOBJ.selEventDetails = Singleton.sharedInstance.dataOfArray[indexPath.row]
        self.navigationController!.pushViewController(DetailEventViewControllerrOBJ, animated: true)
    }
    
    
    
    
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        let itemToMove = Singleton.sharedInstance.dataOfArray[fromIndexPath.row]
        Singleton.sharedInstance.dataOfArray.removeAtIndex(fromIndexPath.row)
        Singleton.sharedInstance.dataOfArray.insert(itemToMove, atIndex: toIndexPath.row)
    }
    
    
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            Singleton.sharedInstance.dataOfArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    // MARK: - Button Action

    @IBAction func editButton(sender: UIButton) {
        
        sender.selected = !sender.selected
        tableView.editing = !tableView.editing
        
        if !sender.selected {
            updateAll()
        }
    }
    
    func updateAll(){
        
            deleteAll()
            
            let appDelegate =
                UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let entity =  NSEntityDescription.entityForName("Device",
                                                            inManagedObjectContext:managedContext)
            let device = NSManagedObject(entity: entity!,
                                         insertIntoManagedObjectContext: managedContext)
            let data = NSKeyedArchiver.archivedDataWithRootObject(Singleton.sharedInstance.dataOfArray)
            device.setValue(Singleton.sharedInstance.name, forKey: "name")
            device.setValue(data, forKey: "dataOfArray")
            
            do {
                try managedContext.save()
                devices.append(device)
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
    }
    
    func deleteAll(){
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Device")
        do {
            let results =
                try managedContext.executeFetchRequest(request)
            if results.count != 0 {
                for result in results {
                    if result.valueForKey("name") as! String == Singleton.sharedInstance.name {
                        managedContext.deleteObject(result as! NSManagedObject)
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

