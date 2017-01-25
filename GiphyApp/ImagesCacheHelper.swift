//
//  ImagesCacheHelper.swift
//  GiphyApp
//
//  Created by Guillaume Manzano on 24/01/2017.
//  Copyright © 2017 Guillaume Manzano. All rights reserved.
//

import Foundation
import UIKit

class ImageCacheHelper
{
    private static var imageList =  NSMutableArray()
    
    static func GetImageByUrl(url: String) -> UIImage?
    {
            for item in imageList
            {
                if (item as! ImageDataCache).Url == url
                {
                    return (item as! ImageDataCache).ImageSaved
                }
            }
        return nil
    }
    
    static func SaveImage(image: UIImage, id: String, url: String)
    {
      let item = ImageDataCache(image: image, id: id, url: url)
      imageList.add(item)
    }

}
