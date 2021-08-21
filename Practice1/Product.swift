//
//  Product.swift
//  Practice1
//
//  Created by Batuhan BARAN on 20.08.2021.
//

import Foundation
import UIKit
import RxCocoa

class Product {
    var image: UIImage
    var name: String
    var amount: BehaviorRelay<Int>
    var price: Double
    
    init(image: UIImage, name:String, amount: BehaviorRelay<Int>, price: Double) {
        self.image = image
        self.name = name
        self.amount = amount
        self.price = price
    }
}
