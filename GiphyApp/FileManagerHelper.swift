//
//  FileManagerHelper.swift
//  GiphyApp
//
//  Created by Guillaume Manzano on 25/01/2017.
//  Copyright © 2017 Guillaume Manzano. All rights reserved.
//

import Foundation
import UIKit

class FileManagerHelper
{
    static private var gifs = NSMutableArray()
    
    static func LoadGifs()
    {
        let file = "/gifs.txt"
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true) {
            let dir = dirs[0]
            let path = URL(fileURLWithPath: dir + file)
            do {
                let text = try String(contentsOfFile: path.path, encoding: String.Encoding.utf8)
                // Add Json Library
                // gifs = JSONParseDictionary(text) as? Array<NSDictionary>
                for gif in gifs {
                    let imageUrl = (((gif as! NSDictionary).value(forKey: "images") as? NSDictionary)?.value(forKey: "fixed_width_downsampled") as? NSDictionary)?.value(forKey: "url")
                    
                    let img = ImageCacheHelper.GetImageByUrl(url: imageUrl as! String)
                    if img == nil
                    {
                        if let url = NSURL(string: imageUrl as! String) {
                            if let data = NSData(contentsOf: url as URL) {
                                ImageCacheHelper.SaveImage(image: UIImage(data: data as Data)!, id: ((gif as! NSDictionary).value(forKey: "id") as! String), url: imageUrl as! String)
                            }
                        }
                    }
                }
            }
            catch {
                print("Fail to load ressources")
            }
        }
    }
    
    private static func checkIfDataIsLoad()
    {
        if gifs.count == 0
        {
            LoadGifs()
        }
    }
    
    static func AddFavoritesGif(gif: NSDictionary)
    {
        checkIfDataIsLoad()
        gifs.add(gif)
        SaveGifs()
    }
    
    static func RemoveFavoritesGif()
    {
        checkIfDataIsLoad()
        // Find by ID
        SaveGifs()
    }
    
    static func SaveGifs()
    {
        
    }
}
