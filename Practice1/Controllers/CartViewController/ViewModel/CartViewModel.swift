//
//  CartViewModel.swift
//  
//
//  Created by Batuhan BARAN on 22.08.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class CartViewModel {
    
    var publishedCartItems = PublishSubject<[Product]>()
    var products: [Product] = []
    
    func addToCart(product: Product) {
        products.append(product)
        publishedCartItems.onNext(products)
        
    }
    
    func fetchCartItems() {
        publishedCartItems.onNext(products)
    }
    
}
