//
//  WeightViewController.swift
//  FitCat
//
//  Created by Shunchang on 5/12/16.
//

import UIKit
import Firebase

class WeightViewController:
  UIViewController, UINavigationControllerDelegate,
  UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,
  UIPickerViewDataSource, UIPickerViewDelegate {
  
  /* cat information */
  var catNameArr = [String]()
  var ref = Firebase(url: "https://fitcat.firebaseio.com/users")
  var u_name = floginobj.f_id
  var picker1 = UIPickerView()
  
  /* feeding information */
  var weights: [WeightRecord] = []
  
  @IBOutlet weak var catWeight: UITextField!
  @IBOutlet weak var catName: UITextField!
  @IBOutlet weak var tableView: UITableView!
  
  var weightRecord = ["date":"05/12/2016","weight":""]
  
  // MARK: - TableView
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return weights.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCellWithIdentifier("feedcell") as UITableViewCell!
    weights.sortInPlace({$0.date > $1.date})

    let curWeight = weights[indexPath.row] as WeightRecord
    
    let Date = cell.viewWithTag(301) as! UILabel
    let Weight = cell.viewWithTag(303) as! UILabel
    
    Date.text = curWeight.date
    Weight.text = curWeight.weight + " lbs"
    return cell
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    weights.sortInPlace({$0.date > $1.date})
    tableView.dataSource = self
    tableView.delegate = self
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
    catWeight.delegate = self
    update()
  }
  
  // update weight information
  func save() {
    if (catName.text != "" && catName.text != nil && catWeight.text != "" && catWeight.text != nil) {
      ref = Firebase(url: "https://fitcat.firebaseio.com/users/" +  (u_name) + "/" + (catName.text)!)
      let uuid = NSUUID().UUIDString
      let path = "weightRecord" + "/" + uuid
      let path2 = "/"
      let app = ref.childByAppendingPath(path)
      let app2 = ref.childByAppendingPath(path2)
      let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .ShortStyle, timeStyle: .NoStyle)
      let num = Int(catWeight.text!)
      if (num != nil) {
        weightRecord["date"] = timestamp
        weightRecord["weight"] = catWeight.text!
        app.setValue(weightRecord)
        app2.updateChildValues(["catWeight" : catWeight.text!])
        catWeight.text! = ""
      }
    }
  }
  
  func update() {
    save()
    let name = catName.text
    weights.removeAll()
    var str = "https://fitcat.firebaseio.com/users/" +  (u_name) + "/" + (name!)
    str = str.stringByReplacingOccurrencesOfString(" ", withString: "%20")
    let reposURL2 = NSURL(string: str + "/weightRecord.json")
  
    if let JSONData2 = NSData(contentsOfURL: reposURL2!) {
      do {
        if let json = try NSJSONSerialization.JSONObjectWithData(JSONData2, options: []) as? NSDictionary {
          if let reposArray2 = json as? [String: AnyObject] {
            for (_, val) in reposArray2 {
              let myDate = val["date"] as! String
              let myWeight = val["weight"] as! String
              if (myDate != "" && myWeight != "") {
                let record = WeightRecord(date: myDate, weight: myWeight)
                weights.append(record)
              }
            }
          }
        }
      } catch let error as NSError {
        print(error.localizedDescription)
      }
      tableView.reloadData()
    }
  
    // to hide keyboard
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WeightViewController.dismissKeyboard))
    tap.cancelsTouchesInView = true
    self.view.addGestureRecognizer(tap)
  }
  
  /* Resign the focus after the return */
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.view.endEditing(true)
    update()
    return false
  }
    
  func dismissKeyboard() {
    self.view.endEditing(true)
    update()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // Mark: pickers
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
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    self.view.endEditing(true)
  }

}