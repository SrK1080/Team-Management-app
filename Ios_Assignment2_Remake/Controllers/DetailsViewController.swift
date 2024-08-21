//
//  DetailsViewController.swift
//  Person Information MVC
//
//  Created by Sabin Tabirca on 13/02/2023.
//

import UIKit
extension UIImage {
    func roundedImage(radius: CGFloat) -> UIImage? {
        let imageView = UIImageView(image: self)
        
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.black.cgColor
        
        //converting image view to ui image
        UIGraphicsBeginImageContext(self.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
class DetailsViewController: UIViewController {
    
    
    var pManageObject:PlayerEntity!
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set title
        title = "Player Details"
        
        // populate the outlets with data
        nameLabel.text    = pManageObject.name
        emailLabel.text   = pManageObject.age
        info.text   = pManageObject.info
        let image1=UIImage(named: "twitter.png")!
        let resizedimage1=resizeImage(image: image1, targetSize: CGSize(width: 30, height: 30))
        twitter.setImage(resizedimage1,for: .normal)
        
        let image2=UIImage(named: "insta.png")!
        let resizedimage2=resizeImage(image: image2, targetSize: CGSize(width: 50, height: 45))
        insta.setImage(resizedimage2,for: .normal)
        

    }
    
    // MARK: - Outlets and Actions
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!


    @IBOutlet weak var twitter: UIButton!
    
    @IBOutlet weak var info: UITextView!
    
    @IBOutlet weak var insta: UIButton!
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "segue2"{
             // Get the new view controller using segue.destination.
             let destinationController = segue.destination as! PlayerWebViewController
             
             // Pass the selected object to the new view controller.
             destinationController.pManageObject = self.pManageObject
         }
         if segue.identifier == "insta"{
             // Get the new view controller using segue.destination.
             let destinationController = segue.destination as! instaViewController
             
             // Pass the selected object to the new view controller.
             destinationController.pManageObject = self.pManageObject
         }
         if segue.identifier == "twitter"{
             // Get the new view controller using segue.destination.
             let destinationController = segue.destination as! twitterViewController
             
             // Pass the selected object to the new view controller.
             destinationController.pManageObject = self.pManageObject
         }
     }

}
