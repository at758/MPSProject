//
//  InfoViewController.swift
//  FitCat
//
//  Created by LiMaggie on 3/2/16.
//  Copyright © 2016 Akshay Tata. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var catImage: UIImageView!
   
    @IBOutlet weak var catName: UILabel!
   
    @IBOutlet weak var catBCS: UIImageView!
    
    var name : String?
    var image : NSData?
    override func viewDidLoad() {
        super.viewDidLoad()
        if(name != nil && image != nil){
            navigationController?.title = name
            catImage?.image = UIImage(data: image!)
            catName.text = name
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
