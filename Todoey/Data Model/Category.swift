//
//  Category.swift
//  Todoey
//
//  Created by Oluwakamiye Akindele on 01/10/2019.
//  Copyright © 2019 Oluwakamiye Akindele. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var categoryName: String = ""
    let items  = List<Item>()
}
