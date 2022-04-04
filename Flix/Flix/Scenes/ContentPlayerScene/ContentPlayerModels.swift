//
//  
//  ContentPlayerModels.swift
//  Flix
//
//  Created by Anton Romanov on 12.11.2021.
//
//

import AVFoundation

enum ContentPlayerModels {
    // MARK: - InitialData
    enum InitialData {
        struct Request {}
        struct Response {
            let url: URL
        }
        struct ViewModel {
            let url: URL
        }
    }

    // MARK: - InitialData
    enum AssetLoaderData {
        struct Request {
            let resourceLoadingRequest: AVAssetResourceLoadingRequest
        }
        struct Response {}
        struct ViewModel {}
    }

    // MARK: - LogEvent
    enum LogEvent {
        struct Request {
            let playerItem: AVPlayerItem
        }
        struct Response {}
        struct ViewModel {}
    }
}
