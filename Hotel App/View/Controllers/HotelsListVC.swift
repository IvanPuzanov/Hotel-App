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
    
    private let sortButton = UIBarButtonItem(title: Project.Strings.sortTitle, menu: nil)
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureSortButton()
        configureHotelsDataSource()
        configureLayout()
        
        bind()
        handleSelection()
        view.showLoadingIndicator()
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
            } onError: { _ in
                self.coordinator?.presentErrorAlert(title: Project.Strings.networkErrorTitle, message: Project.Strings.networkErrorMesssage)
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
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.9, options: [.allowUserInteraction, .curveEaseOut]) {
                self.hotelsDataSource.apply(snapshot, animatingDifferences: true)
            }
            self.view.dismissLoadingIndicator()
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
        self.title = Project.Strings.hotelListControllerTitle
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.collectionView.register(HAHotelCVCell.self, forCellWithReuseIdentifier: HAHotelCVCell.cellID)
    }
    
    private func configureSortButton() {
        var menuItems: [UIAction] {
            return [
                UIAction(title: Project.Strings.sortTitle(by: .byDistance), image: Project.Image.mappinnImage, handler: { _ in
                    self.sortHotels(.byDistance)
                }),
                UIAction(title: Project.Strings.sortTitle(by: .bySuites), image: Project.Image.bedImage, handler: { _ in
                    self.sortHotels(.bySuites)
                })
            ]
        }

        var sortMenu: UIMenu {
            return UIMenu(title: Project.Strings.sortTitle, image: nil, children: menuItems)
        }
        
        sortButton.menu = sortMenu
        
        self.navigationItem.rightBarButtonItem = sortButton
        self.navigationItem.rightBarButtonItem?.tintColor = .secondaryLabel
    }
    
    private func configureLayout() {
        hotelsCollectionLayout = UICollectionViewCompositionalLayout(sectionProvider: { section, _ in
            let itemSize    = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(10))
            let item        = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize   = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(10))
            let group       = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                               subitems: [item])
            group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .none, top: .fixed(4),
                                                              trailing: .none, bottom: .fixed(4))
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
            return section
        })
        
        self.collectionView.setCollectionViewLayout(hotelsCollectionLayout, animated: true)
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
