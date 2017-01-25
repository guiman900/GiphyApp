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
    @IBOutlet weak var webViewGif: UIWebView!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    
    @IBAction func RemoveToFavorites(_ sender: Any) {
    }
    @IBAction func AddToFavorites(_ sender: Any) {
    }
    func setGifUrl(url: String)
    {
        gifUrl = URL(string : url)!
    }
    
    @IBAction func ClosePopUp(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonClose.layer.borderColor = UIColor.black.cgColor
        buttonClose.layer.borderWidth = 1
        buttonClose.layer.cornerRadius = 8
        webViewGif.loadRequest(URLRequest(url: gifUrl!))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
