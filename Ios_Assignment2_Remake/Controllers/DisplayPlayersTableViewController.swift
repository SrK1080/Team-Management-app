//
//  DisplayPlayersTableViewController.swift
//  Ios_Assignment2_Remake
//
//  Created by Shubham Karekar on 17/04/2023.
//

import UIKit
import CoreData

class DisplayPlayersTableViewController: UITableViewController,NSFetchedResultsControllerDelegate {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var teamObject: Team! // Pass the team object from the segue
    var players: FavouritePlayers!
    
    
    var team: NSFetchedResultsController<NSFetchRequestResult>!
    func fetchRequestteam()->NSFetchRequest<NSFetchRequestResult>{
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Team")
        
        let sorter=NSSortDescriptor(key: "teamname", ascending: true)
        //use predicate if filter
        request.sortDescriptors=[sorter]
        return request
    }
    var frc2: NSFetchedResultsController<NSFetchRequestResult>!

    func fetchRequest2() -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouritePlayers")
        request.predicate = NSPredicate(format: "teamname == %@", teamObject.teamname!)
        let sorter=NSSortDescriptor(key: "playername", ascending: true)
        //use predicate if filter
        request.sortDescriptors=[sorter]
        
        return request
        
    }
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
    var frc1: NSFetchedResultsController<NSFetchRequestResult>!
    func fetchRequest1() -> NSFetchRequest<NSFetchRequestResult>
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
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title="Team "+teamObject.teamname!
        // Create and fetch the frc
        frc2=NSFetchedResultsController(fetchRequest: fetchRequest2(), managedObjectContext: context, sectionNameKeyPath: nil ,cacheName: nil)
        frc1 = NSFetchedResultsController(fetchRequest: fetchRequest1(), managedObjectContext: context, sectionNameKeyPath: "playingstyle", cacheName: nil)
        frc = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: context, sectionNameKeyPath: "playingstyle", cacheName: nil)
        team=NSFetchedResultsController(fetchRequest: fetchRequestteam(), managedObjectContext: context, sectionNameKeyPath: nil ,cacheName: nil)
              do{
                  try frc2.performFetch()
                  try frc1.performFetch()
                  try frc.performFetch()
                  try team.performFetch()
              }
              catch{
                  print("Cannot Fetch")
              }
              
              frc2.delegate=self
        frc1.delegate=self
        frc.delegate=self
        team.delegate=self
        
        
        // Set up the header and footer views
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 10))
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 10))
        header.backgroundColor = .black
        footer.backgroundColor = .black
        tableView.tableHeaderView = header
        tableView.tableFooterView = footer
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
        return 1
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc2.sections?[section].numberOfObjects ?? 0
    }

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        players=frc2.object(at: indexPath) as! FavouritePlayers
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "playername", for: indexPath)
        
        
        
        // Configure the cell...
        cell.textLabel?.text=players.playername
        cell.detailTextLabel?.text=players.age
        let playerFetchRequest = NSFetchRequest<PlayerEntity>(entityName: "PlayerEntity")
            playerFetchRequest.predicate = NSPredicate(format: "name == %@", players.playername!)
            var playerObject: PlayerEntity?
            do {
                let playersArray = try context.fetch(playerFetchRequest)
                if let player = playersArray.first {
                    playerObject = player
                }
            } catch {
                print("Error fetching player object: \(error)")
            }
        if let imageName = playerObject?.img {
                let image = UIImage(named: imageName)!
                let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 100, height: 100))
                cell.imageView?.image = resizedImage.roundedImage(radius: 10.0) //applying the rounded func
            }
        //        if pManageObject.image != nil{
        //            cell.imageView?.image=getImage(name: pManageObject.image!)
        //        }
//        let image = UIImage(named: players.img!)!
//        let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 100, height: 100))
//        cell.imageView?.image = resizedImage.roundedImage(radius: 10.0) //applying the rounded func
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.players=(self.frc2.object(at: indexPath) as! FavouritePlayers)
        if editingStyle == .delete {
            
            //find object delete  in frc
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete "+players.playername!+"?", preferredStyle: .alert)
                   
                   // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        print("Ok button tapped")
                       self.players=(self.frc2.object(at: indexPath) as! FavouritePlayers)
                       
                       //delete
                       self.context.delete(self.players)
                       
                       //save context
                       do{
                           try self.context.save()
                           
                       }
                       catch{
                           print("Cannot delete")
                       }
                        
                   })
                   
                   // Create Cancel button with action handlder
                   let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                       print("Cancel button tapped")
                   }
                   
                   //Add OK and Cancel button to dialog message
                   dialogMessage.addAction(ok)
                   dialogMessage.addAction(cancel)
                   
                   // Present dialog message to user
                   self.present(dialogMessage, animated: true, completion: nil)

            
        }
           
    }
    

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
         if segue.identifier=="addplayers"{
            // Get the new view controller using segue.destination.
            
            let destinationController=segue.destination as! FavouriteTableTableViewController
            //extract data from frc
             
             
            
            // Pass the selected object to the new view controller.
             destinationController.teamObject=teamObject
             
        }
        if segue.identifier=="showfavplayerdetail"
        {
            if let indexPath = tableView.indexPathForSelectedRow{
                if let name = tableView.cellForRow(at: indexPath)?.textLabel?.text {
                    let fetchRequest: NSFetchRequest<PlayerEntity> = PlayerEntity.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "name == %@", name)
                    do {
                        let results = try frc.managedObjectContext.fetch(fetchRequest)
                        if let selectedPerson = results.first {
                            let detailViewController = segue.destination as! PlayerViewController
                            detailViewController.pManageObject = selectedPerson
                        }
                    } catch let error {
                        print("Error fetching player: \(error)")
                    }
                }
            }
            
        }
        if segue.identifier=="showteaminfo"{
            let destinationController=segue.destination as! AddUpdateteamViewController
            //extract data from frc
            
            // Pass the selected object to the new view controller.
            destinationController.pManageObject=teamObject
        }
        
    }
    

}
