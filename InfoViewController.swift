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

    @IBOutlet weak var fitButton: UIButton!
    @IBOutlet weak var bcsScore: UILabel!
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var catName: UILabel!
    @IBOutlet weak var bcsSliderOutlet: UISlider!
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
    func dateChanged(datePicker: UIDatePicker) {
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
        //let currDate = plandateinDateFormat
      
        //∆BCS * (.075/.01)
        let bcsIntValuedelta = Int(bcsScore.text!)! - 5
        
        let totalWeight =  Double(bcsIntValuedelta) * 0.075 * Double(catWeight.text!)!
        
        let totalMonths = totalWeight / (0.01 * Double(catWeight.text!)!)
        let totalMonthsinInt = Int(round(totalMonths))
        var years:Int = 1
        var monthCat:Int = 1
        if (totalMonthsinInt > 12) {
            years = totalMonthsinInt/12
            monthCat = totalMonthsinInt - (12 * years)
            plandateinDateFormat =  cal.dateByAddingUnit(.Year, value: years, toDate: plandateinDateFormat!, options: [])
            plandateinDateFormat = cal.dateByAddingUnit(.Month, value: monthCat, toDate: plandateinDateFormat!, options: [])
        } else {
            monthCat = totalMonthsinInt
            plandateinDateFormat = cal.dateByAddingUnit(.Month, value: monthCat, toDate: plandateinDateFormat!, options: [])
        }
        
        /*for id in self.view.subviews as [UIView]{
            
            if (id.isMemberOfClass(UILabel))
            {
                id.hidden = true
            }
            
        }*/
        targetDateLabel.text = dateFormatter.stringFromDate(plandateinDateFormat!)
        startingBCSLabel.text = bcsScore.text
        startWeightLabel.text = catWeight.text! + " lbs"
        targetWeightLossLabel.text = String(totalWeight) + "lbs"
        weightLossLabel.text = "0 lbs"
    
        
        //Push in Firebase Database
        ref = Firebase(url: "https://fitcat.firebaseio.com/users/" +  (u_name))
        let app = ref.childByAppendingPath(name)
        app.updateChildValues(["catTargetEndDate" : String(targetDateLabel.text!)])
        app.updateChildValues(["catWeight" : catWeight.text!])
        app.updateChildValues(["catBCS" : String(bcsScore.text!)])
        app.updateChildValues(["catTargetWeightLoss" : String(totalWeight)])
        app.updateChildValues(["catWeightLoss" : "0"])
        
        
        //Checking if notification settings exist
        guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings() else { return }
        
        if settings.types == .None {
            let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            return
        }
        
        
        //Notifications : Set up
        //Daily Cat notifications
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 10)
        notification.alertTitle = "Reminder to input data"
        notification.repeatInterval  = NSCalendarUnit.Day
        notification.alertBody = "Please enter the total amount of food you fed \(catName.text!) today."
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["NotifTag": "forCatFood"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        //Notifications for Week
        let notificationMonth = UILocalNotification()
        notificationMonth.fireDate = NSDate(timeInterval: 3600 * 12, sinceDate: NSDate())
        notificationMonth.alertTitle = "Reminder to weigh cat"
        notificationMonth.repeatInterval  = NSCalendarUnit.WeekOfMonth
        notificationMonth.alertBody = "It’s that time of the month again! Please weigh \(catName.text!) and enter his weight into your database so that we can track the progress of the established weight loss plan."
        notificationMonth.soundName = UILocalNotificationDefaultSoundName
       notificationMonth.userInfo = ["NotifTag": "forCatWeight"]
        UIApplication.sharedApplication().scheduleLocalNotification(notificationMonth)
        
        
       
    }
    var name : String?
    var image : NSData?
    
    
    func textFieldDidChange(textField: UITextField) {
        //your code
        
       // print(catWeight.text?.characters.count)
        
       //  print(planStartDateText.text?.characters.count)
        
        if(catWeight.text?.characters.count > 0
            && planStartDateText.text?.characters.count > 0)
           {
            
            fitButton.enabled = true
        }
        else
        {
            fitButton.enabled = false
        }
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fitButton.enabled = false
        
         planStartDateText.addTarget(self, action: #selector(InfoViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.AllEditingEvents)
        
        
        catWeight.addTarget(self, action: #selector(InfoViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.AllEditingEvents)
        
        //Changing the dimensions of catImage
        catImage.layer.cornerRadius = catImage.frame.size.width / 2
        catImage.layer.masksToBounds = true
        
        //Setting the default body condition index which is 8
        bcsScore.text = "8"
        
        //Set plan start date to date-picker view
        planStartDatePicker.datePickerMode = UIDatePickerMode.Date
        planStartDateText.inputView = planStartDatePicker
        
        //Adding target to planStartDatePicker
        
        planStartDatePicker.addTarget(self, action: #selector(InfoViewController.dateChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        
        if(name != nil && image != nil){
            navigationController?.title = name
            catImage?.image = UIImage(data: image!)
            catName.text = name
        }
        
        
        var str = "https://fitcat.firebaseio.com/users/" +  (u_name) + "/" + (name!)
        str = str.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        let reposURL = NSURL(string: str + ".json")
        
       
        if let JSONData = NSData(contentsOfURL: reposURL!)
        {
            do
            {
                if let json = try NSJSONSerialization.JSONObjectWithData(JSONData, options: []) as? NSDictionary {
                    
                   
                        // 5
                    for (cat_name_param, val) in json{
                        
                        switch(cat_name_param as! String)
                        {
                            
                        case "catBCS":  startingBCSLabel.text = val as? String
                                            break
                        case "catTargetEndDate":  targetDateLabel.text = val as? String
                            break
                        case "catWeight":    startWeightLabel.text = (val as? String)! + " lbs"
                            break
                        case "catTargetWeightLoss":  targetWeightLossLabel.text = (val as? String)! + " lbs"
                            break
                        case "catWeightLoss":  weightLossLabel.text = (val as? String)! + " lbs"
                            break
                        default: break
                        }
                            
                        }
                    
                    
                }
                
            }  catch let error as NSError{
                print(error.localizedDescription)
            }
        }
        
        
        if(startingBCSLabel.text == "" && targetDateLabel.text == "" && startWeightLabel.text == "" && targetWeightLossLabel.text == "" && startingBCSLabel.text == "")
        {
            for id in self.view.subviews as [UIView]{
                
                if (id.isMemberOfClass(UILabel))
                {
                    if(id.valueForKey("text")  as! String == "")
                    {
                        id.setValue("Not planned", forKey: "text")
                    }
                }
                
            }

        }
        
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
