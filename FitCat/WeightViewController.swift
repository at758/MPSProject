//
//  WeightViewController.swift
//  FitCat
//
//  Created by Shunchang on 5/12/16.
//

import UIKit
import Firebase

class WeightViewController: UIViewController, UINavigationControllerDelegate,
  UITableViewDataSource, UITableViewDelegate,
  UITextFieldDelegate,
  UIPickerViewDataSource, UIPickerViewDelegate {
  
  /* cat information */
  var catNameArr = [String]()
  var ref = Firebase(url: "https://fitcat.firebaseio.com/users")
  var u_name = floginobj.f_id
  var picker1 = UIPickerView()
  
  /* feeding information */
  var weights: [WeightRecord] = []
  
  @IBOutlet weak var catName: UITextField!
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - TableView
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return weights.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCellWithIdentifier("feedcell") as UITableViewCell!
    // var curWeight : WeightRecord
    var curWeight = weights[indexPath.row] as WeightRecord
    
    let feedDate = cell.viewWithTag(301) as! UILabel
    // let feedName = cell.viewWithTag(302) as! UILabel
    let feedCalories = cell.viewWithTag(303) as! UILabel
    
    feedDate.text = curWeight.date
    // feedName.text = myfeed.foodname
    feedCalories.text = curWeight.weight
    return cell
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
    updateFeed()
  }
  
  // update feed information
  func updateFeed() {
    let name = catName.text
    weights.removeAll()
    var str = "https://fitcat.firebaseio.com/users/" +  (u_name) + "/" + (name!)
    str = str.stringByReplacingOccurrencesOfString(" ", withString: "%20")
  
    let reposURL1 = NSURL(string: str + "/catWeight.json")
    let reposURL2 = NSURL(string: str + "/feeding.json")
    
    if let JSONData1 = NSData(contentsOfURL: reposURL1!) {
      do {
        var w = try String(contentsOfURL: reposURL1!)
        if (w != "null" && w != "") {
          w = w.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
          print(w)
          
          let currentDate = NSDate()
          let dateFormatter = NSDateFormatter()
          dateFormatter.locale = NSLocale.currentLocale()
          dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
          var convertedDate = dateFormatter.stringFromDate(currentDate)
          
          dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
          convertedDate = dateFormatter.stringFromDate(currentDate)
          
          var element = WeightRecord(date: convertedDate, weight: w + " lbs");
          /*
          if let json = try NSJSONSerialization.JSONObjectWithData(JSONData2, options: []) as? NSDictionary {
            if let reposArray2 = json as? [String: AnyObject] {
              for (_, val) in reposArray2 {
                var feedDate = val["date"] as! String
                if (feedDate != "") {
                  element.date = feedDate
                }
              }
            }
          }*/
          weights.append(element)
        }
      } catch let error as NSError {
        print("Error: \(error)")
      }
      tableView.reloadData()
    }
  
    // to hide keyboard
    let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TrackingViewController.dismissKeyboard))
    tap.cancelsTouchesInView = true
    self.view.addGestureRecognizer(tap)
  }
  
  func dismissKeyboard() {
    self.view.endEditing(true)
    updateFeed()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
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