//
//  Api.swift
//  comego
//
//  Created by Jonathan Horta on 5/12/18.
//  Copyright © 2018 iddeas. All rights reserved.
//

import Foundation
let baseUrl = "https://comego.iddeasapps.xyz/api/v1/"
func getApiBaseUrl()->String{
    return baseUrl
}
func dateFormatCustom(_ dateStr:String, _ dateStr2:String, lineBreak:Bool=false)->String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
    dateFormatter.locale = Locale(identifier: "es_MX")
    if let date1 = dateFormatter.date(from:dateStr), let date2 = dateFormatter.date(from:dateStr2){
        dateFormatter.dateFormat = "d MMM yyyy, h:mm a"
        let fdate1 = dateFormatter.string(from: date1).capitalized
        let fdate2 = dateFormatter.string(from: date2).capitalized
        if fdate1 == fdate2{
            return  fdate1
        }
        else if lineBreak{
            return "Inicia: \(fdate1) \nTermina: \(fdate2)"
        }
        else {
            return "\(fdate1) - \(fdate2)"
        }
    }
    return ""
}
func dateFormatCustom2(_ dateStr:String)->String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
    dateFormatter.locale = Locale(identifier: "es_MX")
    if let date1 = dateFormatter.date(from:dateStr){
        dateFormatter.dateFormat = "M"
        return dateFormatter.string(from: date1)
    }
    return ""
}


