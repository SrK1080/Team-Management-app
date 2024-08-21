//
//  FavouriteTableTableViewController.swift
//  Assignment1IOS-ShubhamKarekar
//
//  Created by Shubham Karekar on 14/04/2023.
//

import UIKit
import CoreData



class FavouriteTableTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    
    var teamObject:Team!
    //MARK: - core data
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pManageObject:PlayerEntity!
    var entity:NSEntityDescription!
    var playerEntity:FavouritePlayers!
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
    var frc2: NSFetchedResultsController<NSFetchRequestResult>!

    func fetchRequest2() -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouritePlayers")
        request.predicate = NSPredicate(format: "teamname == %@", teamObject.teamname!)
        let sorter=NSSortDescriptor(key: "playername", ascending: true)
        //use predicate if filter
        request.sortDescriptors=[sorter]
        
        return request
        
    }

    func someMethodIWantToCall(cell: UITableViewCell) {
        guard let indexPathTapped = tableView.indexPath(for: cell) else { return }

        if let pManageObject = frc1.object(at: indexPathTapped) as? PlayerEntity {

            // Update the tapped player's `hasFavorited` property and reload the table view row
            pManageObject.hasfavourited = !pManageObject.hasfavourited
           tableView.reloadRows(at: [indexPathTapped], with: .fade)
//            cell.accessoryView?.backgroundColor=pManageObject.hasfavourited?UIColor.red
            // Check if the player is being favorited or unfavorited
            if pManageObject.hasfavourited {
                // Create a new FavoriteEntity object and set its attributes to the tapped player's attributes
                let newFavorite = FavouritePlayers(context: context)
                newFavorite.teamname = teamObject.teamname
                newFavorite.playername = pManageObject.name
                newFavorite.age = pManageObject.age

                // Save the context to persist the new favorite player
                do {
                    try context.save()
                } catch {
                    print("Cannot save new favorite")
                }
            } else {
                // Check if the player exists in the favorite players table
                let fetchRequest: NSFetchRequest<FavouritePlayers> = FavouritePlayers.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "teamname == %@ AND playername == %@", teamObject.teamname!, pManageObject.name!)
                
                do {
                    let favoritePlayers = try context.fetch(fetchRequest)
                    
                    // If the player exists in the favorite players table, delete it
                    if let favoritePlayer = favoritePlayers.first {
                        context.delete(favoritePlayer)
                        
                        // Save the context to persist the deletion
                        try context.save()
                    }
                } catch {
                    print("Cannot fetch favorite players")
                }
            }
            
            
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title="Select Your Favourite Players"
        //make frc and fetch
        frc1 = NSFetchedResultsController(fetchRequest: fetchRequest1(), managedObjectContext: context, sectionNameKeyPath: "playingstyle", cacheName: nil)

        frc2=NSFetchedResultsController(fetchRequest: fetchRequest2(), managedObjectContext: context, sectionNameKeyPath: nil ,cacheName: nil)
        do{
            try frc1.performFetch()
            
        }
        catch{
            print("Cannot Fetch")
        }
        do {
            try frc2.performFetch()
            
            if let players = frc2.fetchedObjects as? [FavouritePlayers] {
                if players.count > 0 {
                    print(players.count)
                } else {
                    // The entity is empty, do something else here
                }
            }
        } catch {
            print("Error fetching favourite players: \(error)")
        }
        
        frc1.delegate=self
        frc2.delegate=self
        
        tableView.register(ContactCell.self, forCellReuseIdentifier: "cell1")
        //Giving header and footer
        let header=UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 10))
        let footer=UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 10))
        
        header.backgroundColor = .black
        footer.backgroundColor = .black
        
        tableView.tableHeaderView=header
        tableView.tableFooterView=footer
        
        if let players = frc2.fetchedObjects as? [FavouritePlayers], players.count > 0 {
            for player in players {
                for section in 0..<frc1.sections!.count {
                    for row in 0..<frc1.sections![section].numberOfObjects {
                        let indexPath = IndexPath(row: row, section: section)
                        let pManageObject = frc1.object(at: indexPath) as! PlayerEntity
                        if player.playername == pManageObject.name {
                            pManageObject.hasfavourited = true
                        }
                    }
                }
            }
        }
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
                return 35
            } else {
                return 20
            }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return frc1.sections?.count ?? 0
    }

    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return frc1.sections?[section].numberOfObjects ?? 0    }

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
            
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return frc1.sections?[section].name
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ContactCell
        cell.link=self

        pManageObject=frc1.object(at: indexPath) as! PlayerEntity
        // Configure the cell...
        cell.textLabel?.text=pManageObject.name
        cell.detailTextLabel?.text=pManageObject.age
        if pManageObject.hasfavourited {
            cell.accessoryView?.backgroundColor = UIColor.red
//            let dialogMessage = UIAlertController(title: "Alert", message: "Added to Favourites", preferredStyle: .alert)
//            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
//                        print("Ok button tapped")
//
//                   })
//            dialogMessage.addAction(ok)
//
//            // Present dialog message to user
//            self.present(dialogMessage, animated: true, completion: nil)
//            print(teamObject.teamname!,"====",pManageObject.name!,"====",pManageObject.hasfavourited)
        } else {
            cell.accessoryView?.backgroundColor = .white
//            let dialogMessage = UIAlertController(title: "Alert", message: "Removed From Favourites", preferredStyle: .alert)
//            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
//                        print("Ok button tapped")
//
//                   })
//            dialogMessage.addAction(ok)
//            // Present dialog message to user
//            self.present(dialogMessage, animated: true, completion: nil)
//            print("====",pManageObject.name!,"====",pManageObject.hasfavourited)
        }
//        if pManageObject.image != nil{
//            cell.imageView?.image=getImage(name: pManageObject.image!)
//        }
        let image = UIImage(named: pManageObject.img!)!
        let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 100, height: 100))
        cell.imageView?.image = resizedImage.roundedImage(radius: 10.0) //applying the rounded func
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
    

    
    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            pManageObject=frc.object(at: indexPath) as! PlayerEntity
//
//            //delete
//            context.delete(pManageObject)
//
//            //save context
//            do{
//                try context.save()
//
//            }
//            catch{
//                print("Cannot delete")
//
//            }
//        }
//    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
