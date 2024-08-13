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

final class OptionSelectViewController: UIViewController {
  // MARK: Properties
  private let disposeBag = DisposeBag()
  var option: [OptionModel] = []
  private var selectedOptions: [Int?] = []
  
  weak var delegate: OptionViewControllerDelegate?
  
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
  
  private let optionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .clear
    $0.register(
      OptionCollectionViewCell.self,
      forCellWithReuseIdentifier: OptionCollectionViewCell.className
    )
    $0.register(
      OptionSectionHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: OptionSectionHeaderView.className
    )
  }
  
  private let bottomButton = BottomButtonView(buttonText: "구매하기")
  
  // MARK: LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
    configureCollectionView()
    selectedOptions = Array(repeating: nil, count: option.count)
    setUI()
  }
  
  // MARK: LayoutHelper
  private func setUI() {
    self.view.backgroundColor = .white
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    view.addSubviews(
      titleLabel,
      moreButton,
      optionCaptionLabel,
      optionCollectionView,
      bottomButton
    )
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
  
  private func bind() {
    bottomButton.button.rx.tap
      .bind {
        self.dismiss(animated: true) {
          self.delegate?.optionViewControllerDidFinish(self)
        }
      }
      .disposed(by: disposeBag)
  }
  
  private func configureCollectionView() {
    optionCollectionView.collectionViewLayout = createLayout()
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<OptionSectionModel>(
      configureCell: { dataSource, collectionView, indexPath, item in
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: OptionCollectionViewCell.className,
          for: indexPath) as! OptionCollectionViewCell
        cell.configureCell(text: item.content, isEnable: item.isAvailable)
        return cell
      },
      configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        let header = collectionView.dequeueReusableSupplementaryView(
          ofKind: UICollectionView.elementKindSectionHeader,
          withReuseIdentifier: OptionSectionHeaderView.className,
          for: indexPath) as! OptionSectionHeaderView
        let section = dataSource.sectionModels[indexPath.section]
        header.configure(with: section.header)
        return header
      }
    )
    
    let sectionModels = option.map { optionModel -> OptionSectionModel in
      return OptionSectionModel(header: optionModel.type, items: optionModel.optionDetailList)
    }
    
    Observable.just(sectionModels)
      .bind(to: optionCollectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    optionCollectionView.rx.itemSelected
      .bind(with: self) { owner, indexPath in
        if let cell = owner.optionCollectionView.cellForItem(at: indexPath) as? OptionCollectionViewCell {
          cell.isSelectedRelay.accept(true)
          owner.selectedOptions[indexPath.section] = self.option[indexPath.section].optionDetailList[indexPath.row].optionDetailID
          owner.updateButtonState()
        }
      }
      .disposed(by: disposeBag)
    
    optionCollectionView.rx.itemDeselected
      .bind(with: self) { owner, indexPath in
        if let cell = owner.optionCollectionView.cellForItem(at: indexPath) as? OptionCollectionViewCell {
          cell.isSelectedRelay.accept(false)
          owner.selectedOptions[indexPath.section] = nil
          owner.updateButtonState()
        }
      }
      .disposed(by: disposeBag)
  }
  
  private func updateButtonState() {
    let allSectionsSelected = selectedOptions.allSatisfy { $0 != nil }
    bottomButton.button.isEnabled = allSectionsSelected
    bottomButton.button.backgroundColor = allSectionsSelected ? .black : .gray2
    
  }
}

extension OptionSelectViewController {
  private func createLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
      let section = NSCollectionLayoutSection(group: self.createGroup())
      section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
      
      let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(47))
      let header = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: headerSize,
        elementKind: UICollectionView.elementKindSectionHeader,
        alignment: .top)
      
      section.boundarySupplementaryItems = [header]
      return section
    }
    return layout
  }
  
  private func createGroup() -> NSCollectionLayoutGroup {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    return group
  }
}
