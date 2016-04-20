//
//  FeedingDetailViewController.swift
//  
//
//  Created by LiMaggie on 3/23/16.
//
//

import UIKit
import Firebase
class FeedingDetailViewController: UIViewController, UINavigationControllerDelegate {
    var food : Food?
    /* food info */
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var fat: UILabel!
    @IBOutlet weak var fiber: UILabel!
    @IBOutlet weak var sugar: UILabel!
    @IBOutlet weak var protein: UILabel!
    @IBOutlet weak var catName: UITextField!
    
    /* date */
    @IBOutlet weak var date: UITextField!
    var datePicker = UIDatePicker()
    let dateFormatter : NSDateFormatter = NSDateFormatter()
    var mydate : NSDate = NSDate()
    /* catname */
    var catNameArr = [String]()
    var ref = Firebase(url: "https://fitcat.firebaseio.com/users")
    var u_name = floginobj.f_id
    var picker1 = UIPickerView()
    
    // feeding
    var feedingRecord = ["date":"3/23/16","foodname":"none","calories":"100"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if food != nil {
            name.text = food?.name
            amount.text = food?.amount
            calories.text = food?.calories
            fat.text = food?.fat
            fiber.text = food?.fiber
            sugar.text = food?.sugar
            protein.text = food?.protein
        }
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
        picker1.delegate = self
        picker1.dataSource = self
        catName.inputView = picker1
        
    }

    
    @IBAction func saveBT(sender: AnyObject) {
       save()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func save() {
        if (catName.text != nil && catName.text != "") {
            ref = Firebase(url: "https://fitcat.firebaseio.com/users/" +  (u_name) + "/" + (catName.text)!)
            let uuid = NSUUID().UUIDString
            let path = "feeding" + "/" + uuid
            let app = ref.childByAppendingPath(path)
            feedingRecord["date"] = date.text
            feedingRecord["foodname"] = food?.name
            feedingRecord["calories"] = food?.calories
            app.setValue(feedingRecord)
        }
    }
    // date
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
        // Dispose of any resources that can be recreated.
    }
}

extension FeedingDetailViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    //piker
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
    /*
    // MARK: - Navigation
 
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    } 
    */


