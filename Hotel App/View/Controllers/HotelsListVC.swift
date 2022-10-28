//
//  HotelsListVC.swift
//  Hotel App
//
//  Created by Ivan Puzanov on 28.10.2022.
//

import UIKit
import RxSwift
import RxCocoa

enum HotelSection {
    case main
}

final class HotelsListVC: UICollectionViewController {

    // MARK: -
    public var coordinator: AppCoordinator?
    private let disposeBag = DisposeBag()
    
    private var hotelsListViewModel = HotelsListViewModel()
    private var hotelsDataSource: UICollectionViewDiffableDataSource<HotelSection, HotelViewModel>!
    private var hotelsCollectionLayout: UICollectionViewCompositionalLayout!
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureHotelsDataSource()
        configureLayout()
        
        bind()
        handleSelection()
        showLoadingIndicator()
    }
    
    // MARK: -
    private func bind() {
        let input   = HotelsListViewModel.Input(loadHotels: .just(()))
        let output  = hotelsListViewModel.transform(input)
        
        output
            .hotels
            .subscribe { hotels in
                self.updateData(with: hotels)
            } onError: { _ in }
            .disposed(by: self.disposeBag)
    }
    
    private func handleSelection() {
        self.collectionView.rx.itemSelected.subscribe { indexPath in
            let hotelViewModel = self.hotelsDataSource.itemIdentifier(for: indexPath)
            self.coordinator?.showDetailedHotelVC(for: hotelViewModel)
        }.disposed(by: self.disposeBag)
    }
    
    private func updateData(with items: [HotelViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<HotelSection, HotelViewModel>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        
        DispatchQueue.main.async {
            self.hotelsDataSource.apply(snapshot, animatingDifferences: true)
            self.dismissLoadingIndicator()
        }
    }
    
    // MARK: -
    private func configure() {
        self.title = "Hotels"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.collectionView.register(HotelCVCell.self, forCellWithReuseIdentifier: HotelCVCell.cellID)
    }
    
    private func configureLayout() {
        hotelsCollectionLayout = UICollectionViewCompositionalLayout(sectionProvider: { section, _ in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                heightDimension: .absolute(130)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 15, trailing: 16)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                           heightDimension: .absolute(130)),
                                                         subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0)
            
            return section
        })
        
        self.collectionView.setCollectionViewLayout(hotelsCollectionLayout, animated: false)
    }
    
    private func configureHotelsDataSource() {
        hotelsDataSource = UICollectionViewDiffableDataSource(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, hotelViewModel in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelCVCell.cellID, for: indexPath) as? HotelCVCell
            cell?.hotelViewModel = hotelViewModel
            return cell
        })
    }
}
