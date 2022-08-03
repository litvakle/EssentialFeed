//
//  RemoteFeedItem.swift
//  EssentialFeedMacOS
//
//  Created by Lev Litvak on 03.08.2022.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
