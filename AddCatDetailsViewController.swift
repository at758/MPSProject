//
//  AddCatDetailsViewController.swift
//  FitCat
//
//  Created by Akshay Tata on 2/6/16.
//  Copyright © 2016 Akshay Tata. All rights reserved.
//

import UIKit

class AddCatDetailsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var catImage: UIImageView!
    @IBAction func CloseView(sender: UIBarButtonItem) {
        
        //dismissViewControllerAnimated(true, completion: nil)
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        catImage.layer.cornerRadius = catImage.frame.size.width / 2
        catImage.layer.masksToBounds = true
        
        catImage.userInteractionEnabled = true
        
        let tapImageRecognizer = UITapGestureRecognizer(target: self, action: Selector("catImageTapped:"))
        
        catImage.addGestureRecognizer(tapImageRecognizer)
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
