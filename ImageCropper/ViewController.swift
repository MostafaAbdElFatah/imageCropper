

import UIKit

class ViewController: UIViewController ,UIScrollViewDelegate , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    var imageView:UIImageView = UIImageView()
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        self.imageView.frame = CGRect(x: 0, y: 0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height)
        self.imageView.image = UIImage(named: "2")
        imageView.isUserInteractionEnabled = true
        self.scrollView.addSubview(imageView)
        let tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.loadimage(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func loadimage(_ recognizer:UITapGestureRecognizer){
        let imagePicker:UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageView.image = image
        self.imageView.contentMode = UIViewContentMode.center
        self.imageView.frame = CGRect(x:0,y: 0,width: image.size.width,height: image.size.height)
        self.scrollView.contentSize = image.size
        let scrollFrame = scrollView.frame
        let scallWidth = scrollFrame.size.width / scrollView.contentSize.width
        let scallheight = scrollFrame.size.height / scrollView.contentSize.height
        let minScale = min(scallWidth, scallheight)
        self.scrollView.minimumZoomScale = minScale
        self.scrollView.maximumZoomScale = 1
        self.scrollView.zoomScale = minScale
        //self.centerScrollViewContents()
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
        UIGraphicsBeginImageContextWithOptions(self.scrollView.bounds.size, true, UIScreen.main.scale)
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

