//
//  DisplayFriendViewController.swift
//  GiftBag
//
//  Created by Mariano Montori on 8/9/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import SCLAlertView
import FirebaseDatabase

class DisplayFriendViewController: UIViewController {
    
    var friend : User?
    var items = [WishItem](){
        didSet {
            itemCountLabel.text = String(items.count)
            items.sort(by: { $0.timestamp.compare($1.timestamp as Date) == .orderedDescending })
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var selected : Int?
    let refreshControl = UIRefreshControl()
    var profileHandle: DatabaseHandle = 0
    var profileRef: DatabaseReference?

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var itemCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        guard let user = friend else {
            return
        }
        profileHandle = UserService.observeProfile(for: user) { [unowned self] (ref, user) in
            self.profileRef = ref
            guard let user = user else {
                return
            }
            self.setUser(user)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("IM ALSO OUTTA HERE")
        profileRef?.removeObserver(withHandle: profileHandle)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toSelectedItem" {
                let wishItemViewController = segue.destination as! WishItemViewController
                guard let index = selected else {
                    SCLAlertView().genericError()
                    return
                }
                wishItemViewController.wishItem = items[index]
                print("To Wish Item Screen!")
            }
        }
    }
    
    @IBAction func unwindToDisplayFriend(_ segue: UIStoryboardSegue) {
        print("Returned to Display Friend Screen!")
    }
}

extension DisplayFriendViewController {
    func configureView(){
        refreshControl.addTarget(self, action: #selector(reloadWishlist), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        profileImage.circular(width: 1.0, color: UIColor.lightGray.cgColor)
    }
    
    func configureWillAppear(_ animated: Bool){
        refreshControl.endRefreshing()
        if items.count > 0 && collectionView.contentOffset.y < 0 {
            self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                              at: .top,
                                              animated: true)
        }
        
        guard let user = friend else {
            return
        }
        setUser(user)
    }
    
    func setUser(_ user : User){
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        usernameLabel.text = user.username
        itemCountLabel.text = String(items.count)
        if let url = user.profileURL {
            self.resetProfilePic(url: url)
        }
        reloadWishlist()
    }
    
    func resetProfilePic(url : String){
        let imageURL = URL(string: url)
        self.profileImage.kf.setImage(with: imageURL)
    }
    
    func reloadWishlist() {
        guard let user = friend else {
            return
        }
        UserService.wishlist(for: user) { (savedItems) in
            self.items = savedItems
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
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

extension DisplayFriendViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView,
                        shouldSelectItemAt indexPath: IndexPath) -> Bool {
        selected = indexPath.row
        performSegue(withIdentifier: "toSelectedItem", sender: self)
        return false
    }
}

extension DisplayFriendViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 2
        let spacing: CGFloat = 1.5
        let totalHorizontalSpacing = (columns - 1) * spacing
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemHeight : CGFloat = 235 * itemWidth / 169
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
