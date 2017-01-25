//
//  DetailViewController.swift
//  GiphyApp
//
//  Created by Guillaume Manzano on 24/01/2017.
//  Copyright © 2017 Guillaume Manzano. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class DetailViewController: UIViewController
{
    private var gifUrl: URL?
    private var dictionnaryInformations: NSDictionary?
    @IBOutlet weak var webViewGif: UIWebView!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    
    @IBAction func RemoveToFavorites(_ sender: Any) {
        FileManagerHelper.RemoveFavoritesGif(id: (dictionnaryInformations?["id"]) as! String)
        buttonAdd.isHidden = false
        buttonDelete.isHidden = true
    }
    @IBAction func AddToFavorites(_ sender: Any) {
        FileManagerHelper.AddFavoritesGif(gif: dictionnaryInformations!)
        buttonAdd.isHidden = true
        buttonDelete.isHidden = false
    }
    func SetGifUrl(dict: NSDictionary, url: String)
    {
        dictionnaryInformations = dict
        gifUrl = URL(string : url)!
    }
    
    @IBAction func ClosePopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonClose.layer.borderColor = UIColor.black.cgColor
        buttonClose.layer.borderWidth = 1
        buttonClose.layer.cornerRadius = 8
        
        buttonDelete.layer.borderColor = UIColor.black.cgColor
        buttonDelete.layer.borderWidth = 1
        buttonDelete.layer.cornerRadius = 8
        
        buttonAdd.layer.borderColor = UIColor.black.cgColor
        buttonAdd.layer.borderWidth = 1
        buttonAdd.layer.cornerRadius = 8
        
        webViewGif.loadRequest(URLRequest(url: gifUrl!))
        if FileManagerHelper.IsGifFavorite(id: (dictionnaryInformations?["id"]) as! String) == false
        {
            buttonAdd.isHidden = false
        }
        else {
            buttonDelete.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
