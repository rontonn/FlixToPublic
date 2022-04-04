//
//  
//  ContentPlayerInteractor.swift
//  Flix
//
//  Created by Anton Romanov on 12.11.2021.
//
//

import AVFoundation

protocol ContentPlayerBusinessLogic {
    func fetchURLToPlay(_ request: ContentPlayerModels.InitialData.Request) async
    func shouldLoadOrRenewRequestedResource(_ request: ContentPlayerModels.AssetLoaderData.Request)
    func didHappenAccessLogEvent(_ request: ContentPlayerModels.LogEvent.Request)
    func didHappenErrorLogEvent(_ request: ContentPlayerModels.LogEvent.Request)
}

protocol ContentPlayerDataStore {
    var playerError: PriviError? { get }
}

final class ContentPlayerInteractor: ContentPlayerDataStore {
    // MARK: - Properties
    var presenter: ContentPlayerPresentationLogic?
    var playerError: PriviError?
    var masterPlaylistWorker: MasterPlaylistWorkerLogic?

    private let fakeURLPart = "fakefake://"
    private let correctURLPart = "https://"
    private var masterPlaylist: String?
    private var urlToPlay: URLToPlay

    // MARK: - Lifecycle
    init() {
        urlToPlay = .ecies1
        if let url = urlToPlay.url {
            masterPlaylistWorker = MasterPlaylistWorker(url: url.absoluteString)
        }
    }
}

// MARK: - ContentPlayerBusinessLogic
extension ContentPlayerInteractor: ContentPlayerBusinessLogic {
    func fetchURLToPlay(_ request: ContentPlayerModels.InitialData.Request) async {
        guard let url = urlToPlay.url,
              let fakeURL = getFakeURL(from: url) else {
            return
        }
        await setupMasterPlaylist(url)
        await presentContent(fakeURL)
    }

    func shouldLoadOrRenewRequestedResource(_ request: ContentPlayerModels.AssetLoaderData.Request) {
        do {
            try modifyResourceLoadingRequestIfNeeded(request.resourceLoadingRequest)
        } catch {
            self.playerError = PriviError(title: "Error occured.", msg: error.localizedDescription, actions: [PriviErrorAction(option: .close)])
            request.resourceLoadingRequest.finishLoading(with: error)
        }

        let response = ContentPlayerModels.AssetLoaderData.Response()
        presenter?.shouldLoadOrRenewRequestedResource(response)
    }

    func didHappenAccessLogEvent(_ request: ContentPlayerModels.LogEvent.Request) {
        let playerItem = request.playerItem
        guard let accessEvent = playerItem.accessLog()?.events.last else {
                return
        }
        let bufferData = BasePlaybackBuffer(isPlaybackLikelyToKeepUp: playerItem.isPlaybackLikelyToKeepUp,
                                            isPlaybackBufferEmpty: playerItem.isPlaybackBufferEmpty,
                                            isPlaybackBufferFull: playerItem.isPlaybackBufferFull)
        let model = PlaybackAccessEvent(accessEvent: accessEvent,
                                        basePlaybackBuffer: bufferData)
        print("***** Access Log Event")
        model.toDictionary().forEach {
            print("\($0.key): \($0.value)")
        }
        print("*****")

        let response = ContentPlayerModels.LogEvent.Response()
        presenter?.didHappenAccessLogEvent(response)
    }

    func didHappenErrorLogEvent(_ request: ContentPlayerModels.LogEvent.Request) {
        guard let errorEvent = request.playerItem.errorLog()?.events.last else {
                return
        }
        let model = PlaybackErrorEvent(errorEvent: errorEvent)
        print("\n***** Error Log Event")
        model.toDictionary().forEach {
            print("\($0.key): \($0.value)")
        }
        print("*****")

        let response = ContentPlayerModels.LogEvent.Response()
        presenter?.didHappenErrorLogEvent(response)
    }
}

// MARK: - Private methods
private extension ContentPlayerInteractor {
    func setupMasterPlaylist(_ url: URL) async {
        masterPlaylist = try? await getMasterPlaylist(url)
        masterPlaylistWorker = nil
    }

    func getMasterPlaylist(_ url: URL) async throws -> String {
        guard let masterPlaylistWorker = masterPlaylistWorker else {
            throw PriviError(title: "ContentPlayerInteractor.getMasterPlaylist", msg: "Failed to get masterPlaylistWorker.")
        }
        let taskID = "ContentPlayerInteractor.getMasterPlaylist.\(url.absoluteString)"
        let rawMasterPlaylist = try await masterPlaylistWorker.getMasterPlaylist(taskID)
        let updatedMasterPlaylist = masterPlaylistWorker.getMasterPlaylistWithFakeKeyURLs(rawMasterPlaylist, correctURLPart, fakeURLPart)
        return updatedMasterPlaylist
    }

    @MainActor
    func presentContent(_ url: URL) {
        let response = ContentPlayerModels.InitialData.Response(url: url)
        presenter?.presentContent(response)
    }

    func getFakeURL(from url: URL) -> URL? {
        var oldURL = url.absoluteString
        oldURL = oldURL.replacingOccurrences(of: correctURLPart, with: fakeURLPart)
        return URL(string: oldURL)
    }

    func modifyResourceLoadingRequestIfNeeded(_  resourceLoadingRequest: AVAssetResourceLoadingRequest) throws {
        guard let url = resourceLoadingRequest.request.url else {
            throw PriviError(title: "ContentPlayerInteractor.modifyResourceLoadingRequestIfNeeded", msg: "Failed to get resourceLoadingRequest url.")
        }
        let contentRequest = resourceLoadingRequest.contentInformationRequest

        if (contentRequest != nil) {
            contentRequest?.isByteRangeAccessSupported = true
        }

        let correctURLString = url.absoluteString.replacingOccurrences(of: fakeURLPart, with: correctURLPart)

        if let fileName = urlToPlay.fileName,
           url.absoluteString.contains(fileName) {
            try responseOnMasterPlaylist(resourceLoadingRequest)

        } else if url.absoluteString.contains(".key") {
            try responseOnKeylist(url: url, resourceLoadingRequest)

        } else if let correctURL = URL(string: correctURLString) {
            responseWithCorrectURL(correctURL, resourceLoadingRequest)

        } else {
            throw PriviError(title: "ContentPlayerInteractor.modifyResourceLoadingRequestIfNeeded", msg: "Doesn't belong to filename/key/redirect.")
        }
    }

    func responseOnMasterPlaylist(_  resourceLoadingRequest: AVAssetResourceLoadingRequest) throws {
        guard let masterPlaylistData = masterPlaylist?.data(using: String.Encoding.utf8) else {
            throw PriviError(title: "ContentPlayerInteractor.responseOnMasterPlaylist", msg: "Failed to create masterPlaylistData.")
        }
        resourceLoadingRequest.dataRequest?.respond(with: masterPlaylistData)
        resourceLoadingRequest.finishLoading()
    }

    func responseOnKeylist(url: URL, _  resourceLoadingRequest: AVAssetResourceLoadingRequest) throws {
        guard let masterPlaylistURL = urlToPlay.url else {
            throw PriviError(title: "ContentPlayerInteractor.responseOnKeylist", msg: "Failed to get masterPlaylistURL.")
        }
        guard let playerKeyWorker = PlayerKeyWorker(masterPlaylistURL: masterPlaylistURL, keyURL: url) else {
            throw PriviError(title: "ContentPlayerInteractor.responseOnKeylist", msg: "Failed to create playerKeyWorker.")
        }
        Task {
            do {
                let keyData = try await playerKeyWorker.getKeyData()
                resourceLoadingRequest.dataRequest?.respond(with: keyData)
                resourceLoadingRequest.finishLoading()
            } catch {
                resourceLoadingRequest.finishLoading(with: error)
            }
        }
    }

    func responseWithCorrectURL(_ url: URL, _  resourceLoadingRequest: AVAssetResourceLoadingRequest) {
        resourceLoadingRequest.redirect = URLRequest(url: url)
        let response = HTTPURLResponse(url: url, statusCode: 302, httpVersion: nil, headerFields: nil)
        resourceLoadingRequest.response = response
        resourceLoadingRequest.finishLoading()
    }
}

extension ContentPlayerInteractor {
    enum URLToPlay {
        case externalPlayable
        case encryptedWithKeyCorrupted
        case ecies1
        case ecies2
        case ecies3
        case customURL(urlString: String)

        var rawValue: String {
            switch self {
            case .externalPlayable:
                return "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8"
            case .encryptedWithKeyCorrupted:
                return "https://elb.ipfsprivi.com:8080/ipfs/QmYE9vgy9JGwfhVc4MKH5pbW5XTG6rL4WvHFZVqnHFhc8L?filename=encryptedWithKeyPlayable-corrupted-v3.m3u8"
            case .ecies1:
                return "https://elb.ipfsprivi.com:8080/ipfs/QmZuVDwNUcEgEqEHWZEDgcKEHfqoMM2d7k96x57YsywzrM/master.m3u8"
            case .ecies2:
                return "https://elb.ipfsprivi.com:8080/ipfs/QmQwvQs6Ebsp8PsGWE9xXuGdFtM6DmeTR1PuWn6gdgq8oB/master.m3u8"
            case .ecies3:
                return "https://elb.ipfsprivi.com:8080/ipfs/QmeV5BRtzciWYkwcqrf9QZPENFCstY24R5Ahx2gtBMgai9/master.m3u8"
            case .customURL(urlString: let urlString):
                return urlString
            }
        }

        var url: URL? {
            return URL(string: self.rawValue)
        }

        var fileName: String? {
            return url?.absoluteString.components(separatedBy: "/").last
        }
    }
}
