//
//  Track.swift
//  FastTrack
//
//  Created by Alexander on 2023-01-23.
//

import Foundation

struct SearchResult: Decodable {
  let results: [Track]
}

struct Track: Identifiable, Decodable, Equatable {
  let trackId: Int
  let artistName: String
  let trackName: String
  let previewUrl: URL? // censored tracks does not have this property for some reason
  let artworkUrl100: String
  
  var id: Int { trackId }
  
  var artworkURL: URL? {
    let replacedString = artworkUrl100.replacingOccurrences(of: "100x100", with: "300x300")
    return URL(string: replacedString)
  }
}
