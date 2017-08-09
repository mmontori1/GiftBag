//
//  DisplayFriendViewController.swift
//  GiftBag
//
//  Created by Mariano Montori on 8/9/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit

class DisplayFriendViewController: UIViewController {
    
    var friend : User?
    var items = [WishItem](){
        didSet {
            itemCountLabel.text = String(items.count)
        }
    }

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var itemCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        items.append(WishItem(name: "WAT"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension DisplayFriendViewController {
    func configureView(){
        guard let user = friend else {
            return
        }
        profileImage.circular(width: 1.0, color: UIColor.lightGray.cgColor)
        setUser(user)
    }
    
    func setUser(_ user : User){
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        usernameLabel.text = user.username
        itemCountLabel.text = String(items.count)
        if let url = user.profileURL {
            self.resetProfilePic(url: url)
        }
    }
    
    func resetProfilePic(url : String){
        let imageURL = URL(string: url)
        self.profileImage.kf.setImage(with: imageURL)
    }
}

extension DisplayFriendViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishItemCell", for: indexPath) as! WishItemCell
        
        cell.item = items[indexPath.row]
        
        return cell
    }
}

extension DisplayFriendViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 2
        let spacing: CGFloat = 1.5
        let totalHorizontalSpacing = (columns - 1) * spacing
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemHeight : CGFloat = 144 * itemWidth / 130
        let itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
}
