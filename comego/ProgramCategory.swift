//
//  ProgramCategory.swift
//  flasog
//
//  Created by Jonathan Horta on 8/4/17.
//  Copyright © 2017 iddeas. All rights reserved.
//

import Foundation

class ProgramCat:NSObject{
    var id:Int = 0
    var title:String = ""
    var image:String = ""
    var schedule:String = ""
    var link:String = ""
    var items:[ProgramItem] = []
}
