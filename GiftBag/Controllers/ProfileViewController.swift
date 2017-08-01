//
//  MainViewController.swift
//  Firebase-boilerplate
//
//  Created by Mariano Montori on 7/24/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import SCLAlertView

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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var itemCountLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureAppear()
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
    func configureAppear(){
        refreshControl.addTarget(self, action: #selector(reloadWishlist), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
    }
    
    func configureView(){
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
        cell.backgroundColor = UIColor.lightGray
 
        return cell
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 2
        let spacing: CGFloat = 1.5
        let totalHorizontalSpacing = (columns - 1) * spacing
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
}
