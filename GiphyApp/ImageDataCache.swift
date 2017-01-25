//
//  ImageDataCache.swift
//  GiphyApp
//
//  Created by Guillaume Manzano on 24/01/2017.
//  Copyright © 2017 Guillaume Manzano. All rights reserved.
//

import Foundation
import UIKit

struct ImageDataCache
{
    init(image: UIImage, id: String, url: String)
    {
        ImageSaved = image
        Id = id
        Url = url
    }
    var Id: String = ""
    var ImageSaved: UIImage
    var Url = ""
}
