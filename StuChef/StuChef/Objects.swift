//
//  Objects.swift
//  StuChef
//
//  Created by Tom Fullylove on 03/04/2019.
//  Copyright © 2019 Tom Fullylove. All rights reserved.
//

import Foundation
class Dish : NSObject {
    var key : String = ""
    var title : String = ""
    var cuisine : String = ""
    override init() {
    }
}
class Order : NSObject {
    var key : String = ""
    var dishI : String = ""
    var dish : String = ""
    var title : String = ""
    var time : String = ""
    var cuisine : String = ""
    var quantity : Int = 0
    var date : String = ""
    var ready : Bool = false
    var seller : String = ""
    override init() {
    }
}
class TableCell : NSObject {
    var key : String = ""
    var dishI : String = ""
    var dish : String = ""
    var title : String = ""
    var type : String = ""
    var time : String = ""
    var date : String = ""
    var remain : Int = 0
    var taken : Int = 0
    var price : Float = 0
    var seller : String = ""
    var ready : Bool = false
    override init() {
    }
}

class Review : NSObject {
    var key : String = ""
    var rating : Float = 0
    var txt : String = ""
    var dish : String = ""
    override init() {
    }
}
class DishInstance : NSObject {
    var key : String = ""
    var dish : String = ""
    var title : String = ""
    var price : Float = 0
    var remain : Int = 0
    var taken : Int = 0
    var seller : String = ""
    var date : String = ""
    override init() {
    }
}
class Refine : NSObject {
    var refine : Bool = false
    var cuisine : String = ""
    var diet : String = ""
    var rating : Float = 0
    var price = [Float]()
    var date : String = ""
    var allergens = [String]()
    override init() {
    }
}
struct AppVariables{
    static var uid : String = ""
    static var cuisines : [String] = ["American", "British", "Catibbean", "Chinese", "French", "Greek", "Indian", "Italian", "Japanese", "Mediterranean", "Mexican", "Moroccan", "Spanish", "Thai", "Turkish", "Vietnamese", "Other"]
    static var diets : [String] = ["Gluten-free", "Pescetarian", "Vegan", "Vegetarian"]
    static var refine = Refine()
    static var allergens : [String] = ["Celery", "Crustaceans", "Dairy", "Egg", "Fish", "Gluten", "Lupin", "Molluscs", "Mustard", "Nuts", "Peanuts", "Sesame", "Soy", "Sulphur"]
    static var error : [String] = ["Please ensure all info has been entered", "Invalid email address", "Please ensure your passwords match"]
}
