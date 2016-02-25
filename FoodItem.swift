//
//  FoodItem.swift
//  Created by scbai

import UIKit

class FoodItem: NSObject
{
    var name: String {
        get {
            return _name!
        }
    }
    
    private var _name: String?
    
    var joules: Double {
        get {
            return _joules!
        }
    }
    
    private var _joules: Double?
    
    class func foodItem(name: String, joules: Double) -> FoodItem
    {
        let item: FoodItem = FoodItem(name: name, joules: joules)
        
        return item
    }
    
    init(name: String, joules: Double) {
        super.init()
        
        self._name = name
        self._joules = joules
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if object!.isKindOfClass(object_getClass(FoodItem)) {
            return (object!.joules == self.joules) && (object!.name == self.name)
        }
        
        return false
    }
}
