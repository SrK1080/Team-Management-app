//
//  TeamTableViewController.swift
//  Ios_Assignment2_Remake
//
//  Created by Shubham Karekar on 17/04/2023.
//

import UIKit
import CoreData


class TeamTableViewController: UITableViewController ,NSFetchedResultsControllerDelegate{
    
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pManageObject:Team!
    var entity:NSEntityDescription!
    
    
    var frc: NSFetchedResultsController<NSFetchRequestResult>!
    func fetchRequest()->NSFetchRequest<NSFetchRequestResult>{
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Team")
        
        let sorter=NSSortDescriptor(key: "teamname", ascending: true)
        //use predicate if filter
        request.sortDescriptors=[sorter]
        return request
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title="Teams"
        //make frc and fetch
        frc=NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil ,cacheName: nil)
        
        do{
            try frc.performFetch()
        }
        catch{
            print("Cannot Fetch")
        }
        
        frc.delegate=self
        
        let header=UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 10))
        let footer=UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 10))
        
        header.backgroundColor = .black
        footer.backgroundColor = .black
        
        tableView.tableHeaderView=header
        tableView.tableFooterView=footer
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
                return 35
            } else {
                return 20
            }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (frc.sections?[section].numberOfObjects)!
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellteam", for: indexPath)
        
        pManageObject=frc.object(at: indexPath) as! Team
        // Configure the cell...
        cell.textLabel?.text=pManageObject.teamname
        cell.detailTextLabel?.text=pManageObject.year
        
        
        
        if pManageObject.image != nil{
            let image = getImage(name: pManageObject.image!)
            let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 100, height: 100))
            cell.imageView?.image=resizeImage(image: image, targetSize: CGSize(width: 100, height: 100))
        }
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .systemGray6
        return cell
        
    }
    
    
    //func for image formatting in the cell
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
            
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.pManageObject=self.frc.object(at: indexPath) as! Team
        if editingStyle == .delete {
            
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete Team "+pManageObject.teamname!+"?", preferredStyle: .alert)
                    
                    // Create OK button with action handler
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                         print("Ok button tapped")
                        //find object delete  in frc
                        self.pManageObject=self.frc.object(at: indexPath) as! Team
                        
                        //delete
                        self.context.delete(self.pManageObject)
                        
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
            if segue.identifier=="seguepassteam"{
                // Get the new view controller using segue.destination.
                
                let destinationController=segue.destination as! DisplayPlayersTableViewController
                //extract data from frc
                let indexPath=tableView.indexPath(for: sender as! UITableViewCell)
                pManageObject=(frc.object(at: indexPath!) as! Team)
                
                // Pass the selected object to the new view controller.
                destinationController.teamObject=pManageObject
            }
        }
        
        
    }
    //MARK: - image methods
    func getImage(name:String)->UIImage{
        //get image name from document
        let imagePath=(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
        let image = UIImage(contentsOfFile: imagePath)
        //Return
        return image!
    }


