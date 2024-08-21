//
//  StartViewController.swift
//  Assignment1IOS-ShubhamKarekar
//
//  Created by Shubham Karekar on 14/04/2023.
//

import UIKit
import CoreData
extension UIImage {
    func alpha(_ value: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
class StartViewController: UIViewController {

    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title="Choose Your Option"
        insertFromXML()
        
        let img1 = resizeImage(image: UIImage(named: "teamindia.jpeg")!, targetSize: CGSize(width: 1200, height: 900))
        let modifiedImage = img1.alpha(0.8) // Set alpha value to 0.5 (range is 0.0-1.0)

        teamimg.image = modifiedImage

        let img2 = resizeImage(image: UIImage(named: "ownteam.jpeg")!, targetSize: CGSize(width: 1200, height: 900))
        let modifiedImage1 = img2.alpha(0.6) // Set alpha value to 0.5 (range is 0.0-1.0)

        createimg.image = modifiedImage1
       
    }
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var entity:NSEntityDescription!
    var pManageObject: PlayerEntity!
    
    func insertFromXML() {
        // Parse data from XML file
        let xmlParser = XMLPlayersParser(name: "data.xml")
        xmlParser.parsing()

        // Iterate through parsed data and insert into CoreData
        for player in xmlParser.peopleData {
            // Check if a player with the same name already exists in Core Data
            let request = NSFetchRequest<PlayerEntity>(entityName: "PlayerEntity")
            request.predicate = NSPredicate(format: "name == %@", player.name)
            do {
                    let results = try context.fetch(request)
                    if results.count > 0 {
                            // Player already exists, skip inserting
                        continue
                    }
                } catch {
                    print("Failed to fetch player: \(error)")
                    continue
                }
            entity = NSEntityDescription.entity(forEntityName: "PlayerEntity", in: context)
            pManageObject = PlayerEntity(entity: entity, insertInto: context)

            pManageObject.name = player.name
            pManageObject.age = player.age
            pManageObject.web = player.web
            pManageObject.playingstyle = player.playingstyle
            pManageObject.img = player.img
            pManageObject.internationaldebut=player.internationaldebut
            pManageObject.info=player.info
            pManageObject.style=player.style
            pManageObject.insta=player.insta
            pManageObject.twitter=player.twitter
            pManageObject.img2=player.img2
            pManageObject.hasfavourited=false

            // Save context
            do {
                try context.save()
            } catch {
                print("Context cannot save")
            }

            // Save image to document directory
//            let imageData = Data(base64Encoded: player.img)
//            if imageData != nil && pManageObject.img != nil {
//                putImage(name: pManageObject.img!, imageData: imageData!)
//            }
        }
    }
    func delete(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Delete all the objects in the context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlayerEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch let error as NSError {
            print("Could not delete all objects. \(error), \(error.userInfo)")
        }

        // Reset the context
        context.reset()
    }

    
    
    @IBOutlet weak var createbyn: UIButton!
    
    @IBOutlet weak var teambtn: UIButton!
    
    @IBOutlet weak var teamimg: UIImageView!
    
    
    @IBOutlet weak var createimg: UIImageView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
