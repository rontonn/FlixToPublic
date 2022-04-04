//
//  VideoOnDemandItemDetails.swift
//  Flix
//
//  Created by Anton Romanov on 21.10.2021.
//

import Foundation
import UIKit

struct VideoOnDemandItemDetails {
    // MARK: - Properties
    let title: String?
    let poster: String?
    let consumptionTime: String?
    private let country: String?
    private let year: String?
    private let genres: [Genre]
    private let rating: Rating?
    let description: String?

    // MARK: - Lifecycle
    init(title: String?, poster: String?, consumptionTime: String?, country: String?, year: String?, genres: [Genre], rating: Rating?, description: String?) {
        self.title = title
        self.poster = poster
        self.consumptionTime = consumptionTime
        self.country = country
        self.year = year
        self.genres = genres
        self.rating = rating
        self.description = description
    }
}

// MARK: - Computed properties
extension VideoOnDemandItemDetails {
    var productionInfo: NSMutableAttributedString {
        let info = NSMutableAttributedString(string: "")
        var firstString: NSMutableAttributedString?
        if let country = country {
            let firstAttr: [NSAttributedString.Key: Any] = [.font: UIFont.jakarta(font: .display, ofSize: 30, weight: .medium),
                                                            .foregroundColor: UIColor.white.withAlphaComponent(0.64)]
            firstString = NSMutableAttributedString(string: country, attributes: firstAttr)
        }
        if let year = year {
            let secondAttr: [NSAttributedString.Key: Any] = [.font: UIFont.jakarta(font: .display, ofSize: 30, weight: .medium),
                                                            .foregroundColor: UIColor.white]
            if let firstString = firstString {
                let secondString = NSMutableAttributedString(string: ", " + year, attributes: secondAttr)
                info.append(firstString)
                info.append(secondString)
            } else {
                let secondString = NSMutableAttributedString(string: year, attributes: secondAttr)
                info.append(secondString)
            }
        }
        return info
    }
    var genresInfo: String {
        var info = ""
        for (index, genre) in genres.enumerated() {
            if index != 0 {
                info += " | "
            }
            info += genre.title
        }
        return info
    }
    var ratingInfo: NSMutableAttributedString? {
        let info = NSMutableAttributedString(string: "")
        if let rating = rating,
            case let Rating.imbd(value) = rating {
            
            let firstAttr: [NSAttributedString.Key: Any] = [.font: UIFont.jakarta(font: .display, ofSize: 26, weight: .medium),
                                                            .foregroundColor: UIColor.white]
            let firstString = NSMutableAttributedString(string: value, attributes: firstAttr)

            let secondAttr: [NSAttributedString.Key: Any] = [.font: UIFont.jakarta(font: .display, ofSize: 26, weight: .medium),
                                                             .foregroundColor: UIColor.white.withAlphaComponent(0.64)]
            let secondString = NSMutableAttributedString(string: "/10", attributes: secondAttr)
            
            info.append(firstString)
            info.append(secondString)
            
        }
        return info.length == 0 ? nil : info
    }
}

extension VideoOnDemandItemDetails {
    enum Genre: String, CaseIterable {
        case action = "action_title"
        case crime = "crime_title"
        case comedy = "comedy_title"

        var title: String {
            return rawValue.localized
        }
    }
    enum Rating {
        case imbd(ratingValue: String)
    }
}
