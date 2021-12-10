//
//  PhotosController.swift
//  1|_ Загржеевская Юлия
//
//  Created by Julie Zagr on 09.11.2021.
//

import UIKit

class PhotosController: UICollectionViewController {

    var isLiked: Bool?
    var avatarArray: UserFriend?
    let blankSpace = "" /// replace "0" in lables with blanck space

//    MARK: OVERRIDE FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return 1
       }
  
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCollectionCell", for: indexPath) as? PhotosCell else {
            return UICollectionViewCell()
        }
        
    cell.albumPhotoFriendsCell.image = UIImage(named: (avatarArray?.imageName.namePhotoFriend)!)
    if UIImage(named: (avatarArray?.imageName.namePhotoFriend)!) == nil {
        cell.albumPhotoFriendsCell.image = UIImage(named: avatarArray?.imageName.namePhotoFriend ?? "NOPHOTO")
    }
        
//  shadow for picture
    cell.shadowView.layer.cornerRadius = cell.albumPhotoFriendsCell.layer.cornerRadius
    cell.shadowView.clipsToBounds = false
    cell.shadowView.layer.shadowColor = UIColor.init(displayP3Red: 169, green: 165, blue: 135, alpha: 0.9).cgColor
    cell.shadowView.layer.shadowOpacity = 1
    cell.shadowView.layer.shadowOffset = CGSize.zero
    cell.shadowView.layer.shadowRadius = 4.5

//     MARK: Like controller
      
//  left coner round
    let pathLike = UIBezierPath(roundedRect: cell.likeView.bounds, byRoundingCorners: [.topLeft], cornerRadii: CGSize(width: 15, height: 15))
                                    
    let maskView = CAShapeLayer()
    maskView.path = pathLike.cgPath
    cell.likeView.layer.mask = maskView
    cell.likeView.clipsToBounds = true
//  end
        
    guard let likeSave = isLiked else {
        return UICollectionViewCell()
    }
            
    avatarArray?.imageName.isLikedPhoto = likeSave
    if avatarArray?.imageName.isLikedPhoto == false {
        UIView.transition(
            with: cell.numberOfLikes,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: {cell.shadowView.layer.shadowColor = UIColor(red: 0.128, green: 0.126, blue: 0.102, alpha: 1).cgColor},
            completion: nil )
        cell.numberOfLikes.text = blankSpace
        cell.numberOfLikes.textColor = UIColor.white
        cell.likeButton.tintColor = UIColor.white
        } else {
        UIView.transition(
            with: cell.shadowView,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {cell.numberOfLikes.layer.shadowColor = UIColor(red: 0.255, green: 0.238, blue: 0.153, alpha: 1).cgColor},
            completion: nil )
        cell.numberOfLikes.text = "1"
        cell.numberOfLikes.textColor = UIColor(red: 0.128, green: 0.126, blue: 0.102, alpha: 0.5)
        cell.likeButton.tintColor = UIColor(red: 0.128, green: 0.126, blue: 0.102, alpha: 0.5)
        cell.shadowView.layer.shadowColor = UIColor(red: 0.255, green: 0.238, blue: 0.153, alpha: 1).cgColor
                
//  if u push the button - light becomes less bright
// cell.shadowView.layer.shadowColor = UIColor.init(displayP3Red: 255, green: 238, blue: 153, alpha: 0.4).cgColor
    }
        return cell
    }

//    MARK: @IBACTIONS
    
    @IBAction func likePushButton(_ sender: Any) {
        if isLiked == false {
            isLiked = true
            collectionView.reloadData()
        } else {
            isLiked = false
            collectionView.reloadData()
        }
    }
}
