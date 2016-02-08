//
//  AddCatDetailsViewController.swift
//  FitCat
//
//  Created by Akshay Tata on 2/6/16.
//  Copyright © 2016 Akshay Tata. All rights reserved.
//

import UIKit

class AddCatDetailsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDataSource,UIPickerViewDelegate {

    var choice = ["Yes","No"]
    var gender = ["Male", "Female"]
    
    @IBOutlet weak var catImage: UIImageView!
    
    //Creating reference to FireBase
    var ref = Firebase(url: "https://fitcat.firebaseio.com/users")
    var u_name = "akshay_t"
    var cat_details = ["cat_age": 0, "cat_gender":"Male", "cat_status": "No", "cat_breed" :""]
    var userRef : Firebase!
    @IBOutlet weak var catName: UITextField!
    @IBAction func CloseView(sender: UIBarButtonItem) {
        
        //dismissViewControllerAnimated(true, completion: nil)
       
    }
    @IBOutlet weak var catAge: UITextField!
    
    
    @IBOutlet weak var catGender: UITextField!
    
    
    @IBOutlet weak var catStatus: UITextField!
    
    
    @IBOutlet weak var catBreed: UITextField!
    
    var picker1 = UIPickerView()
    var picker2 = UIPickerView()
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        
        return 1
    }
  
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(pickerView.tag == 1)
        {
             catGender.text = gender[row]
        }
        else
        {
            catStatus.text = choice[row]
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(pickerView.tag == 1)
        {
            return gender[row]
        }
        else
        {
            return choice[row]
        }
    }
    
    
    @IBAction func saveCatDetails(sender: AnyObject) {
        
        ref = Firebase(url: "https://fitcat.firebaseio.com/users/" +  (u_name))
        
        let app   = ref.childByAppendingPath(catName.text)
        
        cat_details["cat_age"] = Int(catAge.text!)
        cat_details["cat_gender"] = catGender.text
        cat_details["cat_status"] = catStatus.text
        cat_details["cat_breed"] = catBreed.text
        
        app.setValue(cat_details)
        
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
        picker1.delegate = self
        picker2.delegate = self
        picker1.dataSource = self
        picker1.dataSource = self
        
        picker1.tag = 0
        picker2.tag = 1
        
        catGender.inputView = picker2
        catStatus.inputView = picker1
        
        catImage.layer.cornerRadius = catImage.frame.size.width / 2
        catImage.layer.masksToBounds = true
        
        catImage.userInteractionEnabled = true
        
        let tapImageRecognizer = UITapGestureRecognizer(target: self, action: Selector("catImageTapped:"))
        
        catImage.addGestureRecognizer(tapImageRecognizer)
        
        //userRef = ref.childByAppendingPath(u_name)
        
        //userRef.setValue([u_name : cat_details])
        
        // Do any additional setup after loading the view.
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func catImageTapped(gestureRecognizer: UITapGestureRecognizer) {
        
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        catImage.image = image
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
