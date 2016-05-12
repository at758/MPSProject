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
    var carb: String
    var fat: String
    var fiber: String
    var protein: String
    var moisture: String
    var kcalPerCap:String
    var kcalPerKg:String
    
    init(name: String, carb: String,fat:String, fiber:String, protein: String, moisture: String,kcalPerCap:String, kcalPerKg:String){
        self.name = name
        self.carb = carb
        self.fat = fat
        self.fiber = fiber
        self.protein = protein
        self.moisture = moisture
        self.kcalPerCap = kcalPerCap
        self.kcalPerKg = kcalPerKg
    }
}

class Feed: NSObject {
  var calories: String
  var date: String
  var foodname: String
  
  init(calories: String, date: String, foodname: String) {
    self.calories = calories
    self.date = date
    self.foodname = foodname
  }
}

class WeightRecord: NSObject {
  var date: String
  var weight: String
  
  init(date: String, weight: String) {
    self.date = date
    self.weight = weight
  }
}

