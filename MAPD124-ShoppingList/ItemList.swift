//
//  ItemList.swift
//  MAPD124-ShoppingList
//
//  Created by Reza on 2017-03-03.
//  Copyright © 2017 Reza. All rights reserved.
//

import Foundation

import CoreData

@objc(ItemList)
class ItemList: NSManagedObject {
    @NSManaged var name:String?
    @NSManaged var qty:String?
    
}
