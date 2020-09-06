//
//  Data.swift
//  Todoey
//
//  Created by 推進 dx on 2020/09/06.
//  Copyright © 2020 DX推進. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age : Int    = 0
}
