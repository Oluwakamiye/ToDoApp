//
//  Item.swift
//  Todoey
//
//  Created by Oluwakamiye Akindele on 01/10/2019.
//  Copyright © 2019 Oluwakamiye Akindele. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var itemName: String = ""
    @objc dynamic var isDone: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    @objc dynamic var dateCreated: Date = Date()
}
