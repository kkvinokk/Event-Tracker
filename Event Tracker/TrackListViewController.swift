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
           rightSwipe.direction = .right
           view.addGestureRecognizer(rightSwipe)
        tableView.isEditing = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Singleton.sharedInstance.dataOfArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let theLabel = cell.viewWithTag(1) as? UILabel {
            theLabel.text = Singleton.sharedInstance.dataOfArray[indexPath.row]["name"]
        }
        
        if let theImageView = cell.viewWithTag(5) as? UIImageView {
            theImageView.image = UIImage(named: Singleton.sharedInstance.dataOfArray[indexPath.row]["image"]!)
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
        
        cell.selectionStyle = UITableViewCellSelectionStyle.blue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        let DetailEventViewControllerrOBJ = self.storyboard!.instantiateViewController(withIdentifier: "detailEventViewController") as! DetailEventViewController
        DetailEventViewControllerrOBJ.selEventDetails = Singleton.sharedInstance.dataOfArray[indexPath.row]
        self.navigationController!.pushViewController(DetailEventViewControllerrOBJ, animated: true)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, moveRowAtIndexPath fromIndexPath: IndexPath, toIndexPath: IndexPath) {
        
        let itemToMove = Singleton.sharedInstance.dataOfArray[fromIndexPath.row]
        Singleton.sharedInstance.dataOfArray.remove(at: fromIndexPath.row)
        Singleton.sharedInstance.dataOfArray.insert(itemToMove, at: toIndexPath.row)
    }
    
    
    
    func tableView(_ tableView: UITableView, canMoveRowAtIndexPath indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            Singleton.sharedInstance.dataOfArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    // MARK: - Button Action

    @IBAction func editButton(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        tableView.isEditing = !tableView.isEditing
        
        if !sender.isSelected {
            updateAll()
        }
    }
    
    func updateAll(){
        
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

