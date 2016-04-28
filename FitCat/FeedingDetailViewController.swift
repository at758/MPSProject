/* 
 FeedingDetailViewController.swift
 
 Created by Li Maggie on 3/23/16.
 Refactored by Shunchang Bai 
 */

import UIKit
import Firebase

class FeedingDetailViewController: UIViewController, UINavigationControllerDelegate {
  var food : Food?
  
  /* food information */
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var kcalKg: UILabel!
  @IBOutlet weak var kcalCup: UILabel!
  @IBOutlet weak var fat: UILabel!
  @IBOutlet weak var fiber: UILabel!
  @IBOutlet weak var protein: UILabel!
  @IBOutlet weak var catName: UITextField!
    @IBOutlet weak var moisture: UILabel!
    @IBOutlet weak var carb: UILabel!
    /* date information */
  @IBOutlet weak var date: UITextField!
  var datePicker = UIDatePicker()
  let dateFormatter: NSDateFormatter = NSDateFormatter()
  var mydate: NSDate = NSDate()
    
  /* cat information */
  var catNameArr = [String]()
  var ref = Firebase(url: "https://fitcat.firebaseio.com/users")
  var u_name = floginobj.f_id
  var pickerOne = UIPickerView()
    
  /* feeding */
  var feedingRecord = ["date":"3/23/16","foodname":"none","calories":"100"]
  override func viewDidLoad() {
    super.viewDidLoad()
    if (food != nil) {
      name.text = food?.name
      kcalKg.text = food?.kcalPerKg
      kcalCup.text = food?.kcalPerCap
      fat.text = food?.fat
      fiber.text = food?.fiber
      moisture.text = food?.moisture
      protein.text = food?.protein
        carb.text = food?.carb
    }
    /* feeding date*/
    dateFormatter.dateFormat = "M/d/yy"
    date.text = self.dateFormatter.stringFromDate(self.mydate)
    datePicker.datePickerMode = UIDatePickerMode.Date
    date.inputView = datePicker
    datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
    
    let reposURL = NSURL(string: "https://fitcat.firebaseio.com/users.json")
    if let JSONData = NSData(contentsOfURL: reposURL!) {
      do {
        if let json = try NSJSONSerialization.JSONObjectWithData(JSONData, options: []) as? NSDictionary {
          if let reposArray = json[u_name] as? [String: AnyObject] {
            for (cat_name, _) in reposArray {
              if(cat_name != "name") {
                catNameArr.append(cat_name)
              }
            }
          }
        }
      } catch let error as NSError {
        print(error.localizedDescription)
      }
    }
    pickerOne.delegate = self
    pickerOne.dataSource = self
    catName.inputView = pickerOne
  }
  
  @IBAction func saveBT(sender: AnyObject) {
    save()
    self.navigationController?.popToRootViewControllerAnimated(true)
  }
  
  func save() {
    if (catName.text != "" && catName.text != nil) {
      ref = Firebase(url: "https://fitcat.firebaseio.com/users/" +  (u_name) + "/" + (catName.text)!)
      let uuid = NSUUID().UUIDString
      let path = "feeding" + "/" + uuid
      let app = ref.childByAppendingPath(path)
      feedingRecord["date"] = date.text
      feedingRecord["foodname"] = food?.name
      feedingRecord["calories"] = food?.kcalPerCap
      app.setValue(feedingRecord)
    }
  }
  
  /* date setting */
  func dateChanged(datePicker: UIDatePicker) {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
    date.text = dateFormatter.stringFromDate(datePicker.date)
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

extension FeedingDetailViewController: UIPickerViewDataSource, UIPickerViewDelegate {
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return catNameArr.count
  }
    
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    catName.text = catNameArr[row]
  }
    
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return catNameArr[row]
  }
}