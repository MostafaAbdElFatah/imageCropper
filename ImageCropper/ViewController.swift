//
//  ViewController.swift
//  ImageCropper
//
//  Created by Mostafa on 7/22/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UIScrollViewDelegate , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    var imageView:UIImageView = UIImageView()
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        self.imageView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)
        self.imageView.image = UIImage(named: "2")
        imageView.userInteractionEnabled = true
        self.scrollView.addSubview(imageView)
        let tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "loadimage:")
        tapGestureRecognizer.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func loadimage(recognizer:UITapGestureRecognizer){
        let imagePicker:UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageView.image = image
        self.imageView.contentMode = UIViewContentMode.Center
        self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height)
        self.scrollView.contentSize = image.size
        let scrollFrame = scrollView.frame
        let scallWidth = scrollFrame.size.width / scrollView.contentSize.width
        let scallheight = scrollFrame.size.height / scrollView.contentSize.height
        let minScale = min(scallWidth, scallheight)
        self.scrollView.minimumZoomScale = minScale
        self.scrollView.maximumZoomScale = 1
        self.scrollView.zoomScale = minScale
        //self.centerScrollViewContents()
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func centerScrollViewContents(){
        let boundSize = self.scrollView.bounds.size
        var contentFrame = imageView.frame
        if contentFrame.size.width < boundSize.width{
            contentFrame.origin.x = (boundSize.width - contentFrame.size.width)/2
        }else{
            contentFrame.origin.x = 0
        }
        if contentFrame.size.height < boundSize.height{
            contentFrame.origin.y = (boundSize.height - contentFrame.size.height)/2
        }else{
            contentFrame.origin.y = 0
        }
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        self.centerScrollViewContents()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func cropSave_btnClicked(sender: AnyObject) {
        UIGraphicsBeginImageContextWithOptions(self.scrollView.bounds.size, true, UIScreen.mainScreen().scale)
        let offset = scrollView.contentOffset
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -offset.x, -offset.y)
        self.scrollView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        let alter = UIAlertController(title: "Your Cropper Image Saved", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alter.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alter, animated: true, completion: nil)
        
        
    }
   
}

