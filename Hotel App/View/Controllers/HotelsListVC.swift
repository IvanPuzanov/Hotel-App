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
    
    private let sortButton = UIBarButtonItem(title: "Сортировать", menu: nil)
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureSortButton()
        configureHotelsDataSource()
        configureLayout()
        
        bind()
        handleSelection()
        showLoadingIndicator()
    }
    
    // MARK: -
    @objc
    private func bind() {
        let input   = HotelsListViewModel.Input(loadHotels: .just(()))
        let output  = hotelsListViewModel.transform(input)
        
        output
            .hotels
            .subscribe { hotels in
                self.updateData(with: hotels)
            } onError: { error in
                let alert = UIAlertController(title: Strings.networkErrorTitle, message: Strings.networkErrorMesssage, preferredStyle: .alert)
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            }
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
    
    private func sortHotels(_ sortType: SortType) {
        let items = hotelsDataSource.snapshot().itemIdentifiers
        
        let sortedItems = items.sorted { first, second in
            switch sortType {
            case .byDistance:
                return first.distance > second.distance
            case .bySuites:
                return first.availableSuites.count > second.availableSuites.count
            }
        }
        
        self.updateData(with: sortedItems)
    }
    
    // MARK: -
    private func configure() {
        self.title = Strings.hotelListControllerTitle
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.collectionView.register(HAHotelCVCell.self, forCellWithReuseIdentifier: HAHotelCVCell.cellID)
    }
    
    private func configureSortButton() {
        var menuItems: [UIAction] {
            return [
                UIAction(title: Strings.sortTitle(by: .byDistance), image: Image.mappinnImage, handler: { _ in
                    self.sortHotels(.byDistance)
                }),
                UIAction(title: Strings.sortTitle(by: .bySuites), image: Image.bedImage, handler: { _ in
                    self.sortHotels(.bySuites)
                })
            ]
        }

        var sortMenu: UIMenu {
            return UIMenu(title: "Сортировать", image: nil, children: menuItems)
        }
        
        sortButton.menu = sortMenu
        
        self.navigationItem.rightBarButtonItem = sortButton
        self.navigationItem.rightBarButtonItem?.tintColor = .systemOrange
    }
    
    private func configureLayout() {
        hotelsCollectionLayout = UICollectionViewCompositionalLayout(sectionProvider: { section, _ in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                heightDimension: .absolute(130)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                           heightDimension: .absolute(130)),
                                                         subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
        
            return section
        })
        
        self.collectionView.setCollectionViewLayout(hotelsCollectionLayout, animated: false)
    }
    
    private func configureHotelsDataSource() {
        typealias CollectionDataSource = UICollectionViewDiffableDataSource
        hotelsDataSource = CollectionDataSource(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, hotelViewModel in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HAHotelCVCell.cellID, for: indexPath) as? HAHotelCVCell
            cell?.hotelViewModel = hotelViewModel
            return cell
        })
    }
}
