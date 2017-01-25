//
//  SecondViewController.swift
//  GiphyApp
//
//  Created by Guillaume Manzano on 24/01/2017.
//  Copyright © 2017 Guillaume Manzano. All rights reserved.
//

import UIKit
import Alamofire

class SecondViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private let itemsPerRow: CGFloat = 2
    private var images = Array<NSDictionary>()
    private let reuseIdentifier = "cell"
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CustomCollectionCell
        let imageUrl = ((images[indexPath.row].value(forKey: "images") as? NSDictionary)?.value(forKey: "fixed_width_downsampled") as? NSDictionary)?.value(forKey: "url")
        
        if let img = ImageCacheHelper.GetImageByUrl(url: imageUrl as! String)
        {
            cell.Image.image = img
        }
        else {
            if let url = NSURL(string: imageUrl as! String) {
                if let data = NSData(contentsOf: url as URL) {
                    cell.Image.image = UIImage(data: data as Data)
                    ImageCacheHelper.SaveImage(image: UIImage(data: data as Data)!, id: (images[indexPath.row].value(forKey: "id") as! String), url: imageUrl as! String)
                }
            }
        }
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = 5 * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 2, bottom: 5, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DetailViewControllerID") as! DetailViewController
        nextViewController.SetGifUrl(dict: images[indexPath.row], url: ((images[indexPath.row].value(forKey: "images") as? NSDictionary)?.value(forKey: "fixed_height") as? NSDictionary)?.value(forKey: "url") as! String)
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty == false {
            self.collectionView.isHidden = true
            self.activityIndicator.startAnimating()
            let newString = searchBar.text?.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
            Alamofire.request("http://api.giphy.com/v1/gifs/search?q=\(newString!)&api_key=dc6zaTOxFJmzC").responseJSON { response in
                if let JSON = response.result.value {
                    self.images = (JSON as! NSDictionary).value(forKey: "data") as! Array<NSDictionary>
                    for item in self.images
                    {
                        let imageUrl = ((item.value(forKey: "images") as? NSDictionary)?.value(forKey: "fixed_width_downsampled") as? NSDictionary)?.value(forKey: "url")
                        
                        if ImageCacheHelper.GetImageByUrl(url: imageUrl as! String) == nil
                        {
                            if let url = NSURL(string: imageUrl as! String) {
                                if let data = NSData(contentsOf: url as URL) {
                                    ImageCacheHelper.SaveImage(image: UIImage(data: data as Data)!, id: (item.value(forKey: "id") as! String), url: imageUrl as! String)
                                }
                            }
                        }
                    }
                    self.activityIndicator.stopAnimating()
                    self.collectionView.isHidden = false
                    self.collectionView.reloadData()
                }
                else
                {
                    let alert = UIAlertController(title: "Error", message: "Please check your network", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.activityIndicator.stopAnimating()
                    self.collectionView.isHidden = false
                }
            }
        }
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SecondViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

