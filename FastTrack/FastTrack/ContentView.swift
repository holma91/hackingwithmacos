//
//  ContentView.swift
//  FastTrack
//
//  Created by Alexander on 2023-01-23.
//

import SwiftUI
import AVKit

struct ContentView: View {
  let gridItems: [GridItem] = [
    GridItem(.adaptive(minimum: 150, maximum: 200)),
  ]
  @AppStorage("searchText") var searchText = ""
  @State private var tracks = [Track]()
  @State private var audioPlayer: AVPlayer?
  @State private var playingUrl: URL?
  @State private var isPlaying = true
  @State private var audioQueuePlayer: AVQueuePlayer?
  @State private var searchState = SearchState.none
  @State private var searches = [String]()
  @State private var selectedSearch = ""
  
  enum SearchState {
    case none, searching, success, error
  }
  
  func performSearch() async throws {
    let rawSearchText = searchText
    guard let searchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
    guard let url = URL(string: "https://itunes.apple.com/search?term=\(searchText)&limit=100&entity=song") else { return }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
    
    if !searches.contains(rawSearchText) {
      searches.insert(rawSearchText, at: 0)
    }
    selectedSearch = rawSearchText
    tracks = searchResult.results
  }

  func startSearch() {
    searchState = .searching
    
    Task {
      do {
        try await performSearch()
        searchState = .success
      } catch let error {
        print("error: \(error)")
        searchState = .error
      }
      
    }
  }
  
  func play(_ track: Track) {
    if track.previewUrl == playingUrl {
      print("same song!")
      if isPlaying {
        audioPlayer?.pause()
      } else {
        audioPlayer?.play()
      }
      isPlaying.toggle()
      return
    }
    
    audioPlayer?.pause()
    audioPlayer = AVPlayer(url: track.previewUrl!)
    audioPlayer?.play()
    playingUrl = track.previewUrl!
    
  }
  
  var body: some View {
    NavigationSplitView {
      List(searches, id: \.self, selection: $selectedSearch) { searchX in
        Text(searchX).tag(searchX)
      }
      .onChange(of: selectedSearch) { value in
        searchText = value
        startSearch()
      }
    } detail: {
      VStack {
        
        switch searchState {
        case .none:
          Text("Enter a search term to begin.")
            .frame(maxHeight: .infinity)
        case .searching:
          ProgressView()
            .frame(maxHeight: .infinity)
        case .success:
          ScrollView {
            LazyVGrid(columns: gridItems) {
              ForEach(tracks) { track in
                TrackView(track: track, onSelected: play)
              }
            }
            .padding()
          }
        case .error:
          Text("Sorry, your search failed – please check your internet connection then try again.")
              .frame(maxHeight: .infinity)
        }
      }
    }
    .onAppear(perform: startSearch)
    .searchable(text: $searchText)
    .onSubmit(of: .search, startSearch)
  }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
