//
//  Category.swift
//  Smart Shopping 2
//
//  Created by Chris Turner on 16/09/2019.
//  Copyright © 2019 Coding From Scratch. All rights reserved.
//

import Foundation
import RealmSwift

class Meal: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
