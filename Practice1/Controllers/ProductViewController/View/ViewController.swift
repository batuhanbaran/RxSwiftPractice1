//
//  ViewController.swift
//  Practice1
//
//  Created by Batuhan BARAN on 19.08.2021.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private var viewModel: ProductListViewModel? = ProductListViewModel()
    private var cartViewModel: CartViewModel? = CartViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navController = self.tabBarController?.viewControllers![1] as? UINavigationController {
            let vc = navController.topViewController as! CartViewController
            vc.viewModel = self.cartViewModel
        }
        
        configureNavBar()
        setupBindings()
    }
    
    private func setupBindings() {
        self.tableView.rowHeight = 154
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        viewModel?.publishedProducts.bind(to: tableView.rx.items(cellIdentifier: CustomTableViewCell.identifier, cellType: CustomTableViewCell.self)) { row, item, cell in
            cell.selectionStyle = .none
            cell.productName.text = item.name
            cell.productIcon.image = item.image
            cell.productPrice.text = "$" + String(item.price).replacingOccurrences(of: ".", with: ",")
            
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Product.self).bind { selectedItem in
            guard let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "detailVC") as? ProductDetailViewController
            else { return }
            detailVC.selectedProduct = selectedItem
            detailVC.viewModel = self.viewModel
            detailVC.cartViewModel = self.cartViewModel
            self.present(detailVC, animated: true)
        }.disposed(by: disposeBag)
        
        viewModel?.fetchProducts()
    }
    
    private func configureNavBar() {
        self.navigationController?.navigationBar.topItem?.title = "Products"
    }
    
    @IBAction func cartButtonAction(_ sender: Any) {
        guard let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "detailVC") as? ProductDetailViewController
        else { return }
        self.present(detailVC, animated: true)
    }

}
