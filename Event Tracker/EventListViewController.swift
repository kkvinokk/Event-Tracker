//
//  EventListViewController.swift
//  Event Tracker
//
//  Created by aryvart3 on 15/10/16.
//  Copyright © 2016 Vinoth. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController{
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func segmentAction(sender: AnyObject) {
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            GridView.hidden=true
            ListView.hidden=false
            break
         case 1:
            ListView.hidden=true
             GridView.hidden=false
             break
        default:
            break; 
        }
    }
    
    @IBOutlet weak var ListView: UIView!
    @IBOutlet weak var GridView: UIView!
    
    var arrayOfEventDetails: [[String: String]] = [
        ["name": "Metallica Concert","image": "image1.png","location": "Palace Grounds","type": "p"],
        ["name": "Wine Tasting","image": "image2.png","location": "Links Brewery","type": "p"],
        ["name": "Summer Noon Party","image": "image3.png","location": "Electronic City","type": "p"],
        ["name": "Saree Exhibition ","image": "image4.png","location": "Sarjapur Road","type": "f"],
        ["name": "Impressions & Expressions","image": "image5.png","location": "Malleswaram Grounds","type": "p"],
        ["name": "Summer workshop","image": "image6.png","location": "Whitefield","type": "p"],
        ["name": "Wine Tasting","image": "image7.png","location": "MG Road","type": "p"],
        ["name": "Barbecue Fridays","image": "image8.png","location": "Links Brewery","type": "f"],
        ["name": "Impressions & Expressions","image": "image9.png","location": "Palace Grounds","type": "f"],
        ["name": "Metallica Concert","image": "image1.png","location": "Indiranagar","type": "p"],
        ["name": "Rock and Roll nights","image": "image2.png","location": "Electronic City","type": "p"],
        ["name": "Summer workshop","image": "image3.png","location": "Malleswaram Grounds","type": "p"],
        ["name": "Startups Meet","image": "image4.png","location": "Indiranagar","type": "f"],
        ["name": "Italian carnival","image": "image5.png","location": "Whitefield","type": "f"],
        ["name": "Summer Noon Party","image": "image6.png","location": "MG Road","type": "p"],
        ["name": "Wine Tasting","image": "image7.png","location": "Palace Grounds","type": "p"],
        ["name": "Barbecue Fridays","image": "image8.png","location": "Links Brewery","type": "f"],
        ["name": "Saree Exhibition ","image": "image9.png","location": "Kanteerava Indoor Stadium ","type": "p"],
        ["name": "Rock and Roll nights","image": "image1.png","location": "Sarjapur Road","type": "f"],
        ["name": "Impressions & Expressions","image": "image2.png","location": "Kumara Park","type": "p"],
        ["name": "Metallica Concert","image": "image3.png","location": "Links Brewery","type": "p"],
        ["name": "Italian carnival","image": "image4.png","location": "Electronic City","type": "p"],
        ["name": "Summer workshop","image": "image5.png","location": "Malleswaram Grounds","type": "f"],
        ["name": "Barbecue Fridays","image": "image6.png","location": "MG Road","type": "p"],
        ["name": "Italian carnival","image": "image7.png","location": "Links Brewery","type": "p"],
        ["name": "Wine Tasting","image": "image8.png","location": "Palace Grounds","type": "f"],
        ["name": "Rock and Roll nights","image": "image9.png","location": "Indiranagar","type": "p"],
        ["name": "Summer Noon Party","image": "image1.png","location": "Whitefield","type": "p"],
        ["name": "Metallica Concert","image": "image2.png","location": "Sarjapur Road","type": "f"],
        ["name": "Summer workshop","image": "image3.png","location": "Electronic City","type": "f"],
        ["name": "Startups Meet","image": "image4.png","location": "Malleswaram Grounds","type": "f"],
    ]
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let font = UIFont.systemFontOfSize(35)
        segmentControl.setTitleTextAttributes([NSFontAttributeName: font],
                                                forState: UIControlState.Normal)
        segmentControl.frame = CGRectMake(20, 23, self.view.frame.size.width - 40 , 60)

        GridView.hidden=true
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(EventListViewController.handleSwipes(_:)))
        leftSwipe.direction = .Left
        view.addGestureRecognizer(leftSwipe)
        tableView.editing = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let trackListViewController = storyboard.instantiateViewControllerWithIdentifier("trackListViewController")
        self.navigationController!.pushViewController(trackListViewController, animated: true)
    }
    
    // MARK: - Table View

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return arrayOfEventDetails.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        

        if let theLabel = cell.viewWithTag(1) as? UILabel {
            theLabel.text = arrayOfEventDetails[indexPath.row]["name"]
        }
        
        if let theImageView = cell.viewWithTag(5) as? UIImageView {
            theImageView.image = UIImage(imageLiteral: arrayOfEventDetails[indexPath.row]["image"]!)
        }
        if let placeLabel = cell.viewWithTag(2) as? UILabel {
            placeLabel.text = arrayOfEventDetails[indexPath.row]["location"]
        }
        if let dateLabel = cell.viewWithTag(3) as? UILabel {
            
            if arrayOfEventDetails[indexPath.row]["type"] == "p" {
                dateLabel.text = "Paid"
            }else{
                dateLabel.text = "Free"
            }
        }

        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let DetailEventViewControllerrOBJ = self.storyboard!.instantiateViewControllerWithIdentifier("detailEventViewController") as! DetailEventViewController
        DetailEventViewControllerrOBJ.selEventDetails = arrayOfEventDetails[indexPath.row]
        self.navigationController!.pushViewController(DetailEventViewControllerrOBJ, animated: true)
    }
    
    // MARK: - Collection View
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {

        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return arrayOfEventDetails.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        let DetailEventViewControllerrOBJ = self.storyboard!.instantiateViewControllerWithIdentifier("detailEventViewController") as! DetailEventViewController
        DetailEventViewControllerrOBJ.selEventDetails = arrayOfEventDetails[indexPath.row]
        self.navigationController!.pushViewController(DetailEventViewControllerrOBJ, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)

        if let theLabel = cell.viewWithTag(1) as? UILabel {
            theLabel.text = arrayOfEventDetails[indexPath.row]["name"]
        }
        
        if let theImageView = cell.viewWithTag(5) as? UIImageView {
            theImageView.image = UIImage(imageLiteral: arrayOfEventDetails[indexPath.row]["image"]!)
        }
        
        return cell
    }
    
}

