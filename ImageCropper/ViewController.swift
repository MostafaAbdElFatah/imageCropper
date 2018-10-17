

import UIKit

class ViewController: UIViewController ,UIScrollViewDelegate , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 10.0
        
        let tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.loadimage(_:)))
        self.imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func loadimage(_ recognizer:UITapGestureRecognizer){
        let imagePicker:UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true)
        scrollView.zoomScale = 1.0
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageView.image = image
        picker.dismiss(animated: true, completion: nil)
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
   
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centerScrollViewContents()
    }

    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cropSave_btnClicked(_ sender: AnyObject) {
        UIGraphicsBeginImageContext(self.scrollView.bounds.size)
        let offset = scrollView.contentOffset
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: -offset.x, y: -offset.y )
        self.scrollView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        let alter = UIAlertController(title: "Your Cropper Image Saved", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alter.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alter, animated: true)
        
        
    }
   
}

