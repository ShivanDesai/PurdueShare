//
//  ShareFeedViewController.swift
//  PurdueShare
//
//  Created by Shivan Desai on 4/26/18.
//  Copyright © 2018 Shiva Productions. All rights reserved.
//

import UIKit

class ShareFeedViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    

    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self as! UITableViewDelegate
        table.dataSource = self as! UITableViewDataSource

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShareFeedCell", for: indexPath) as! ShareFeedTableCell
        cell.userImage = nil
        cell.productName.text = "someprod"
        cell.userName.text = "somename"
        cell.duration.text = "someduration"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showPostSegue", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
