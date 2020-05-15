//
//  ListGitViewController.swift
//  testeModal
//
//  Created by Fernanda de Lima on 14/05/20.
//  Copyright © 2020 felima. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class ListGitViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    let cellid = "repositoryCell"
    let viewModel = ListGitViewModel()
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        viewModel.getRepository()
    }
    
    func bindViewModel() {
        viewModel.repositoryCells.bind(to: self.listTableView.rx.items) { (tableView, index, element) -> UITableViewCell in
            let indexPath = IndexPath(item: index, section: 0)
            switch element {
            case .normal(let repository):
                let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryCell", for: indexPath) as! RepositoryCell
                cell.repository = repository
                return cell
            case .error(let message):
                let cell = UITableViewCell()
                cell.isUserInteractionEnabled = false
                cell.textLabel?.text = message
                return cell
            case .empty:
                let cell = UITableViewCell()
                cell.isUserInteractionEnabled = false
                cell.textLabel?.text = "No data available"
                return cell
            }
        }.disposed(by: disposeBag)
        
        viewModel
            .onShowError
            .map { [weak self] in self?.presentSingleButtonDialog(alert: $0)}
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel
            .onShowLoadingHud
            .map { [weak self] in self?.setLoadingHud(visible: $0) }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    @objc private func refreshRepository(_ sender: Any) {
        API.page = 1
        self.viewModel.getRepository()
    }
    
    private func setLoadingHud(visible: Bool) {
        DispatchQueue.main.async() {
            visible ? self.view.startLoading() : self.view.stopLoading()
        }
    }
    
    private func setupTableView(){
        listTableView.register(UINib(nibName: "RepositoryCell", bundle: nil), forCellReuseIdentifier: cellid)
        listTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshRepository(_:)), for: .valueChanged)
        
        listTableView
            .rx
            .willDisplayCell
            .subscribe(
                onNext: { [weak self] _, index in
                    if index.row ==  self!.viewModel.countCell() - 1{
                        self!.viewModel.getRepository()
                    }
                }
            )
            .disposed(by: disposeBag)
    }

}

extension ListGitViewController: SingleButtonDialogPresenter { }

//extension ListGitViewController: UITableViewDelegate{
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row ==  self.viewModel.countCell() - 1{
//            self.viewModel.getRepository()
//        }
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//}
