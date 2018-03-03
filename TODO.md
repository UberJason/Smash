# Smash App To-Do List
- Fix tint colors
- Think about UI for an entire session summary

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
