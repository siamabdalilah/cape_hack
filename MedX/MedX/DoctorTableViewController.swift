//
//  DoctorTableViewController.swift
//  MedX
//
//  Created by Xiangmin Zhang on 7/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class DoctorTableViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var fileAddresses:[String] = []
    var fileNumbers: [Int] = []
    var fileNames: [String] = []
    var qrData: [Dictionary<String , Any>]?
    let theData:Records? = nil
    
    
    

    var hospital: String?

    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        convertQRToJSonArray()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.reloadData()
        toLabel.text = "Grannting access to"+(hospital ?? "not found")
        print("the content is: \(hospital)")
        // Do any additional setup after loading the view.
    }
    
    
    func convertQRToJSonArray(){
        //first step is to convert json string to json object
        var string = "[{\"fileNumber\":1,\"fileName\":{\"Name\":\"BrokenLeg\",\"Address\":\"publicKey\",\"ACL\":\"Lists\"}},{\"fileNumber\":2,\"fileName\":{\"Name\":\"BrokenLeg\",\"Address\":\"publicKey\",\"ACL\":\"Lists\"}}]"
        string = "{\"records\": \(string)}"
        let data = string.data(using: .utf8)!
        print("string: \(string)")
        print("data: \(data)")
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(Records.self, from: data)
            print(object.records[0].fileNumber)
            print(object.records[1].fileNumber)
            for index in 0..<object.records.count{
                fileNumbers.append(object.records[index].fileNumber)
                fileNames.append(object.records[index].fileName.Name)
                fileAddresses.append(object.records[index].fileName.Address)
            }
        } catch let error as NSError {
            print("error: \(error)")
        }
        
        //parse json into structs
        
    }
    
    //    func decodeJSonArray(array: [Dictionary<String , Any>]){
    //        let decode = JSONDecoder.init()
    //        decode.decode(Records.self, from: <#T##Data#>)
    //    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileNumbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style:.subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = "\(fileNames[indexPath.row])"
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
