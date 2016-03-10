//
//  InfoViewController.swift
//  FitCat
//
//  Created by LiMaggie on 3/2/16.
//  Copyright © 2016 Akshay Tata. All rights reserved.
//

import UIKit
import Firebase

class InfoViewController: UIViewController {
    
    var ref = Firebase(url: "https://fitcat.firebaseio.com/users")
    var u_name = floginobj.f_id

    @IBOutlet weak var catImage: UIImageView!
   
    @IBOutlet weak var catName: UILabel!
   
    @IBOutlet weak var bcsSliderOutlet: UISlider!
    @IBOutlet weak var bcsScore: UILabel!
    
    
    @IBOutlet weak var targetDateLabel: UILabel!
    
    @IBOutlet weak var startingBCSLabel: UILabel!
    
    @IBOutlet weak var startWeightLabel: UILabel!
    
    
    @IBOutlet weak var targetWeightLossLabel: UILabel!
    
    @IBOutlet weak var weightLossLabel: UILabel!
    
    
    //This is cat weight in pounds
    @IBOutlet weak var catWeight: UITextField!
    
    //This text stores Plan Start Date
    @IBOutlet weak var planStartDateText: UITextField!
    
    //Picker view for data
    var planStartDatePicker = UIDatePicker()
    
    //Change the value of slider on dragging it, It stores the body condition index for the cat
    @IBAction func bcsSlider(sender: AnyObject) {
        
        let sliderValue =   Int(self.bcsSliderOutlet.value)
        bcsScore.text = String(sliderValue)
        
    }
    
    //Called when the date value is changed in the date picker
    func dateChanged(datePicker: UIDatePicker)
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        planStartDateText.text = dateFormatter.stringFromDate(datePicker.date)
    }
    
    //Button Action to create Plan
    @IBAction func createfitPlan(sender: AnyObject) {
        
        //Add months to date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "mm-dd-yyyy"
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        let cal = NSCalendar.currentCalendar()

        var plandateinDateFormat = dateFormatter.dateFromString(planStartDateText.text!)

      
        //∆BCS * (.075/.01)
        
        let bcsIntValuedelta = Int(bcsScore.text!)! - 5
        
        let totalWeight =  Double(bcsIntValuedelta) * 0.075 * Double(catWeight.text!)!
        
        let totalMonths = totalWeight / (0.01 * Double(catWeight.text!)!)
        
    let totalMonthsinInt = Int(round(totalMonths))
        
    var years:Int = 1
    var monthCat:Int = 1
    if (totalMonthsinInt > 12)
    {
        years = totalMonthsinInt/12
        monthCat = totalMonthsinInt - (12 * years)
        
       plandateinDateFormat =  cal.dateByAddingUnit(.Year, value: years, toDate: plandateinDateFormat!, options: [])
    plandateinDateFormat = cal.dateByAddingUnit(.Month, value: monthCat, toDate: plandateinDateFormat!, options: [])
        

    }
        else
    {
                monthCat = totalMonthsinInt
        plandateinDateFormat = cal.dateByAddingUnit(.Month, value: monthCat, toDate: plandateinDateFormat!, options: [])

    }
        
    targetDateLabel.text = dateFormatter.stringFromDate(plandateinDateFormat!)
    startingBCSLabel.text = bcsScore.text
    startWeightLabel.text = catWeight.text! + " lbs"
    targetWeightLossLabel.text = String(totalWeight) + "lbs"
    weightLossLabel.text = "0 lbs"
    
        
    //Push in Firebase Database
    ref = Firebase(url: "https://fitcat.firebaseio.com/users/" +  (u_name))
    let app   = ref.childByAppendingPath(name)
    app.updateChildValues(["catTargetEndDate" : String(targetDateLabel.text!)])
    app.updateChildValues(["catWeight" : catWeight.text!])
    app.updateChildValues(["catBCS" : String(bcsScore.text!)])
    app.updateChildValues(["catTargetWeightLoss" : String(totalWeight)])
    app.updateChildValues(["catWeightLoss" : "0"])
    
        
    
       
    }
    var name : String?
    var image : NSData?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Changing the dimensions of catImage
        catImage.layer.cornerRadius = catImage.frame.size.width / 2
        catImage.layer.masksToBounds = true
        
        //Setting the default body condition index which is 8
        bcsScore.text = "8"
        
        //Set plan start date to date-picker view
        planStartDatePicker.datePickerMode = UIDatePickerMode.Date
        planStartDateText.inputView = planStartDatePicker
        
        //Adding target to planStartDatePicker
        planStartDatePicker.addTarget(self, action: Selector("dateChanged:"), forControlEvents: UIControlEvents.ValueChanged)

        
        if(name != nil && image != nil){
            navigationController?.title = name
            catImage?.image = UIImage(data: image!)
            catName.text = name
        }
        
       /* let str = "https://fitcat.firebaseio.com/users/" +  (u_name) + "/"+name!+".json"
        let reposURL = NSURL(string: str)
        
        
        if let JSONData = NSData(contentsOfURL: reposURL!)
        {
            do
            {
                if let json = try NSJSONSerialization.JSONObjectWithData(JSONData, options: []) as? NSDictionary {
                    
                    if let reposArray = json[name!] as? [String: AnyObject] {
                        // 5
                        for (cat_name_param, val) in reposArray {
                            
                            if(cat_name_param == "catBCS" || cat_name_param == "catTargetEndDate" || cat_name_param == "catWeight"||cat_name_param == "catTargetWeightLoss"||cat_name_param == "catWeightLoss")
                            {
                               /* targetDateLabel.text =
                                startingBCSLabel.text =
                                startWeightLabel.text =  + " lbs"
                                targetWeightLossLabel.text =
                                weightLossLabel.text = "0 lbs"
                                    */

                                
                            }
                            
                        }
                    }
                    
                }
                
            }catch let error as NSError{
                print(error.localizedDescription)
            }
        }
        
        */
        
        
         // targetDateLabel.text = app["catTargetEndDate"]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
