//
//  QRCodeWorker.swift
//  Flix
//
//  Created by Anton Romanov on 14.10.2021.
//

import UIKit

protocol QRCodeWorkerWorkerLogic {
    func qrCodeImage() -> UIImage?
}

struct QRCodeWorker {
    let context: String
    let scaleX: CGFloat
    let scaleY: CGFloat
}

extension QRCodeWorker: QRCodeWorkerWorkerLogic {
    func qrCodeImage() -> UIImage? {
        let data = context.data(using: String.Encoding.utf8)

        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        qrFilter.setValue(data, forKey: "inputMessage")

        guard let qrImage = qrFilter.outputImage else {
            return nil
        }

        let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        let scaleQRImage = qrImage.transformed(by: transform)

        return UIImage(ciImage: scaleQRImage)
    }
}
