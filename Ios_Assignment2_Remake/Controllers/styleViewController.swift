//
//  styleViewController.swift
//  Assignment1IOS-ShubhamKarekar
//
//  Created by Shubham Karekar on 12/03/2023.
//

import UIKit

class styleViewController: UIViewController {

    
    var pManageObject:PlayerEntity!
    @IBOutlet weak var stylelabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        stylelabel.text=pManageObject.style
        // Do any additional setup after loading the view.
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
