//
//  PeopleTableViewController.swift
//  Person Information MVC
//
//  Created by Sabin Tabirca on 02/03/2023.
//

import UIKit
import CoreData

//Extension for the ui image to create borders
extension UIImage {
    func roundedImage(radius:CGFloat)->UIImage{
        var imageView = UIImageView(image: self)
        
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.black.cgColor
        
        //converting image view to ui image
        UIGraphicsBeginImageContext(self.size)
        var context = UIGraphicsGetCurrentContext()!
        imageView.layer.render(in: context)
        var result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
}

class PlayerTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    //MARK: - core data
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pManageObject:PlayerEntity!
    var entity:NSEntityDescription!
    
    var frc: NSFetchedResultsController<NSFetchRequestResult>!
    func fetchRequest() -> NSFetchRequest<NSFetchRequestResult>
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PlayerEntity")
        
        let batsmanPredicate = NSPredicate(format: "playingstyle == %@", "Batsman")
        let bowlerPredicate = NSPredicate(format: "playingstyle == %@", "Bowler")
        let allrounderPredicate = NSPredicate(format: "playingstyle == %@", "All-Rounder")
        
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [batsmanPredicate, allrounderPredicate, bowlerPredicate])
        
        let playingStyleSortDescriptor = NSSortDescriptor(key: "playingstyle", ascending: false)
        
        
        // Sort by playing style, with batsmen first, followed by all-rounders, and then bowlers.
        request.sortDescriptors = [playingStyleSortDescriptor]
        
        return request
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        

        title = "Indian Cricket Team"
        
        //make frc and fetch
        frc = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: context, sectionNameKeyPath: "playingstyle", cacheName: nil)

        
        do{
            try frc.performFetch()
        }
        catch{
            print("Cannot Fetch")
        }
        
        frc.delegate=self
        //Giving header and footer
        let header=UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 10))
        let footer=UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 10))
        
        header.backgroundColor = .black
        footer.backgroundColor = .black
        
        tableView.tableHeaderView=header
        tableView.tableFooterView=footer
        
    }
    
    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
                return 35
            } else {
                return 20
            }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return frc.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return frc.sections?[section].name
        
        

    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return frc.sections?[section].numberOfObjects ?? 0 
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            
            headerView.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
            
        }
    }
    
    
    
    //func for image formatting in the cell
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        pManageObject=frc.object(at: indexPath) as! PlayerEntity
        // Configure the cell...
        cell.textLabel?.text=pManageObject.name
        cell.detailTextLabel?.text=pManageObject.age
        
//        if pManageObject.image != nil{
//            cell.imageView?.image=getImage(name: pManageObject.image!)
//        }
        let image = UIImage(named: pManageObject.img!)!
        let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 100, height: 100))
        cell.imageView?.image = resizedImage.roundedImage(radius: 10.0) //applying the rounded func
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .systemGray6
        return cell
            
        }
        
    
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue0" {
            if let indexPath = tableView.indexPathForSelectedRow {
                        let selectedPerson = frc.object(at: indexPath) as! PlayerEntity
                        let detailViewController = segue.destination as! PlayerViewController
                        detailViewController.pManageObject = selectedPerson
                    }
        }
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "segue0"{
//            // Get the destination view controller
//
//
//            if let indexPath = tableView.indexPathForSelectedRow {
//                // Get the selected person based on the section and row
//                let sectionTitle = sectionTitles[indexPath.section]
//                let selectedPerson = groupedPlayerData[sectionTitle]![indexPath.row]
//
//                // Pass the selected person to the detail view controller
//                let detailViewController = segue.destination as! PlayerViewController
//                detailViewController.personData = selectedPerson
                
//                if segue.identifier == "segue0"{
//                    // Get the destination view controller
//
//
//                    if let indexPath = tableView.indexPathForSelectedRow {
//                                // Get the selected person based on the section and row
//                        // Get the new view controller using segue.destination.
//                        let destinationController=segue.destination as! DetailsViewController
//                        //extract data from frc
//                        let indexPath=tableView.indexPath(for: sender as! UITableViewCell)
//                        pManageObject=frc.object(at: indexPath!) as! PlayerEntity
//                        // Pass the selected object to the new view controller.
//                        destinationController.pManageObject=pManageObject
//                            }
//
//                }

                
        }

        
