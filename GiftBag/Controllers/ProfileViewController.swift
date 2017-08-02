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
                print("To Create Item")
            }
        }
    }
    
    @IBAction func addItemClicked(_ sender: Any) {
        performSegue(withIdentifier: "toCreateItem", sender: self)
    }
    
    @IBAction func settingsClicked(_ sender: Any) {
        performSegue(withIdentifier: "toSettings", sender: self)
    }
    
    @IBAction func unwindToMain(_ segue: UIStoryboardSegue) {
        nameLabel.text = "\(User.current.firstName) \(User.current.lastName)"
        usernameLabel.text = User.current.username
        if let identifier = segue.identifier {
            if identifier == "saveItem" {
                let createWishListController = segue.source as! CreateWishListItemViewController
                guard let newItem = createWishListController.newItem else {
                    SCLAlertView().genericError()
                    return
                }
                items.append(newItem)
                SCLAlertView().showSuccess("Success!", subTitle: "You've created a new wish list item")
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
        if let url = User.current.profileURL {
            let imageURL = URL(string: url)
            profileImage.kf.setImage(with: imageURL)
        }
    }
    
    func configureView(){
        refreshControl.addTarget(self, action: #selector(reloadWishlist), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        profileImage.circular(width: 1.0, color: UIColor.darkGray.cgColor)
        nameLabel.text = "\(User.current.firstName) \(User.current.lastName)"
        usernameLabel.text = User.current.username
        itemCountLabel.text = String(items.count)
    }
    
    func reloadWishlist() {
        UserService.wishlist(for: User.current) { (savedItems) in
            self.items = savedItems
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of cells: \(items.count)")
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishItemCell", for: indexPath) as! WishItemCell
 
        let item = items[indexPath.row]
        cell.nameTextField.text = item.name
 
        return cell
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
