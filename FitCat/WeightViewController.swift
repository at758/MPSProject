//
//  WeightViewController.swift
//  FitCat
//
//  Created by Shunchang on 5/12/16.
//  Copyright © 2016 Akshay Tata. All rights reserved.
//

import UIKit
import Firebase

class WeightViewController: UIViewController, UINavigationControllerDelegate,
  UITableViewDataSource, UITableViewDelegate,
  UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
  
  /* cat information */
  var catNameArr = [String]()
  var ref = Firebase(url: "https://fitcat.firebaseio.com/users")
  var u_name = floginobj.f_id
  var picker1 = UIPickerView()
  
  /* weight record*/
  var weights: [WeightRecord] = []
  
  @IBOutlet weak var catName: UITextField!
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let reposURL = NSURL(string: "https://fitcat.firebaseio.com/users.json")
    if let JSONData = NSData(contentsOfURL: reposURL!) {
      do {
        if let json = try NSJSONSerialization.JSONObjectWithData(JSONData, options: []) as? NSDictionary {
          if let reposArray = json[u_name] as? [String: AnyObject] {
            for (cat_name, _) in reposArray {
              if (cat_name != "name") {
                catNameArr.append(cat_name)
              }
            }
          }
        }
      } catch let error as NSError {
        print(error.localizedDescription)
      }
    }
    if (catNameArr[0] != "") {
      catName.text = catNameArr[0]
    }
    picker1.delegate = self
    picker1.dataSource = self
    catName.delegate = self
    catName.inputView = picker1
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - TableView
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return weights.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
    var myweight : WeightRecord
    myweight = weights[indexPath.row] as WeightRecord
    
    let Date = cell.viewWithTag(301) as! UILabel
    let Weight = cell.viewWithTag(302) as! UILabel
    
    Date.text = myweight.date
    Weight.text = myweight.weight
    return cell
  }
  
  func dismissKeyboard() {
    self.view.endEditing(true)
  }
  
  // Mark: pickers
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
    return catNameArr.count
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    catName.text = catNameArr[row]
  }
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return catNameArr[row]
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    self.view.endEditing(true)
  }

}