import UIKit
import SwiftSoup

enum TableTennisError: Error {
    case missingName
}

struct Player {
    var name: String
}
struct Match {
    var player1: Player
    var player2: Player
    var player1Wins: Int
    var player2Wins: Int
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
}

let p1 = Player(name: "Jason Ji")
let p2 = Player(name: "Tausif Ullah")
let match = Match(player1: p1, player2: p2, player1Wins: 3, player2Wins: 0)


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
            let wins = try row.getElementsByClass("gameswlcolumn").array()[0].text()
            let losses = try row.getElementsByClass("gameswlcolumn").array()[1].text()
            
            winsGroupMatrix.players.append(Player(name: name))
            pointsGroupMatrix.players.append(Player(name: name))
            
            let gamesWon = try row.getElementsByClass("gamesemcolumn").array().map(tableTennisElementToInt)
            winsGroupMatrix.results.append(gamesWon)
            
            let pointsWon = try row.select("td").array().filter { try $0.className() == "" }.map(tableTennisElementToInt)
            pointsGroupMatrix.results.append(pointsWon)
        }
        
        groupResults.append(GroupResult(winsMatrix: winsGroupMatrix, pointsMatrix: pointsGroupMatrix))
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
    print(results[2].winsMatrix)
    
} catch Exception.Error(let type, let message) {
    print(message)
} catch {
    print("error")
}

