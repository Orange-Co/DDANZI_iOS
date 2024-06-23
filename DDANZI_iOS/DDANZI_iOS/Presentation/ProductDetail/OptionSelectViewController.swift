//  OptionSelectViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/19/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

typealias StrOption = StringLiterals.ProductDetail.Option

private enum Section: Hashable {
    case main
}

private struct Item: Hashable {
    let category: Category
    let image: UIImage?
    let title: String?
    let description: String?
    init(category: Category, imageName: String? = nil, title: String? = nil, description: String? = nil) {
        self.category = category
        if let systemName = imageName {
            self.image = UIImage(systemName: systemName)
        } else {
            self.image = nil
        }
        self.title = title
        self.description = description
    }
    private let identifier = UUID()
}

final class OptionSelectViewController: UIViewController {
    // MARK: Properties
    private let disposeBag = DisposeBag()
    private let optionViewModel = OptionSelectViewModel()
    
    let optionItems = [
        OptionItem(title: "색상", subItems: [], item: Option(title: "색상1", isSelected: false)),
        OptionItem(title: "사이즈", subItems: [], item: Option(title: "1", isSelected: false))
    ]
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, OptionItem>! = nil
    
    // MARK: Compenets
    private let titleLabel = UILabel().then {
        $0.text = StrOption.optionTitle
        $0.textColor = .black
        $0.font = .title4Sb24
    }
    
    private let moreButton = UIButton().then {
        $0.setTitle(StrOption.moreButtonText, for: .normal)
        $0.titleLabel?.font = .buttonText
        $0.setTitleColor(.gray3, for: .normal)
    }
    
    private let optionCaptionLabel = UILabel().then {
        $0.text = StrOption.optionCaptionText
        $0.font = .body6M12
        $0.textColor = .gray2
    }
    
    private lazy var optionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = .clear
    }
    
    private let bottomButton = BottomButtonView(buttonText: "구매하기")
    
    let titleCell = UICollectionView.CellRegistration<UICollectionViewListCell, OptionItem> { cell, indexPath, itemIdentifier in
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = itemIdentifier.title
        contentConfiguration.textProperties.font = .body5R14
        cell.contentConfiguration = contentConfiguration
        
        let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .header, tintColor: .gray3)
        
        cell.accessories = [.outlineDisclosure(options: disclosureOptions)]
        
        
    }
    // 자식 셀로 사용할 것
    let optionCell = UICollectionView.CellRegistration<OptionCollectionViewCell, Option> { cell, indexPath, itemIdentifier in
        cell.titleLabel.text = itemIdentifier.title
    }
    
    let optionList: [[Option]] = []
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        configureDataSource()
    }
    
    // MARK: LayoutHelper
    private func setUI() {
        self.view.backgroundColor = .white
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        view.addSubviews(titleLabel,
                         moreButton,
                         optionCaptionLabel,
                         optionCollectionView,
                         bottomButton)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
        }
        
        moreButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
        }
        
        optionCollectionView.snp.makeConstraints {
            $0.top.equalTo(moreButton.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomButton.snp.top).offset(8)
        }
        
        bottomButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<OptionCollectionViewCell, OptionItem> { [weak self] (cell, indexPath, item) in
            guard let self = self else { return }
            
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            cell.contentConfiguration = content
            cell.accessories = []
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, OptionItem>(collectionView: optionCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            if itemIdentifier.subItems.count == 0 {
                if let option = itemIdentifier.item as? Option {
                    return collectionView.dequeueConfiguredReusableCell(using: self.optionCell, for: indexPath, item: option)
                } else{
                    return UICollectionViewCell()
                }
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: self.titleCell, for: indexPath, item: itemIdentifier)
            }
        })
    }
    
    private func updateSnapShot(section: Section, item: [OptionItem]) {
        let snapShot = initialSnapshot(items: item)
        self.dataSource.apply(snapShot, to: section, animatingDifferences: true)
    }
    
    func initialSnapshot(items: [OptionItem]) -> NSDiffableDataSourceSectionSnapshot<OptionItem> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<OptionItem>()
        
        snapshot.append(items, to: nil)
        for item in items where !item.subItems.isEmpty{
            snapshot.append(item.subItems, to: item)
            if item.subItems.count > 1{
                snapshot.expand(items)
            }
        }
        return snapshot
    }
    
    private func sectionSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, OptionItem>()
        snapshot.appendSections([.main])
        self.dataSource.apply(snapshot)
    }
    
}

extension OptionSelectViewController {
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { section, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.headerMode = .firstItemInSection
            return NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
        }
    }
}
