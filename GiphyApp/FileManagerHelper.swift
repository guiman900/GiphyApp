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
    static private var loaded = false
    
    private static func loadGifs()
    {
        let file = "/gifs.txt"
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true) {
            let dir = dirs[0]
            let path = URL(fileURLWithPath: dir + file)
            do {
                let text = try String(contentsOfFile: path.path, encoding: String.Encoding.utf8)
                gifs = JSONParseDictionary(text)
                loaded = true
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
        if loaded == true
        {
            loadGifs()
        }
    }
    
    static func GetGifById(id: String) -> NSDictionary?
    {
        checkIfDataIsLoad()
        for item in gifs
        {
            if (item as! NSDictionary)["id"] as! String == id
            {
                return item as! NSDictionary
            }
        }
        return nil
    }
    
    static func GetGifs() -> NSMutableArray
    {
        checkIfDataIsLoad()
        return gifs
    }
    
    static func AddFavoritesGif(gif: NSDictionary)
    {
        checkIfDataIsLoad()
        gifs.add(gif)
        saveGifs()
    }
    
    static func RemoveFavoritesGif(id: String)
    {
        checkIfDataIsLoad()
        var itemToDelete: NSDictionary? = nil
        for item in gifs
        {
            if (item as! NSDictionary)["id"] as! String == id
            {
                itemToDelete = item as? NSDictionary
                break
            }
        }
        gifs.remove(itemToDelete!)
        saveGifs()
    }
    
    private static func saveGifs()
    {
        let file = "/gifs.txt"
        if let dirs: [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        {
            let dir = dirs[0] //documents directory
            let path = URL(fileURLWithPath: dir + file)
            let text = JSONStringify(self.gifs as AnyObject, prettyPrinted: true)
            do {
                try text.write(toFile: path.path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {
                print("fail to save")
            }
        }
    }
    
    private static func JSONStringify(_ value: AnyObject, prettyPrinted: Bool = false) -> String {
        let options = JSONSerialization.WritingOptions.prettyPrinted
        if JSONSerialization.isValidJSONObject(value) {
            
            do {
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }
            catch {
                print("fail to serialise")
            }
        }
        return ""
    }
    
    private static func JSONParseDictionary(_ jsonString: String) -> NSMutableArray
    {
        do {
            if let data = jsonString.data(using: String.Encoding.utf8) {
                let dictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? NSMutableArray
                return dictionary!
            }
        }
        catch {
            print("Fail to load")
        }
        return NSMutableArray()
    }
}
