//
//  MyFriendsController.swift
//  1|_ Загржеевская Юлия
//
//  Created by Julie Zagr on 09.11.2021.
//

import UIKit

class MyFriendsController: UITableViewController {


    @IBOutlet weak var tableViewFriends: UITableView!
    
    var myFriends = UserFriendArray()
    var firstLetterFriends = [String]()
    var dictionaryFriends =  [String: [UserFriend]]()
    let headerID = String(describing: HeaderFriendsView.self)
 
//    MARK: OVERRIDE FUNCTIONS
    
    override func viewDidLoad() {
    super.viewDidLoad()
        myFriends.userProfile.sort()
        configFriendsHeader()
        uploadFirstLetterFriends()
        uploadKeyInDictionatyFriends()
        uploadValueInDictionaryFriends()
        FriendsAPI.friendsRequestAlamofire()
        AvatarFriends.friendsAvatarRequestAlamofire()
//        MyGroupsAPI.myGroupsRequestAlamofire()
//        SearchGroupsAPI.searchGroupsRequestAlamofire()
         
        tableViewFriends.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.tableViewFriends.alpha = 1
         }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return firstLetterFriends.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let describingValue = firstLetterFriends[section]
    let numberOfRows = dictionaryFriends[describingValue]
        return numberOfRows!.count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "myFrCell", for: indexPath) as? MyFriendsCell else {
        return UITableViewCell()
        }
       
//        MARK: Dictionary links
        
    let key = firstLetterFriends[indexPath.section]
    let arrayForFriendsRow = dictionaryFriends[key]
        
//        MARK: Name and avatar
        
    let friend = arrayForFriendsRow?[indexPath.row]
        
    cell.nameFriend.text = friend?.name
    if cell.nameFriend.text == "" {
        cell.nameFriend.text = "NO NAME"
    }
        
    cell.surnnameFriend.text = friend?.surname
    if cell.surnnameFriend.text == "" {
        cell.surnnameFriend.text = ""
    }
        
    cell.avatar.layer.cornerRadius = cell.avatar.frame.height/2
    cell.avatar.backgroundColor = .darkGray
    cell.avatar.contentMode = .scaleAspectFill
    cell.avatar.image = UIImage(named: (friend?.imageName.namePhotoFriend)!)

    if UIImage(named: (friend?.imageName.namePhotoFriend)!) == nil {
        cell.avatar.image = UIImage(named: "NOPHOTO")
    }

//      MARK: Shadow for an avatar
        
    cell.shadowAvatar.layer.cornerRadius = cell.avatar.layer.cornerRadius
    cell.shadowAvatar.clipsToBounds = false
    cell.shadowAvatar.layer.shadowColor = UIColor.init(displayP3Red: 255, green: 238, blue: 153, alpha: 0.9).cgColor
    cell.shadowAvatar.layer.shadowOpacity = 1
    cell.shadowAvatar.layer.shadowOffset = CGSize.zero
    cell.shadowAvatar.layer.shadowRadius = 6
    
//    MARK: Tap animation on avatar
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapIconFriends(tapGestureRecognizer:)))
    cell.avatar.isUserInteractionEnabled = true
    cell.avatar.addGestureRecognizer(tapGestureRecognizer)
    cell.avatar.tag = indexPath.row
        
//    MARK: gradient for view of Friends Names
        
    let myGradient = CAGradientLayer()
        myGradient.colors = [UIColor.init(displayP3Red: 100, green: 98, blue: 80, alpha: 0.3).cgColor, UIColor.init(_colorLiteralRed: 162, green: 160, blue: 131, alpha: 0.003).cgColor]
        myGradient.locations = [ 0 as NSNumber, 1 as NSNumber]
        myGradient.startPoint = CGPoint.init(x: 1, y: 1)
        myGradient.endPoint = CGPoint(x: 0.36, y: 1)
        cell.gradientColor.layer.insertSublayer(myGradient, at: 0)
        myGradient.frame = cell.gradientColor.bounds
        
//        UIView.animate(withDuration: 0.55, animations: {cell.bounds.size = CGSize.init(width: 0, height: cell.bounds.height)})
                
        return cell
    }

//    MARK:  transfering photo avatar to cell + like saving
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let photoVk = segue.destination as? PhotosController else {
            return
        }
        guard let seguePath = segue.source as? MyFriendsController else {
            return
        }
    
    if let newIndex = seguePath.tableView.indexPathForSelectedRow {
        let indexSegue = seguePath.firstLetterFriends[newIndex.section]
        let indexSection = dictionaryFriends[indexSegue]
        let indexPhotoRow = indexSection?[newIndex.row]
        
        photoVk.avatarArray = indexPhotoRow
        photoVk.isLiked = indexPhotoRow?.imageName.isLikedPhoto
    }
}

//    MARK: PRIVATE FUNCTIONS
    
    
    
//    MARK: Header
    
// header registration
    private func configFriendsHeader() {
    let nib = UINib(nibName: headerID, bundle: nil)
        tableViewFriends.register(nib, forHeaderFooterViewReuseIdentifier: headerID)
        tableViewFriends.tableFooterView = UIView()
    }
//    end registarartion
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let headerFriends = tableViewFriends.dequeueReusableHeaderFooterView(withIdentifier: headerID) as? HeaderFriendsView else {
        return UIView()
    }
        
    headerFriends.firstLetterFriendLabel.backgroundColor = .white
    headerFriends.firstLetterFriendLabel.layer.opacity = 0.5
    headerFriends.firstLetterFriendLabel.textColor = .gray
    headerFriends.firstLetterFriendLabel.text = firstLetterFriends[section]
    headerFriends.tintColor = .white
    headerFriends.layer.opacity = 0.75
        
        return headerFriends
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 33
    }
    
    func uploadFirstLetterFriends() {
        
        var n = 0
        while n < myFriends.userProfile.count {
            
            let firstLetterIndex = myFriends.userProfile[n].name.index(myFriends.userProfile[n].name.startIndex, offsetBy: 1)
            let firstLetter = String(myFriends.userProfile[n].name[..<firstLetterIndex])
            if !firstLetterFriends.contains(firstLetter) {
                    firstLetterFriends.append(firstLetter)
                        n += 1
                } else {
                        n += 1
        }
    }
}
    
    func uploadKeyInDictionatyFriends() {
        var n = 0
        while n < firstLetterFriends.count {
                dictionaryFriends[firstLetterFriends[n]] = [UserFriend]()
                n += 1
    }
}
    
    func uploadValueInDictionaryFriends() {
        
        var n = 0
        while n < myFriends.userProfile.count {
            
            let firstLetterIndex = myFriends.userProfile[n].name.index(myFriends.userProfile[n].name.startIndex, offsetBy: 1)
            let firstLetter = String(myFriends.userProfile[n].name[..<firstLetterIndex])
            dictionaryFriends[firstLetter]! += [myFriends.userProfile[n]]
            n += 1
    }
}
    
//  MARK: @OBJC FUNCTIONS
    
//    MARK: Aimation block
    
    @objc func tapIconFriends(tapGestureRecognizer: UIGestureRecognizer) {
    guard let tapIconFriends = tapGestureRecognizer.view as? UIImageView else {
            return
    }
        UIView.animate(
            withDuration: 2,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0,
            options: [.curveEaseInOut],
            animations: { [weak self]  in
                tapIconFriends.layer.cornerRadius = tapIconFriends.layer.frame.height/2
                tapIconFriends.bounds = CGRect(x: 0.5, y: 0.5, width: 0.5, height: 0.5)},
            completion: nil)
    }
}
