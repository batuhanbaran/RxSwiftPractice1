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
        
        viewModel?.publishedCartItems.bind(to: tableView.rx.items(cellIdentifier: CartTableViewCell.identifier, cellType: CartTableViewCell.self)) { index, item, cell in
            cell.selectionStyle = .none
            guard let product = self.viewModel?.products[index] else {
                return
            }
            cell.configure(with: product, at: index)
            cell.delegate = self
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
        viewModel?.calculateTotalPrice()
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
        let alert = UIAlertController(title: "Warning ⚠️", message: "Are you sure you want to empty your cart?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.viewModel?.publishedCartItems.onNext([])
            self.viewModel?.products.removeAll(keepingCapacity: false)
            self.viewModel?.total.accept(0.0)
            self.viewModel?.isCartEmpty.accept(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension CartViewController: CartTableViewCellOutputDelegate {
    func didTapIncreaseButton(amount: Int, index: Int) {
        self.viewModel?.products[index].amount.accept(amount)
        self.viewModel?.calculateTotalPrice()
    }
    
    func didTapDecreaseButton(amount: Int, index: Int) {
        self.viewModel?.products[index].amount.accept(amount)
        self.viewModel?.calculateTotalPrice()
    }
}
