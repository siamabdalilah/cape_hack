//
//  tableViewController.swift
//  MedX
//
//  Created by Xiangmin Zhang on 7/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class tableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var hospital: String?
    var record = ["first","second","third", "fourth","fifth"]
    @IBOutlet weak var toLabel: UILabel!
    
    @IBOutlet weak var recordLists: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordLists.delegate = self
        recordLists.dataSource = self
        recordLists.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        recordLists.reloadData()
        toLabel.text = "Grannting access to"+(hospital ?? "not found")
        
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style:.subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = "\(record[indexPath.row])"
        cell.detailTextLabel?.text = "description"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let grant = grantAction(at: indexPath)
        let revoke = revokeAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [grant,revoke])
    }
   
    func grantAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .normal, title:"Grant", handler: {
            (action, view, completion) in
            completion(true)
        })
        action.backgroundColor = UIColor.green
        return action
    }
    
    func revokeAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .normal, title:"revoke", handler: {
            (action, view, completion) in
            completion(true)
        })
        action.backgroundColor = UIColor.red
        return action
    }
    
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        let label = UILabel(frame: CGRect(x: 10,y: 5,width: tableView.frame.width,height:20))
        label.text = "Date"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = #colorLiteral(red: 0.4459883571, green: 0.6351390481, blue: 0.7786456347, alpha: 1)
        label.sizeToFit()
        view.backgroundColor = #colorLiteral(red: 0.4459883571, green: 0.6351390481, blue: 0.7786456347, alpha: 1)
        view.addSubview(label)
        return view
        
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
