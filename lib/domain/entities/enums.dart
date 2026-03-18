/// Status enum for user profiles
enum ProfileStatus {
  active,
  inactive,
  banned,
}

/// Status enum for bets
enum BetStatus {
  pending,
  won,
  lost,
}

/// Status enum for lottery draws
enum DrawStatus {
  pending,
  completed,
  cancelled,
}

/// Win criteria enum for determining prize tiers
enum WinCriteria {
  match6,        // Match all 6 numbers
  match5,        // Match 5 numbers (bonus)
  match4,        // Match 4 numbers (bonus)
  match3Front,   // Match first 3 numbers
  match3Back,    // Match last 3 numbers
  match2Front,   // Match first 2 numbers
  match2Back,    // Match last 2 numbers
}

/// Friend request/status enum
enum FriendStatus {
  pending,
  accepted,
  blocked,
}
