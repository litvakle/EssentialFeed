//
//  FeedItem.swift
//  EssentialFeedMacOS
//
//  Created by Lev Litvak on 27.07.2022.
//

import Foundation

struct FeedItem {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
