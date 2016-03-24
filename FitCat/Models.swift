//
//  Models.swift
//  FitCat
//
//  Created by LiMaggie on 3/22/16.
//  Copyright © 2016 Akshay Tata. All rights reserved.
//

import UIKit

class Food: NSObject {
    var name:String
    var calories: String
    var amount: String
    var fat: String
    var fiber: String
    var protein: String
    var sugar: String
    
    init(name: String, calories: String, amount: String, fat:String, fiber:String, protein: String, sugar: String){
        self.name = name
        self.calories = calories
        self.amount = amount
        self.fat = fat
        self.fiber = fiber
        self.protein = protein
        self.sugar = sugar
    }
}

class Feed: NSObject{
    var calories: String
    var date: String
    var foodname: String
    
    init(calories: String, date: String, foodname: String) {
        self.calories = calories
        self.date = date
        self.foodname = foodname
    }
}
