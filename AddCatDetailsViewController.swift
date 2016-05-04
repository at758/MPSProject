//
//  AddCatDetailsViewController.swift
//  FitCat
//
//  Created by Akshay Tata on 2/6/16.
//  Copyright © 2016 Akshay Tata. All rights reserved.
//

import UIKit

import Firebase

/*extension Dictionary where Value : String {
func allKeysForValue<K, V : String>(dict: [K : V], val: V) -> [K] {
return dict.filter{$0.1 == val}.map{ $0.0 }
    }
}*/

class AddCatDetailsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var catName: UITextField!
    
    //Cat Breed Data
    var catBreedData = ["":"","/cat-breeds/item/173":"Abyssinian","/cat-breeds/item/174":"American Bobtail","/cat-breeds/item/176":"American Bobtail SH","/cat-breeds/item/177":"American Curl","/cat-breeds/item/178":"American Curl LH","/cat-breeds/item/179":"American Shorthair","/cat-breeds/item/181":"American Wirehair","/cat-breeds/item/313":"Australian Mist","/cat-breeds/item/183":"Balinese","/cat-breeds/item/184":"Bengal","/cat-breeds/item/185":"Birman","/cat-breeds/item/187":"Bombay","/cat-breeds/item/190":"British Shorthair","/cat-breeds/item/192":"British Longhair","/cat-breeds/item/195":"Burmese","/cat-breeds/item/316":"Burmilla","/cat-breeds/item/1668":"Burmilla LH","/cat-breeds/item/197":"Chartreux","/cat-breeds/item/199":"Chausie","/cat-breeds/item/200":"Cornish Rex","/cat-breeds/item/202":"Cymric","/cat-breeds/item/206":"Devon Rex","/cat-breeds/item/347":"Egyptian Mau","/cat-breeds/item/210":"Exotic Shorthair","/cat-breeds/item/212":"Havana","/cat-breeds/item/214":"Himalayan","/cat-breeds/item/216":"Japanese Bobtail","/cat-breeds/item/218":"Japanese Bobtail LH","/cat-breeds/item/319":"Khaomanee","/cat-breeds/item/221":"Korat","/cat-breeds/item/223":"Kurilian Bobtail","/cat-breeds/item/226":"Kurilian Bobtail LH","/cat-breeds/item/228":"LaPerm","/cat-breeds/item/230":"LaPerm Shorthair","/cat-breeds/item/231":"Maine Coon","/cat-breeds/item/233":"Manx","/cat-breeds/item/236":"Munchkin","/cat-breeds/item/240":"Munchkin Longhair","/cat-breeds/item/242":"Nebelung","/cat-breeds/item/245":"Norwegian Forest","/cat-breeds/item/246":"Ocicat","/cat-breeds/item/247":"Oriental Longhair","/cat-breeds/item/248":"Oriental Shorthair","/cat-breeds/item/249":"Persian","/cat-breeds/item/250":"Peterbald","/cat-breeds/item/252":"Pixiebob","/cat-breeds/item/253":"Pixiebob Longhair","/cat-breeds/item/254":"Ragdoll","/cat-breeds/item/258":"Russian Blue","/cat-breeds/item/260":"Savannah","/cat-breeds/item/262":"Scottish Fold","/cat-breeds/item/264":"Scottish Fold LH","/cat-breeds/item/1178":"Scottish Straight","/cat-breeds/item/1182":"Scottish Straight LH","/cat-breeds/item/266":"Selkirk Rex","/cat-breeds/item/267":"Selkirk Rex Longhair","/cat-breeds/item/268":"Siamese","/cat-breeds/item/269":"Siberian","/cat-breeds/item/272":"Singapura","/cat-breeds/item/274":"Snowshoe","/cat-breeds/item/279":"Somali","/cat-breeds/item/285":"Sphynx","/cat-breeds/item/287":"Thai","/cat-breeds/item/290":"Tonkinese","/cat-breeds/item/301":"Toyger","/cat-breeds/item/305":"Turkish Angora","/cat-breeds/item/307":"Turkish Van","/cat-breeds/item/309":"Household Pet","/cat-breeds/item/311":"Household Pet Kitten","/cat-breeds/item/334":"Donskoy","/cat-breeds/item/335":"Highlander","/cat-breeds/item/337":"Highlander Shorthair","/cat-breeds/item/1207":"Lykoi","/cat-breeds/item/327":"Minuet","/cat-breeds/item/330":"Minuet Longhair","/cat-breeds/item/332":"Serengeti","/cat-breeds/item/339":"Minskin","https://en.wikipedia.org/wiki/Domestic_short-haired_cat":"Domestic Short Haired", "https://en.wikipedia.org/wiki/Domestic_long-haired_cat":"Domestic Long Haired"]
    
  
    var choice = ["Select an option below","Yes","No"]
    var gender = ["Select an option below","Male", "Female"]
    //Creating reference to FireBase
    var ref = Firebase(url: "https://fitcat.firebaseio.com/users")
    var u_name = floginobj.f_id
    var cat_details = ["cat_age": 0, "cat_gender":"Male", "cat_status": "No", "cat_breed" :"","cat_image":""]
    var userRef : Firebase!
    
    @IBAction func CloseView(sender: UIBarButtonItem) {
       
        //dismissViewControllerAnimated(true, completion: nil)
       
    }
    
    @IBAction func UnwindToAddCat(segue: UIStoryboardSegue) {
        
    }

    
    @IBOutlet weak var catAge: UITextField!
    @IBOutlet weak var catGender: UITextField!
    @IBOutlet weak var catStatus: UITextField!
    @IBOutlet weak var catBreed: UITextField!
    
    var picker1 = UIPickerView()
    var picker2 = UIPickerView()
    var catBreedSelection = UIPickerView()
    var datePicker = UIDatePicker()
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        
        return 1
    }
    
    
  
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        if(pickerView.tag ==  3)
        {
            return (catBreedData.count)
        }
        
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(pickerView.tag == 1)
        {
           //  print("The row is \(row)")
            if(row != 0)
            {
             catGender.text = gender[row]
            }
        }
        else if(pickerView.tag == 3)
        {
            var sorbreedval = Array(catBreedData.values).sort()
            sorbreedval.removeAtIndex(0)
            sorbreedval.insert("Select an option", atIndex: 0)
            catBreed.text = sorbreedval[row]
        }
        else
        {
            if(row != 0)
            {

            catStatus.text = choice[row]
            }
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(pickerView.tag == 1)
        {
            return gender[row]
        }
        else if(pickerView.tag == 3)
        {
                return  Array(catBreedData.values).sort()[row]
        }
        else
        {
            return choice[row]
        }
    }
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    func textFieldDidChange(textField: UITextField) {
        //your code
        
        if(catName.text?.characters.count > 0
        && catAge.text?.characters.count > 0
        && catGender.text?.characters.count > 0
        && catStatus.text?.characters.count > 0 && catBreed.text?.characters.count > 0){
        
            saveButton.enabled = true
        }
        else
        {
             saveButton.enabled = false
        }
    }
    
    @IBAction func saveCatDetails(sender: AnyObject) {
    
        ref = Firebase(url: "https://fitcat.firebaseio.com/users/" +  (u_name))
        let app   = ref.childByAppendingPath(catName.text)
        if (catImage.image == "IMG_6699.png")
        {
            cat_details["cat_image"] = ""
        }
        else
        {
            cat_details["cat_image"] = UIImageJPEGRepresentation(catImage.image!, 0.1)?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        }
        
        
        cat_details["cat_age"] = Int(catAge.text!)
        cat_details["cat_gender"] = catGender.text
        cat_details["cat_status"] = catStatus.text
        cat_details["cat_breed"] = catBreed.text
        
        app.setValue(cat_details)
        
        
        
        let alertController = UIAlertController(title: "Saved", message:
            "Your details are saved", preferredStyle: UIAlertControllerStyle.Alert)
        //alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
         //  CatListTableViewController().calculateInitialValue()
           self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
       
    }
    
    func dateChanged(datePicker: UIDatePicker)
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        catAge.text = dateFormatter.stringFromDate(datePicker.date)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        catName.addTarget(self, action: #selector(AddCatDetailsViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        catAge.addTarget(self, action: #selector(AddCatDetailsViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.AllEditingEvents)
        
        catGender.addTarget(self, action: #selector(AddCatDetailsViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.AllEditingEvents)
        
        catStatus.addTarget(self, action: #selector(AddCatDetailsViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.AllEditingEvents)
        
        catBreed.addTarget(self, action: #selector(AddCatDetailsViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.AllEditingEvents)
        
        saveButton.enabled = false
        
        
        picker1.delegate = self
        picker2.delegate = self
        picker1.dataSource = self
        picker1.dataSource = self
        
        catBreedSelection.delegate = self
        catBreedSelection.dataSource = self
        
        catName.delegate = self
        
        
        datePicker.datePickerMode = UIDatePickerMode.Date
        catAge.inputView = datePicker
        
        datePicker.addTarget(self, action: #selector(AddCatDetailsViewController.dateChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        picker1.tag = 0
        picker2.tag = 1
        catBreedSelection.tag = 3
        
        catGender.inputView = picker2
        print("Joe",  picker2.hidden)
        print("Pom",  picker2.selectedRowInComponent(0))
        
        catStatus.inputView = picker1
        catBreed.inputView = catBreedSelection
        
        catImage.layer.cornerRadius = catImage.frame.size.width / 2
        catImage.layer.masksToBounds = true
        
        catImage.userInteractionEnabled = true
        
        let tapImageRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddCatDetailsViewController.catImageTapped(_:)))
        
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
    /* Resign the focus after the return */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "catBreedInfo")
        {
        
            var inURL = "http://www.tica.org"
            if(catBreed.text == "Domestic Short Haired" || catBreed.text == "Domestic Long Haired")
            {
                inURL = ""
            }
            let selectbreedlink =  inURL + ((catBreedData as NSDictionary).allKeysForObject(catBreed.text!)[0] as! String)
            let secView: ViewControllerWebView = segue.destinationViewController as! ViewControllerWebView
             secView.urlString = selectbreedlink
        }
    
 
    }
    override func viewWillAppear(animated: Bool) {
        picker2.selectRow(0, inComponent: 0, animated: false)
    }

}


