//
//  ListGitViewModel.swift
//  testeModal
//
//  Created by Fernanda de Lima on 14/05/20.
//  Copyright © 2020 felima. All rights reserved.
//

import RxCocoa
import RxSwift

enum RepositoryCellType{
    case normal(cellModel: Item)
    case error(message: String)
    case empty
}

class ListGitViewModel{
    var repositoryCells: Observable<[RepositoryCellType]> {
        return cells.asObservable()
    }
    var onShowLoadingHud: Observable<Bool> {
        return loadInProgress
            .asObservable()
            .distinctUntilChanged()
    }
    
    let onShowError = PublishSubject<SingleButtonAlert>()
    let disposeBag = DisposeBag()
    
    private let loadInProgress = BehaviorRelay(value: false)
    private let cells = BehaviorRelay<[RepositoryCellType]>(value: [])
    
    func getRepository() {
        loadInProgress.accept(true)
        
        API.get(Repository.self, endpoint: .repository("swift", "stars", API.page))
            .subscribe(
                onNext: { [weak self] repository in
                    API.page += 1
                    self?.loadInProgress.accept(false)
                    guard repository.items.count > 0 else {
                        self?.cells.accept([.empty])
                        return
                    }

                    self?.cells.accept(repository.items.compactMap { .normal(cellModel: $0 ) })
                },
                onError: { [weak self] error in
                    self?.loadInProgress.accept(false)
                    self?.cells.accept([
                        .error(
                            message: error.localizedDescription
                        )
                    ])
                }
            )
            .disposed(by: disposeBag)
    }
    
    func countCell() -> Int{
        return cells.value.count
    }
}
