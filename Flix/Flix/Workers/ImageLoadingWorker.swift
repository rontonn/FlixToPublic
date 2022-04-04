//
//  ImageLoadingWorker.swift
//  Flix
//
//  Created by Anton Romanov on 07.12.2021.
//

import UIKit

enum ImageLoadingWorker {
    static func fetchImage(_ url: URL, size: CGSize? = nil) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw PriviError(title: "ImageLoadingWorker.fetchImage", msg: "Failed to load image from url: = \(url.absoluteString)")
        }
        let fImage: UIImage
        let tImage = UIImage(data: data)
        if let size = size {
            guard let thumbnail = await tImage?.byPreparingThumbnail(ofSize: size) else {
                throw PriviError(title: "ImageLoadingWorker.fetchImage", msg: "Failed to load thumbnail")
            }
            fImage = thumbnail
        } else {
            guard let thumbnail = await tImage?.byPreparingForDisplay() else {
                throw PriviError(title: "ImageLoadingWorker.fetchImage", msg: "Failed to prepare image.")
            }
            fImage = thumbnail
        }
        return fImage
    }
}
