//
//  
//  MoreEpisodesViewController.swift
//  Flix
//
//  Created by Anton Romanov on 25.10.2021.
//
//

import UIKit

protocol MoreEpisodesDisplayLogic: AnyObject {
    func showContentInfo(_ viewModel: MoreEpisodesModels.InitialData.ViewModel)
    func showSeasons(_ viewModel: MoreEpisodesModels.SeasonsData.ViewModel)
    func showSeason(_ viewModel: MoreEpisodesModels.SeasonData.ViewModel)
    func showSeries(_ viewModel: MoreEpisodesModels.SeriesData.ViewModel)
    func showSeria(_ viewModel: MoreEpisodesModels.SeriaData.ViewModel)
    func showSeriesInSelectedSeason(_ viewModel: MoreEpisodesModels.SeasonFocusChange.ViewModel)
}

final class MoreEpisodesViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var productionInfoLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var genresLabel: UILabel!

    // MARK: - Properties
    var interactor: MoreEpisodesBusinessLogic?
    var router: MoreEpisodesRouterable?

    private var seasonsDataSource: UICollectionViewDiffableDataSource<UUID, UUID>?
    private var seasonsCollectionView: UICollectionView?
    private var seriesDataSource: UICollectionViewDiffableDataSource<UUID, UUID>?
    private var seriesCollectionView: UICollectionView?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let contentRequest = MoreEpisodesModels.InitialData.Request()
        interactor?.fetchContentInfo(contentRequest)

        let seasonsRequest = MoreEpisodesModels.SeasonsData.Request()
        interactor?.fetchSeasons(seasonsRequest)

        let seriesRequest = MoreEpisodesModels.SeriesData.Request()
        interactor?.fetchSeries(seriesRequest)
    }
}

// MARK: - Private methods
private extension MoreEpisodesViewController {
    // -> Seasons
    func configureSeasonsHierarchy(_ viewModel: MoreEpisodesModels.SeasonsData.ViewModel) {
        seasonsCollectionView = UICollectionView(frame: CGRect(x: 138,
                                                               y: 335,
                                                               width: view.bounds.width - 138,
                                                               height: 84),
                                                 collectionViewLayout: viewModel.layout)
        configureSeasonSections()
    }

    func configureSeasonSections() {
        guard let seasonsCollectionView = seasonsCollectionView else {
            return
        }
        seasonsCollectionView.delegate = self
        seasonsCollectionView.remembersLastFocusedIndexPath = true
        seasonsCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        seasonsCollectionView.backgroundColor = .clear
        seasonsCollectionView.clipsToBounds = false
        view.addSubview(seasonsCollectionView)
    }

    func configureSeasonsDataSource(_ viewModel: MoreEpisodesModels.SeasonsData.ViewModel) {
        guard let seasonsCollectionView = seasonsCollectionView else {
            print("\(String(describing: MoreEpisodesViewController.self)): Failed to get collection view.")
            return
        }
        let cellRegistration = UICollectionView.CellRegistration<SeasonCell, UUID>.init(cellNib: SeasonCell.cellNibName) { [weak self] cell, indexPath, id in
            let request = MoreEpisodesModels.SeasonData.Request(object: cell, indexPath: indexPath)
            self?.interactor?.fetchSeason(request)
        }
        seasonsDataSource = UICollectionViewDiffableDataSource(collectionView: seasonsCollectionView, cellProvider: { collectionView, indexPath, id in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: id)
        })
        seasonsDataSource?.apply(viewModel.dataSourceSnapshot, animatingDifferences: false)
    }
    // <- Seasons
    // -> Series
    func configureSeriesHierarchy(_ viewModel: MoreEpisodesModels.SeriesData.ViewModel) {
        seriesCollectionView = UICollectionView(frame: CGRect(x: 138,
                                                              y: 497,
                                                              width: view.bounds.width - 138,
                                                              height: 84),
                                                collectionViewLayout: viewModel.layout)
        configureSeriesSections()
    }

    func configureSeriesSections() {
        guard let seriesCollectionView = seriesCollectionView else {
            return
        }
        seriesCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        seriesCollectionView.backgroundColor = .clear
        seriesCollectionView.clipsToBounds = false
        view.addSubview(seriesCollectionView)
    }

    func configureSeriesDataSource(_ viewModel: MoreEpisodesModels.SeriesData.ViewModel) {
        guard let seriesCollectionView = seriesCollectionView else {
            print("\(String(describing: MoreEpisodesViewController.self)): Failed to get collection view.")
            return
        }
        let cellRegistration = UICollectionView.CellRegistration<SeriaCell, UUID>.init(cellNib: SeriaCell.cellNibName) { [weak self] cell, indexPath, id in
            let request = MoreEpisodesModels.SeriaData.Request(object: cell, indexPath: indexPath)
            self?.interactor?.fetchSeria(request)
        }
        seriesDataSource = UICollectionViewDiffableDataSource(collectionView: seriesCollectionView, cellProvider: { collectionView, indexPath, id in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: id)
        })
        seriesDataSource?.apply(viewModel.dataSourceSnapshot, animatingDifferences: false)
    }
    // <- Series
}

// MARK: - Conforming to MoreEpisodesDisplayLogic
extension MoreEpisodesViewController: MoreEpisodesDisplayLogic {
    func showContentInfo(_ viewModel: MoreEpisodesModels.InitialData.ViewModel) {
        titleLabel.text = viewModel.title
        productionInfoLabel.attributedText = viewModel.productionInfo
        genresLabel.text = viewModel.genres
    }

    func showSeasons(_ viewModel: MoreEpisodesModels.SeasonsData.ViewModel) {
        configureSeasonsHierarchy(viewModel)
        configureSeasonsDataSource(viewModel)
    }

    func showSeries(_ viewModel: MoreEpisodesModels.SeriesData.ViewModel) {
        configureSeriesHierarchy(viewModel)
        configureSeriesDataSource(viewModel)
    }

    func showSeason(_ viewModel: MoreEpisodesModels.SeasonData.ViewModel) {
        guard let cell = viewModel.object as? SeasonCell else {
            return
        }
        cell.setup(viewModel.season)
    }

    func showSeria(_ viewModel: MoreEpisodesModels.SeriaData.ViewModel) {
        guard let cell = viewModel.object as? SeriaCell else {
            return
        }
        cell.setup(viewModel.seria)
    }

    func showSeriesInSelectedSeason(_ viewModel: MoreEpisodesModels.SeasonFocusChange.ViewModel) {
        guard var currentSnapshot = seriesDataSource?.snapshot() else {
            return
        }
        currentSnapshot.sectionIdentifiers.forEach {
            let oldUUIDs = currentSnapshot.itemIdentifiers(inSection: $0)
            currentSnapshot.deleteItems(oldUUIDs)
            currentSnapshot.appendItems(viewModel.seriesIDs, toSection: $0)
        }
        seriesDataSource?.apply(currentSnapshot, animatingDifferences: true) {
            self.seriesCollectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
        }
    }
}

extension MoreEpisodesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if collectionView == seasonsCollectionView,
           let nextIndexPath = context.nextFocusedIndexPath {
            let request = MoreEpisodesModels.SeasonFocusChange.Request(indexPath: nextIndexPath)
            interactor?.didChangeFocusToSeason(request)
        }
    }
}
