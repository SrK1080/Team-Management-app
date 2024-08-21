//
//  AddUpdateteamViewController.swift
//  Ios_Assignment2_Remake
//
//  Created by Shubham Karekar on 17/04/2023.
//

import UIKit
import CoreData
class AddUpdateteamViewController: UIViewController,UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //check if managed object is not empty
        if pManageObject != nil{
            
            //place data into textfield
            teamNameTF.text=pManageObject.teamname
            startYearTF.text=pManageObject.year
            ImageTF.text=pManageObject.image
            
            
            //get the image to imageview
            if pManageObject.image != nil{
                getImage(name: pManageObject.image!)
            }
        
        }
        
        
        
        
        
       
    }
    
    
    //MARK:- core data stuff
    
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var entity:NSEntityDescription!
    var pManageObject: Team!
    
    
    func insert(){
        //make an entity and a manage object
        entity=NSEntityDescription.entity(forEntityName: "Team", in: context)
        pManageObject=Team(entity: entity, insertInto: context)
        
        
        //populate managed object from fields
        pManageObject.teamname=teamNameTF.text
        pManageObject.year=startYearTF.text
        pManageObject.image=ImageTF.text
        
        
        //context to save
        do{
            try context.save()
        }
            catch{
                print("Context cannot save")
            }
        
        //put or save image to document
        let image=pickedimage.image
        if image != nil && pManageObject.image != nil{
            putImage(name: pManageObject.image!)
        }
        
    }
    
    func update(){
        
        
        //populate managed object from fields
        pManageObject.teamname=teamNameTF.text
        pManageObject.year=startYearTF.text
        pManageObject.image=ImageTF.text
        
        
        //context to save
        do{
            try context.save()
        }
        catch{
            print("Context cannot save")
        }
        let image=pickedimage.image
        if image != nil && pManageObject.image != nil{
            putImage(name: pManageObject.image!)
        }
        
    }
    
    
    
    @IBOutlet weak var teamNameTF: UITextField!
    
    @IBOutlet weak var startYearTF: UITextField!
    
    @IBOutlet weak var ImageTF: UITextField!
    @IBOutlet weak var pickedimage: UIImageView!
    
    @IBAction func savebtn(_ sender: UIButton) {
        
        let switchViewController = self.navigationController?.viewControllers[1] as! TeamTableViewController
        if pManageObject==nil{
            
            insert()
            
        }
        else{
            update()
            let dialogMessage = UIAlertController(title: "Edit Team?", message: "It will delete all the favourited players", preferredStyle: .alert)
                    
                    // Create OK button with action handler
                    let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
                         print("Yes button tapped")
                        
                        self.navigationController?.popToViewController(switchViewController, animated: true)
                    })
                    
                    // Create Cancel button with action handlder
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                        print("Cancel button tapped")
                    }
                    
                    //Add OK and Cancel button to dialog message
                    dialogMessage.addAction(yes)
                    dialogMessage.addAction(cancel)
                    
                    // Present dialog message to user
                    self.present(dialogMessage, animated: true, completion: nil)
        }
        
        
        navigationController?.popToViewController(switchViewController, animated: true)
        
    }
    @IBAction func Pickbtn(_ sender: Any) {
        //create the picker
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing=false
        imagePicker.delegate=self
        present(imagePicker,animated:true,completion : nil)
    }
    
    let imagePicker=UIImagePickerController()
    func getImage(name:String){
        //get image name from document
        let imagePath=(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
        let image = UIImage(contentsOfFile: imagePath)
        //place it to imageview
        
        pickedimage.image=resizeImage(image: image!, targetSize: CGSize(width: 100, height: 100))
    }
    
    func putImage(name:String){
        //get image path to the  document
        let imagePath=(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
        
        let fm=FileManager.default
        //get the image from pickedImageView and generate data
        
        let image=pickedimage.image
        
        let data=image?.pngData()
        
        //fm to save the data
        fm.createFile(atPath: imagePath, contents: data)
    }
    //picker delegate function
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
            
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //get the image from info
        let image=info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        //place it to imageview
        pickedimage.image=resizeImage(image: image, targetSize: CGSize(width: 100, height: 100))
        
        //dismiss
        dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
