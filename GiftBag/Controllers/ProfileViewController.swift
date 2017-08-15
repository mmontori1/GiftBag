//
//  MainViewController.swift
//  Firebase-boilerplate
//
//  Created by Mariano Montori on 7/24/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import SCLAlertView
import Kingfisher
import FirebaseDatabase

class ProfileViewController: UIViewController {
    var items = [WishItem]() {
        didSet {
            itemCountLabel.text = String(items.count)
            items.sort(by: { $0.timestamp.compare($1.timestamp as Date) == .orderedDescending })
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    let refreshControl = UIRefreshControl()
    var selected : Int?
    var profileHandle: DatabaseHandle = 0
    var profileRef: DatabaseReference?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var itemCountLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureWillAppear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileHandle = UserService.observeProfile(for: User.current) { [unowned self] (ref, user) in
            self.profileRef = ref
            guard let user = user else {
                return
            }
            User.setCurrent(user, writeToUserDefaults: true)
            self.setLabels()
            if let url = user.profileURL {
                self.resetProfilePic(url: url)
            }
        }
        configureView()
        reloadWishlist()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toSettings" {
                print("To Settings Screen!")
            }
            else if identifier == "toCreateItem" {
                print("To Create Item Screen!")
            }
            else if identifier == "toSelectedItem" {
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
    
    deinit {
        profileRef?.removeObserver(withHandle: profileHandle)
    }
    
    @IBAction func addItemClicked(_ sender: Any) {
        performSegue(withIdentifier: "toCreateItem", sender: self)
    }
    
    @IBAction func settingsClicked(_ sender: Any) {
        performSegue(withIdentifier: "toSettings", sender: self)
    }
    
    @IBAction func unwindToMain(_ segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            if identifier == "saveItem" {
//                let createWishListController = segue.source as! CreateWishListItemViewController
//                guard let newItem = createWishListController.newItem else {
//                    SCLAlertView().genericError()
//                    return
//                }
//                items.append(newItem)
                reloadWishlist()
//                SCLAlertView().showSuccess("Success!", subTitle: "You've created a new wish list item")
            }
            else if identifier == "saveEdit" {
                reloadWishlist()
            }
        }
        print("Returned to Main Screen!")
    }
}

extension ProfileViewController {
    func configureWillAppear(){
        refreshControl.endRefreshing()
        if items.count > 0 && collectionView.contentOffset.y < 0 {
            self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                              at: .top,
                                              animated: true)
        }
    }
    
    func configureView(){
        refreshControl.addTarget(self, action: #selector(reloadWishlist), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        profileImage.circular(width: 1.0, color: UIColor.lightGray.cgColor)
        setLabels()
    }
    
    func reloadWishlist() {
        UserService.wishlist(for: User.current) { (savedItems) in
            self.items = savedItems
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func setLabels(){
        nameLabel.text = "\(User.current.firstName) \(User.current.lastName)"
        usernameLabel.text = User.current.username
        itemCountLabel.text = String(items.count)
    }
    
    func resetProfilePic(url : String){
        let imageURL = URL(string: url)
        self.profileImage.kf.setImage(with: imageURL)
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishItemCell", for: indexPath) as! WishItemCell
        
        cell.item = items[indexPath.row]
 
        return cell
    }
}

extension ProfileViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView,
                                 shouldSelectItemAt indexPath: IndexPath) -> Bool {
        print(items[indexPath.row].dictValue)
        selected = indexPath.row
        performSegue(withIdentifier: "toSelectedItem", sender: self)
        return false
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
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
