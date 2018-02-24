import UIKit
import SwiftSoup

enum TableTennisError: Error {
    case missingName
    case mismatchedWinsAndPointsMatrices
}

struct Player: Equatable {
    static func ==(lhs: Player, rhs: Player) -> Bool {
        return lhs.name == rhs.name
    }
    
    let name: String
}

struct Match {
    let player1: Player
    let player2: Player
    let player1Wins: Int
    let player2Wins: Int
    
    let ratingChange: Int
    
    var winner: Player {
        return player1Wins > player2Wins ? player1 : player2
    }
    var loser: Player {
        return player1Wins > player2Wins ? player2 : player1
    }
    
    var score: String {
        return player1Wins > player2Wins ? "\(player1Wins)-\(player2Wins)" : "\(player2Wins)-\(player1Wins)"
    }
    
    var p1RatingChange: Int {
        return winner == player1 ? ratingChange : -1*ratingChange
    }
    var p2RatingChange: Int {
        return winner == player2 ? ratingChange : -1*ratingChange
    }
}

extension Match: CustomStringConvertible {
    var description: String {
        return "\(winner.name) def. \(loser.name) \(score); \(player1.name) \(p1RatingChange), \(player2.name) \(p2RatingChange)\n"
    }
}

struct GroupMatrix {
    enum MatrixType {
        case wins, points
    }
    var players: [Player] = []
    var results: [[Int]] = []
    var type: MatrixType
    
    init(type: MatrixType) {
        self.type = type
    }
}

struct GroupResult {
    let winsMatrix: GroupMatrix
    let pointsMatrix: GroupMatrix
    
    var matches = [Match]()
    
    init(winsMatrix: GroupMatrix, pointsMatrix: GroupMatrix) throws {
        self.winsMatrix = winsMatrix
        self.pointsMatrix = pointsMatrix
        try extractMatches()
    }
    
    private mutating func extractMatches() throws {
        guard winsMatrix.results.count == pointsMatrix.results.count,
            winsMatrix.players == pointsMatrix.players else { throw TableTennisError.mismatchedWinsAndPointsMatrices }
        
        matches = [Match]()
        let players = winsMatrix.players
        
        for i in 0 ..< winsMatrix.results.count {
            for j in i + 1 ..< winsMatrix.results[i].count {
                let player1 = players[i]
                let player2 = players[j]
                let player1Wins = winsMatrix.results[i][j]
                let player2Wins = winsMatrix.results[j][i]
                let ratingChange =  pointsMatrix.results[i][j]
                
                let match = Match(player1: player1, player2: player2, player1Wins: player1Wins, player2Wins: player2Wins, ratingChange: ratingChange)
                matches.append(match)
            }
        }
    }
}

func parseGameTables(_ doc: Document) throws -> [GroupResult] {
    var tables = try doc.select("table").array()
    tables.remove(at: 0)
    tables.remove(at: 0)
    
    var groupResults = [GroupResult]()
    
    for table in tables {
        var winsGroupMatrix = GroupMatrix(type: .wins)
        var pointsGroupMatrix = GroupMatrix(type: .points)
        
        let rows = try table.select("tr").array()
        for row in rows {
            guard let name = try row.getElementsByClass("datacolumn1").first()?.text() else { throw TableTennisError.missingName }

            winsGroupMatrix.players.append(Player(name: name))
            pointsGroupMatrix.players.append(Player(name: name))
            
            let gamesWon = try row.getElementsByClass("gamesemcolumn").array().map(tableTennisElementToInt)
            winsGroupMatrix.results.append(gamesWon)
            
            let pointsWon = try row.select("td").array().filter { try $0.className() == "" }.map(tableTennisElementToInt)
            pointsGroupMatrix.results.append(pointsWon)
        }
        
        groupResults.append(try GroupResult(winsMatrix: winsGroupMatrix, pointsMatrix: pointsGroupMatrix))
    }
    
    return groupResults
}

func tableTennisElementToInt(_ element: Element) throws -> Int {
    let text = try element.text()
    if let int = Int(text) {
        return int
    }
    return -99
}








do {
    let url = URL(fileURLWithPath: Bundle.main.path(forResource: "SessionGroupReport", ofType: "html")!)
    let html = try! String(contentsOf: url)
    
    let doc: Document = try SwiftSoup.parse(html)
    
    let results = try parseGameTables(doc)
    print(results[2].matches)
    
} catch Exception.Error(let type, let message) {
    print(type)
    print(message)
} catch {
    print("error")
}

