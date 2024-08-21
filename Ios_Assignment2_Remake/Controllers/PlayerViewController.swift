//
//  PersonViewController.swift
//  Person Information MVC
//
//  Created by Sabin Tabirca on 13/02/2023.
//

import UIKit

extension UIImage {
    func styledImage(radius: CGFloat) -> UIImage? {
        let imageView = UIImageView(image: self)
        
        imageView.layer.borderWidth = 4
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

class PlayerViewController: UIViewController {
    
    
    @IBOutlet weak var firstView: UIView!
    
    
    @IBOutlet weak var secondView: UIView!
    
    
    var pManageObject:PlayerEntity!
    
    //func for image formatting in the cell
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
            
        }
    }
    
    
    
    
    
    // MARK: - Outlets and Actions
    
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var personImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the title
        title = "Player"
        
                
        // populate the outlets with data
        personNameLabel.text = pManageObject.name
        
        let image=UIImage(named: pManageObject.img2!)!
        let resizedimage=resizeImage(image: image, targetSize: CGSize(width: 450, height: 700))
        personImageView.image = resizedimage.styledImage(radius: 2)
        
        


        
    }
    
    @IBAction func segment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex==0{
            firstView.alpha=1
            
            secondView.alpha=0
        }else{
            firstView.alpha=0
            secondView.alpha=1
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue1"{
            // Get the new view controller using segue.destination.
            let destinationController = segue.destination as! DetailsViewController
            
            // Pass the selected object to the new view controller.
            destinationController.pManageObject = self.pManageObject
        }
        if segue.identifier == "style"{
            // Get the new view controller using segue.destination.
            let destinationController = segue.destination as! styleViewController
            
            // Pass the selected object to the new view controller.
            destinationController.pManageObject = self.pManageObject
        }
        if segue.identifier == "debut"{
            // Get the new view controller using segue.destination.
            let destinationController = segue.destination as! debutViewController
            
            // Pass the selected object to the new view controller.
            destinationController.pManageObject = self.pManageObject
        }
    }
    

}
