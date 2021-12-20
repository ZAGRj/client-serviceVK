//
//  SearchGroupController.swift
//  1|_ Загржеевская Юлия
//
//  Created by Julie Zagr on 09.11.2021.
//

import UIKit

class SearchGroupController: UITableViewController, UISearchBarDelegate {
    
 @IBOutlet weak var searchGroupBar: UISearchBar!
    
    var searchGroup = GroupArray()
    var filterGroups = [Group]()

// MARK: OVERRIDE FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchGroupBar.delegate = self
        filterGroups = searchGroup.groups
        SearchGroupsAPI.searchGroupsRequestAlamofire()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterGroups.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchGroupCell", for: indexPath) as? SearchGroupCell else {
            return UITableViewCell()
    }

    let group = filterGroups[indexPath.row]

    cell.searchGroupName.text = group.name

    cell.searchGroupAvatar.layer.cornerRadius = cell.searchGroupAvatar.frame.height/2
    cell.searchGroupAvatar.contentMode = .scaleAspectFill
    cell.searchGroupAvatar.image = UIImage(named: group.imageName)
      
    if UIImage(named: group.imageName) == nil {
        cell.searchGroupAvatar.image = UIImage(named: "NOPHGR")
    }

//    MARK: Tap animation on avatar
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapIconSearchGroups(tapGestureRecognizer:)))
    cell.searchGroupAvatar.isUserInteractionEnabled = true
    cell.searchGroupAvatar.addGestureRecognizer(tapGestureRecognizer)
    cell.searchGroupAvatar.tag = indexPath.row
        
        return cell
    }
    
//     MARK: SearchBarGroup Config
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filterGroups = []
        
        if searchText == "" {
            filterGroups = searchGroup.groups
        } else {
            for searchgroup in searchGroup.groups {
                if searchgroup.name.lowercased().contains(searchText.lowercased()) {
                filterGroups.append(searchgroup)
            }
        }
    }
        self.tableView.reloadData()
    }
    
// MARK: @OBJC FUNCTIONS
    
    
    
//    MARK: Animation block
        
    @objc func tapIconSearchGroups(tapGestureRecognizer: UIGestureRecognizer) {
        guard let tapIconSearchGroups = tapGestureRecognizer.view as? UIImageView else {
                return
        }
        UIView.animate(
            withDuration: 3.5,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0,
            options: [.curveEaseInOut],
            animations: { [weak self]  in
                tapIconSearchGroups.layer.cornerRadius = tapIconSearchGroups.layer.frame.height/2
                tapIconSearchGroups.bounds = CGRect(x: 250, y: 250, width: 250, height: 250)},
            completion: nil)
    }
}
