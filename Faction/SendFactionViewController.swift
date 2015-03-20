//
//  SendFactionViewController.swift
//  Faction
//
//  Created by Alessandro Parisi on 2015-02-01.
//  Copyright (c) 2015 Alessandro Parisi. All rights reserved.
//

import Foundation
import UIKit

class SendFactionViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var True: UIButton!
    @IBOutlet weak var False: UIButton!
    @IBOutlet var textView: UITextView!
    @IBOutlet var commentsEN: UISegmentedControl!

    var imagePicker = UIImagePickerController()
    deinit {
        textView.text = ""
        imageView.image = nil
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newLength = countElements(textView.text!) - range.length
        return newLength <= 149
    }
    
    @IBAction func True(sender: UIButton) {
        self.performSegueWithIdentifier("pick_friends", sender: true)
    }
    
    @IBAction func False(sender: UIButton) {
        self.performSegueWithIdentifier("pick_friends", sender: false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as ChooseFriendViewController
                
        vc.comments_enabled = commentsEN.selectedSegmentIndex == 0
        println(vc.comments_enabled)
        vc.image = imageView.image
        vc.factionText = textView.text
        
        if let s = sender as? Bool {
            vc.faction = s
        }
        
    }
    @IBAction func addImage(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            println("Button capture")
            
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
        imageView.image = image
        
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}