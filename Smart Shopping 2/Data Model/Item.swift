//
//  Item.swift
//  Smart Shopping 2
//
//  Created by Chris Turner on 16/09/2019.
//  Copyright © 2019 Coding From Scratch. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var staple : Bool = false
    @objc dynamic var newlyAddedItem : Bool = false
    @objc dynamic var meal : Bool = false
    @objc dynamic var done : Bool = false
    var parentCategory = LinkingObjects(fromType: Meal.self, property: "items")
}
