//
//  SpecialPlayerEvents.swift
//  Flix
//
//  Created by Anton Romanov on 12.11.2021.
//

import AVFoundation

struct BasePlaybackBuffer {
    let isPlaybackLikelyToKeepUp: Bool?
    let isPlaybackBufferEmpty: Bool?
    let isPlaybackBufferFull: Bool?
}

struct PlaybackAccessEvent {
    let accessEvent: AVPlayerItemAccessLogEvent
    let basePlaybackBuffer: BasePlaybackBuffer?

    func toDictionary() -> [String: Any] {
        let json: [String: Any?] = [
            "averageAudioBitrate": accessEvent.averageAudioBitrate,
            "averageVideoBitrate": accessEvent.averageVideoBitrate,
            "indicatedAverageBitrate": accessEvent.indicatedAverageBitrate,
            "mediaRequestsWWAN": accessEvent.mediaRequestsWWAN,
            "numberOfBytesTransferred": accessEvent.numberOfBytesTransferred,
            "numberOfMediaRequests": accessEvent.numberOfMediaRequests,
            "numberOfServerAddressChanges": accessEvent.numberOfServerAddressChanges,
            "observedBitrate": accessEvent.observedBitrate,
            "observedBitrateStandardDeviation": accessEvent.observedBitrateStandardDeviation,
            "playbackStartOffset": accessEvent.playbackStartOffset,
            "switchBitrate": accessEvent.switchBitrate,
            "transferDuration": accessEvent.transferDuration,
            "serverAddress": accessEvent.serverAddress,
            "uri": accessEvent.uri,
            "indicatedBitrate": accessEvent.indicatedBitrate,
            "playbackStartDate": accessEvent.playbackStartDate,
            "playbackSessionID": accessEvent.playbackSessionID,
            "playbackType": accessEvent.playbackType,
            "startupTime": accessEvent.startupTime,
            "durationWatched": accessEvent.durationWatched,
            "numberOfDroppedVideoFrames": accessEvent.numberOfDroppedVideoFrames,
            "numberOfStalls": accessEvent.numberOfStalls,
            "segmentsDownloadedDuration": accessEvent.segmentsDownloadedDuration,
            "downloadOverdue": accessEvent.downloadOverdue,
            "debugDescription": accessEvent.debugDescription,
            "isPlaybackLikelyToKeepUp": basePlaybackBuffer?.isPlaybackLikelyToKeepUp,
            "isPlaybackBufferEmpty": basePlaybackBuffer?.isPlaybackBufferEmpty,
            "isPlaybackBufferFull": basePlaybackBuffer?.isPlaybackBufferFull
        ]
        return json.compactMapValues { $0 }
    }
}

struct PlaybackErrorEvent {
    let errorEvent: AVPlayerItemErrorLogEvent

    func toDictionary() -> [String: Any] {
        let json: [String: Any?] = [
            "errorDomain": errorEvent.errorDomain,
            "errorStatusCode": errorEvent.errorStatusCode,
            "date": errorEvent.date,
            "errorComment": errorEvent.errorComment,
            "serverAddress": errorEvent.serverAddress,
            "uri": errorEvent.uri,
            "playbackSessionID": errorEvent.playbackSessionID,
            "debugDescription": errorEvent.debugDescription
        ]
        return json.compactMapValues { $0 }
    }
}
