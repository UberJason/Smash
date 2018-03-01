# Smash App To-Do List
- Implement storage (probably Core Data) to save League reports.
- Start thinking about overall app structure - saving preferred `Player`.name in `NSUserDefaults` perhaps.
- Build a proper view controller that takes a `LeagueSession` and a `preferredPlayer` and shows the results, based on Sketch mock-up.

Player
- name

Match.player1 <--> Player.player1Matches
Match.player2 <--> Player.player2Matches

GroupResult.matches <---> Match.groupResult
- winsMatrix: Codable
- pointsMatrix: Codable
- finalRatings: Codable
- netRatingChanges: Codable

LeagueSession.groupResults <---> GroupResult.leagueSession
