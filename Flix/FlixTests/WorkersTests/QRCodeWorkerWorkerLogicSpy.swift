//
//  QRCodeWorkerWorkerLogicSpy.swift
//  FlixTests
//
//  Created by Anton Romanov on 17.11.2021.
//

import UIKit
@testable import Flix

final class QRCodeWorkerWorkerLogicSpy {
    // MARK: - Public Properties
    private (set) var isCalledQrCodeImage = false
}

extension QRCodeWorkerWorkerLogicSpy: QRCodeWorkerWorkerLogic {
    func qrCodeImage() -> UIImage? {
        isCalledQrCodeImage = true
        return nil
    }
}
