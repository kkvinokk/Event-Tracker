//
//  Singleton.swift
//  Event Tracker
//
//  Created by Anand on 17/10/16.
//  Copyright © 2016 Vinoth. All rights reserved.
//

import Foundation


class Singleton: NSObject {
    
    
    
    static let sharedInstance = Singleton()
    var name: NSString = "-1"
    var dataOfArray: [[String: String]] =  [[String: String]]()
    
}


