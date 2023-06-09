import SwiftUI
import AppKit
import PlaygroundSupport

/// Data Protocol

protocol DataProtocol: Identifiable {
    var id: UUID { get }
    func getName() -> String
    func getDetails() -> String
    var coverView: AnyView { get }
}

/// View Protocol

protocol ViewProtocol: View {
    var data: any DataProtocol { get }
}

/// Data Structures

struct Artist {
    let id = UUID()
    let name: String
    let photo: Image
    let bestAlbum: String
    let year: String
}

extension Artist: DataProtocol {
    func getName() -> String { name }
    func getDetails() -> String { "\(bestAlbum) (\(year))" }
    var coverView: AnyView {
        AnyView(photo.resizable().opacity(0.3))
    }
}

struct Song {
    let id = UUID()
    let artistName: String
    let songName: String
    let duration: String
    let category: String
    let albumCover: Image
}

extension Song: DataProtocol {
    func getName() -> String { songName }
    func getDetails() -> String { "\(artistName) \(duration) - \(category)" }
    var coverView: AnyView {
        AnyView(
            ZStack {
                Color.teal
                albumCover
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity(0.3)
            }
        )
    }
}

struct MusicList {
    let id = UUID()
    let listName: String
    let numberOfSongs: Int
    let creatorName: String
    let listCoverColor: Color
}

extension MusicList: DataProtocol {
    func getName() -> String { listName }
    func getDetails() -> String { "by \(creatorName)\n(List) \(numberOfSongs) song" + (numberOfSongs != 1 ? "s": "") }
    var coverView: AnyView {
        AnyView(
            Circle()
                .fill(Gradient(colors: [listCoverColor, .gray]))
        )
    }
}


/// View Structures

struct FullCover: ViewProtocol {
    let data: any DataProtocol
    
    var body: some View {
        ZStack {
            data.coverView.frame(width: 200.0, height: 200.0)
            VStack {
                Text(data.getName())
                    .font(.title)
                    .shadow(color: .black, radius: 2.0)
                Text(data.getDetails())
                    .font(.body)
            }
        }
    }

}

struct SingleRow: ViewProtocol {
    let data: any DataProtocol
    
    var body: some View {
        HStack {
            data.coverView.frame(width: 60.0, height: 60.0)
            VStack {
                Text(data.getName()).font(.title)
                Text(data.getDetails()).font(.body)
            }
        }
    }
}

struct SmallRow: ViewProtocol {
    let data: any DataProtocol
    
    var body: some View {
        HStack {
            data.coverView.frame(width: 16.0, height: 16.0)
            Text(data.getName())
                .font(.headline)
                .frame(height: 16.0)
                .truncationMode(.tail)
        }
        .frame(width: 200.0)
    }
}

struct TextOnly: ViewProtocol {
    let data: any DataProtocol
    
    var body: some View {
        Text(data.getName() + " | " + data.getDetails())
    }
}

enum DataRepository {
    static let testMusicList = MusicList(listName: "Top songs", numberOfSongs: 10, creatorName: "Julián Arias", listCoverColor: .purple)
    static let testArtist = Artist(name: "Queen", photo: Image(systemName: "music.mic.circle.fill"), bestAlbum: "A Night At The Opera", year: "1975")
    static let testSong = Song(artistName: "AC/DC", songName: "Highway to Hell", duration: "3:29", category: "Rock", albumCover: Image(systemName: "road.lanes"))
    static func getAllData() -> [any DataProtocol] {
        [testArtist, testSong, testMusicList]
    }
}

/// Main View
struct MainView: View {
    private let data = DataRepository.getAllData()
    var body: some View {
        VStack {
            HStack {
                ForEach(data, id: \.id) { data in
                    FullCover(data: data)
                }
            }
            HStack {
                ForEach(data, id: \.id) { data in
                    SingleRow(data: data)
                }
            }
            HStack {
                ForEach(data, id: \.id) { data in
                    VStack {
                        SmallRow(data: data)
                        TextOnly(data: data)
                    }
                }
            }
        }
    }
}

// Present the view in Playground
PlaygroundPage.current.liveView = NSHostingView(rootView: MainView())

