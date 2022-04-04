//
//  PurchaseConsumptionTimeOption.swift
//  Flix
//
//  Created by Anton Romanov on 09.11.2021.
//

import UIKit

struct PurchaseConsumptionTimeOption {
    // MARK: - Properties
    let hours: Int
    let price: Int
    let reward: Int
    let id = UUID()
}

// MARK: - Hashable
extension PurchaseConsumptionTimeOption: Hashable {
    static func ==(lhs: PurchaseConsumptionTimeOption, rhs: PurchaseConsumptionTimeOption) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

// MARK: - Computed properties
extension PurchaseConsumptionTimeOption {
    var hoursTitle: String {
        return "+" + String(hours) + "h"
    }
    var priceTitle: String {
        return String(price) + " USDT"
    }
    var rewardTile: String {
        return "+ " + String(reward) + " " + "flix_reward_title".localized
    }
}
