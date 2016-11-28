//
//  Post.swift
//  iOS_AlamoFire
//
//  Created by imac on 28/11/2016.
//  Copyright © 2016 imac. All rights reserved.
//

import Foundation
import ObjectMapper

class Post:Mappable {
    var body:String = ""
    var id:Int = 0
    var title:String = ""
    var userId:Int = 0
    
    required init?(map: Map){
    }
    func mapping(map: Map) {
        body <- map["body"]
        id <- map["id"]
        title <- map["title"]
        userId <- map["userId"]
    }
}
