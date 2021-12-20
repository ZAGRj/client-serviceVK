//
//  MyGroupController.swift
//  1|_ Загржеевская Юлия
//
//  Created by Julie Zagr on 09.11.2021.
//

import UIKit

class MyGroupController: UITableViewController {

    var myGroups = [String]()
   
    
//    MARK: OVERRIDE FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MyGroupsAPI.myGroupsRequestAlamofire()

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "myGroupCell", for: indexPath) as? MyGroupCell else {
          return UITableViewCell()
      }

    let group = myGroups[indexPath.row]

    cell.grName.text = group
    cell.grAvatar.image = UIImage(named: group)
    cell.grAvatar.layer.cornerRadius =  cell.grAvatar.frame.height/2
    cell.grAvatar.contentMode = .scaleAspectFill
     
    if UIImage(named: group) == nil {
        cell.grAvatar.image = UIImage(named: "NOPHGR")
    }
    
//    MARK: Tap animation on avatar
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapIconGroups(tapGestureRecognizer:)))
    cell.grAvatar.isUserInteractionEnabled = true
    cell.grAvatar.addGestureRecognizer(tapGestureRecognizer)
    cell.grAvatar.tag = indexPath.row

    return cell
    
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          
    if editingStyle == .delete {
        myGroups.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
 
// MARK: @IBACTIONS
    
    @IBAction func addGroup (segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
            guard let searchGroupController = segue.source as? SearchGroupController else {
                return
            }
        if let indexPath = searchGroupController.tableView.indexPathForSelectedRow {
            let group = searchGroupController.filterGroups[indexPath.row]
            if !myGroups.contains(group.name) {
                myGroups.append(group.name)
                tableView.reloadData()
            }
        }
    }
}
    
//  MARK: @PBJC FUNCTIONS
    
    
    
//  MARK: Animation block
            
    @objc func tapIconGroups(tapGestureRecognizer: UIGestureRecognizer) {
        guard let tapIconGroups = tapGestureRecognizer.view as? UIImageView else {
                return
        }
        UIView.animate(
            withDuration: 3.5,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0,
            options: [.curveEaseInOut],
            animations: { [weak self]  in
                tapIconGroups.layer.cornerRadius = tapIconGroups.layer.frame.height/2
                tapIconGroups.bounds = CGRect(x: 250, y: 250, width: 250, height: 250)},
            completion: nil)
    }
}
