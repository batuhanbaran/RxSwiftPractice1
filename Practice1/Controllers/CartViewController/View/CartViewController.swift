//
//  CartViewController.swift
//  Practice1
//
//  Created by Batuhan BARAN on 22.08.2021.
//

import UIKit
import RxSwift
import RxCocoa

class CartViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var totalLabel: UILabel!
    let disposeBag = DisposeBag()
    var viewModel: CartViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        setupBindings()
    }
    
    private func setupBindings() {
        self.tableView.rowHeight = 154
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        viewModel?.publishedCartItems.bind(to: tableView.rx.items(cellIdentifier: CartTableViewCell.identifier, cellType: CartTableViewCell.self)) { row, item, cell in
            cell.selectionStyle = .none
            cell.productName.text = item.name
            cell.productIcon.image = item.image
            cell.productAmount.text = String(item.amount.value)
            cell.productPrice.text = "$" + String(format: "%.2f", item.price)
            
        }.disposed(by: disposeBag)
        
        viewModel?.total
            .asObservable()
            .map { total -> String in
                return (total != 0.0) ? "Total Price " + String(format: "%.2f", total) : ""
            }
            .bind(to:self.totalLabel.rx.text)
            .disposed(by:self.disposeBag)
        
        tableView.rx.itemDeleted
            .subscribe { [unowned self] indexPath in
                self.viewModel?.removeItem(at: indexPath.row)
            }
            .disposed(by: disposeBag)
        
        viewModel?.fetchCartItems()
    }
    
    private func configureNavBar() {
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteItems))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationController?.navigationBar.topItem?.title = "Cart"
        viewModel?.isCartEmpty
            .bind(to: rightBarButtonItem.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func deleteItems() {
        let alert = UIAlertController(title: "Uyarı", message: "Sepetinizi boşaltmak istediğinize emin misiniz?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Evet", style: .default, handler: { action in
            self.viewModel?.publishedCartItems.onNext([])
            self.viewModel?.total.accept(0.0)
            self.viewModel?.isCartEmpty.accept(false)
        }))
        alert.addAction(UIAlertAction(title: "Hayır", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
