//
//  File.swift
//  LesaraExercise
//
//  Created by Matthew Lewis on 7/4/17.
//  Copyright © 2017 Matthew Lewis. All rights reserved.
//

import Foundation
import UIKit

struct Product {
    
    let id              : String
    let name            : String
    let price           : NSDecimalNumber
    let discount        : Int
    let thumbnailPath   : String
   
    func getPriceDisplay() -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits =  2
        numberFormatter.maximumFractionDigits =  2
        return numberFormatter.string(from: self.price)!
        
    }
    
    init?(json: [String: AnyObject]) {
       
        guard let id = json["id"] as? String,
            let name = json["name"] as? String,
            let price = json["price"] as? String,
            let discount = json["discount"] as? Int,
            let thumbnail = json["thumbnail_path"] as? String
        
            else{
                return nil
        }
        
        self.id = id
        self.name = name
        self.price = NSDecimalNumber(string: price)
        self.discount = discount
        self.thumbnailPath = thumbnail
    }
}

struct ProductList {
    
    var products        : [Product] = []
    
    init(productsArray : Array<[String: AnyObject]>) {
        
        for productData in productsArray {
            let product = Product(json: productData)
            if(product != nil){
                self.products.append(product!)

            }
        }
    }
}


struct TrendingProductResponse {
    
    let currentPage     : String
    let numberProducts  : Int
    let productList     : ProductList
    
    init?(json: [String: AnyObject]) {
        
        guard let currentPage = json["current_page"] as? String,
        let numberProducts = json["number_products"] as? Int,
        let productList = json["products"]
        else{
           
            return nil
        }
        
        self.currentPage = currentPage
        self.numberProducts = numberProducts
        self.productList = ProductList(productsArray:productList as! Array)
 
    }
}

