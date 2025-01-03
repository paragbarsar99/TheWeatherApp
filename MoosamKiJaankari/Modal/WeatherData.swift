//
//  WeatherData.swift
//  MoosamKiJaankari
//
//  Created by parag on 02/01/25.
//

import Foundation

struct ErrorModal:Decodable,Error{
   let cod:String
   let message:String
}


enum WEATHERCONDITION:Int,Decodable{
    case thunderstorm = 200
       case thunderstormWithRain = 201
       case thunderstormWithHeavyRain = 202
       case drizzle = 300
       case lightDrizzle = 301
       case heavyDrizzle = 302
       case rain = 500
       case lightRain = 501
       case moderateRain = 502
       case heavyRain = 503
       case veryHeavyRain = 504
       case snow = 600
       case lightSnow = 601
       case heavySnow = 602
       case atmosphere = 700
       case mist = 701
       case smoke = 711
       case haze = 721
       case dust = 731
       case fog = 741
       case sand = 751
       case dustStorm = 761
       case clearSky = 800
       case fewClouds = 801
       case scatteredClouds = 802
       case brokenClouds = 803
       case overcastClouds = 804
        case unknown
     
    init(rawValue: Int) {
        switch rawValue {
        case 200...299:
            self = .thunderstorm
        case 300...399:
            self = .drizzle
        case 500...599:
            self = .rain
        case 600...699:
            self = .snow
        case 700...799:
            self = .atmosphere
        case 800:
            self = .clearSky
        case 801...899:
            self = .brokenClouds
        default:
            self = .unknown
        }
        
    }
}

//typealias WEATHERCONDITION =


//protocol weatherReport{
//    var condition:String {get}
//    var tempretaure:String {get}
//}

struct coords:Decodable {
        let lon:Double
        let lat:Double
}

struct tempDetails:Decodable {
    var temp: Float
    var  feels_like: Float
    var  temp_min: Float
    var temp_max: Float
    var pressure: Float
    var humidity: Float
    var  sea_level: Float
    var  grnd_level: Float
}

struct weather:Decodable {
    let main:String
    let description:String
    let id:WEATHERCONDITION
    let icon:String
}

struct weatherResponse:Decodable{
    let coord:coords
    let main:tempDetails
    let name:String
    let weather:[weather]
}

