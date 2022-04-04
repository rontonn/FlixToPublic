//
//  
//  MoreEpisodesInteractor.swift
//  Flix
//
//  Created by Anton Romanov on 25.10.2021.
//
//

import Foundation

protocol MoreEpisodesBusinessLogic {
    func fetchContentInfo(_ request: MoreEpisodesModels.InitialData.Request)
    func fetchSeasons(_ request: MoreEpisodesModels.SeasonsData.Request)
    func fetchSeason(_ request: MoreEpisodesModels.SeasonData.Request)
    func fetchSeries(_ request: MoreEpisodesModels.SeriesData.Request)
    func fetchSeria(_ request: MoreEpisodesModels.SeriaData.Request)
    func didChangeFocusToSeason(_ request: MoreEpisodesModels.SeasonFocusChange.Request)
}

protocol MoreEpisodesDataStore {
    var videoOnDemandItem: VideoOnDemandItemDetails? { get set }
    var seasons: [Season] { get }
    var seriesBySeason: [UUID: [Seria]] { get }
    var currentSeasonID: UUID? { get }
}

final class MoreEpisodesInteractor: MoreEpisodesDataStore {
    // MARK: - Properties
    var presenter: MoreEpisodesPresentationLogic?
    var videoOnDemandItem: VideoOnDemandItemDetails?
    var seasons: [Season] = []
    var seriesBySeason: [UUID: [Seria]] = [:]
    var currentSeasonID: UUID?
}

extension MoreEpisodesInteractor: MoreEpisodesBusinessLogic {
    func fetchContentInfo(_ request: MoreEpisodesModels.InitialData.Request) {
        let response = MoreEpisodesModels.InitialData.Response(title: videoOnDemandItem?.title,
                                                               productionInfo: videoOnDemandItem?.productionInfo,
                                                               genres: videoOnDemandItem?.genresInfo)
        presenter?.presentContentInfo(response)
    }

    func fetchSeasons(_ request: MoreEpisodesModels.SeasonsData.Request) {
        seasons = [Season(title: "Season 1", subtitle: "Just the beginning..."),
                   Season(title: "Season 2", subtitle: "Joly Yoly."),
                   Season(title: "Season 3", subtitle: "The Christmas."),
                   Season(title: "Season 4", subtitle: "Happiness."),
                   Season(title: "Season 5", subtitle: "Guesss who?!"),
                   Season(title: "Season 6", subtitle: "Wrong way!"),
                   Season(title: "Season 7", subtitle: "Justice.")]
        currentSeasonID = seasons.first?.id

        let seasonSection = SeasonSection(seasons: seasons)
        let response = MoreEpisodesModels.SeasonsData.Response(seasonSection: seasonSection)
        presenter?.presentSeasons(response)
    }

    func fetchSeason(_ request: MoreEpisodesModels.SeasonData.Request) {
        guard let season = seasons[safe: request.indexPath.item] else {
            return
        }
        let response = MoreEpisodesModels.SeasonData.Response(object: request.object, season: season)
        presenter?.presentSeason(response)
    }

    func fetchSeries(_ request: MoreEpisodesModels.SeriesData.Request) {
        seasons.forEach {
            let tempS = [Seria(posterImage: "", seasonNumber: $0.title, seriaNumber: " Seria 1", duration: "30 min", seriaTitle: "Sun rises", description: "asdnkjsdfbngkflascjkvxncvaslfmcalksvmj asdkncak js,ncv klfdvn lksd vns,m nv,ds v", progress: 34),
                         Seria(posterImage: "", seasonNumber: $0.title, seriaNumber: " Seria 2", duration: "47 min", seriaTitle: "Sun is down.", description: "kjhkjhkjhjkh", progress: 62),
                         Seria(posterImage: "", seasonNumber: $0.title, seriaNumber: " Seria 3", duration: "50 min", seriaTitle: "Moon is shining.", description: "hjbjhb jhb hj jh  k, km  n  nmn nb n k jg kj, kjj k  kh kj jk kk", progress: 54),
                         Seria(posterImage: "", seasonNumber: $0.title, seriaNumber: " Seria 4", duration: "60 min", seriaTitle: "Ant is coming.", description: "jjhvjkbj knnkl", progress: 17),
                         Seria(posterImage: "", seasonNumber: $0.title, seriaNumber: " Seria 5", duration: "5 min", seriaTitle: "Green tree.", description: "m,jnkjhbkj  jkb h bkj lk nh v ghb lk nlk bhj bkj nlk nkl bjgvj nkl lk kjn hjv hg bkjnlk nkjh vjgh vjk kln kj bjhv jh v m,jnkjhbkj  jkb h bkj lk nh v ghb lk nlk bhj bkj nlk nkl bjgvj nkl lk kjn hjv hg bkjnlk nkjh vjgh vjk kln kj bjhv jh v m,jnkjhbkj  jkb h bkj lk nh v ghb lk nlk bhj bkj nlk nkl bjgvj nkl lk kjn hjv hg bkjnlk nkjh vjgh vjk kln kj bjhv jh v ", progress: 87),
                         Seria(posterImage: "", seasonNumber: $0.title, seriaNumber: " Seria 6 Seria 6 Seria 6  Seria 6 Seria 6 Seria 6 Seria 6  Seria 6 Seria 6 Seria 6 Seria 6  Seria 6", duration: "120 min", seriaTitle: "Lonely tunes onely tunes onely tunes onely tunes onely tunes onely tunes onely tunes onely tunes onely tunes", description: "m,jnkjhbkj  jkb h bkj lk nh v ghb lk nlk bhj bkj nlk nkl bjgvj nkl lk kjn hjv hg bkjnlk nkjh vjgh vjk kln kj bjhv jh v m,jnkjhbkj  jkb h bkj lk nh v ghb lk nlk bhj bkj nlk nkl bjgvj nkl lk kjn hjv hg bkjnlk nkjh vjgh vjk kln kj bjhv jh v m,jnkjhbkj  jkb h bkj lk nh v ghb lk nlk bhj bkj nlk nkl bjgvj nkl lk kjn hjv hg bkjnlk nkjh vjgh vjk kln kj bjhv jh v m,jnkjhbkj  jkb h bkj lk nh v ghb lk nlk bhj bkj nlk nkl bjgvj nkl lk kjn hjv hg bkjnlk nkjh vjgh vjk kln kj bjhv jh v m,jnkjhbkj  jkb h bkj lk nh v ghb lk nlk bhj bkj nlk nkl bjgvj nkl lk kjn hjv hg bkjnlk nkjh vjgh vjk kln kj bjhv jh v m,jnkjhbkj  jkb h bkj lk nh v ghb lk nlk bhj bkj nlk nkl bjgvj nkl lk kjn hjv hg bkjnlk nkjh vjgh vjk kln kj bjhv jh v m,jnkjhbkj  jkb h bkj lk nh v ghb lk nlk bhj bkj nlk nkl bjgvj nkl lk kjn hjv hg bkjnlk nkjh vjgh vjk kln kj bjhv jh v m,jnkjhbkj  jkb h bkj lk nh v ghb lk nlk bhj bkj nlk nkl bjgvj nkl lk kjn hjv hg bkjnlk nkjh vjgh vjk kln kj bjhv jh v m,jnkjhbkj  jkb h bkj lk nh v ghb lk nlk bhj bkj nlk nkl bjgvj nkl lk kjn hjv hg bkjnlk nkjh vjgh vjk kln kj bjhv jh v", progress: 94)]
            let end = Int.random(in: 0...5)
            seriesBySeason[$0.id] = Array(tempS[0...end])
        }

        let seriesSection = SeriesSection(series: currentSeries)
        let response = MoreEpisodesModels.SeriesData.Response(seriesSection: seriesSection)
        presenter?.presentSeries(response)
    }

    func fetchSeria(_ request: MoreEpisodesModels.SeriaData.Request) {
        guard let seria = currentSeries[safe: request.indexPath.item] else {
            return
        }
        let response = MoreEpisodesModels.SeriaData.Response(object: request.object, seria: seria)
        presenter?.presentSeria(response)
    }

    func didChangeFocusToSeason(_ request: MoreEpisodesModels.SeasonFocusChange.Request) {
        guard let nextFoxucedSeasonID = seasons[safe: request.indexPath.item]?.id,
              currentSeasonID != nextFoxucedSeasonID else {
                  return
        }
        currentSeasonID = nextFoxucedSeasonID
        let response = MoreEpisodesModels.SeasonFocusChange.Response(seriesIDs: currrentSeriesIDs)
        presenter?.presentSeriesInSelectedSeason(response)
    }
}

// MARK: - Private methods
private extension MoreEpisodesInteractor {
    var currentSeries: [Seria] {
        guard let currentSeasonID = currentSeasonID,
              let series = seriesBySeason[currentSeasonID] else {
                  return []
              }
        return series
    }
    var currrentSeriesIDs: [UUID] {
        return currentSeries.map{ $0.id }
    }
    var currentSeason: Season? {
        guard let currentSeasonID = currentSeasonID,
              let series = seasons.first(where: { $0.id == currentSeasonID }) else {
                  return nil
              }
        return series
    }
}
