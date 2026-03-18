import '../../domain/entities/enums.dart';

/// Extension methods for converting ProfileStatus enum to/from string
extension ProfileStatusX on ProfileStatus {
  String get value {
    switch (this) {
      case ProfileStatus.active:
        return 'ACTIVE';
      case ProfileStatus.inactive:
        return 'INACTIVE';
      case ProfileStatus.banned:
        return 'BANNED';
    }
  }

  static ProfileStatus fromValue(String value) {
    switch (value.toUpperCase()) {
      case 'ACTIVE':
        return ProfileStatus.active;
      case 'INACTIVE':
        return ProfileStatus.inactive;
      case 'BANNED':
        return ProfileStatus.banned;
      default:
        return ProfileStatus.active;
    }
  }
}

/// Extension methods for converting BetStatus enum to/from string
extension BetStatusX on BetStatus {
  String get value {
    switch (this) {
      case BetStatus.pending:
        return 'PENDING';
      case BetStatus.won:
        return 'WON';
      case BetStatus.lost:
        return 'LOST';
    }
  }

  static BetStatus fromValue(String value) {
    switch (value.toUpperCase()) {
      case 'PENDING':
        return BetStatus.pending;
      case 'WON':
        return BetStatus.won;
      case 'LOST':
        return BetStatus.lost;
      default:
        return BetStatus.pending;
    }
  }
}

/// Extension methods for converting DrawStatus enum to/from string
extension DrawStatusX on DrawStatus {
  String get value {
    switch (this) {
      case DrawStatus.pending:
        return 'PENDING';
      case DrawStatus.completed:
        return 'COMPLETED';
      case DrawStatus.cancelled:
        return 'CANCELLED';
    }
  }

  static DrawStatus fromValue(String value) {
    switch (value.toUpperCase()) {
      case 'PENDING':
        return DrawStatus.pending;
      case 'COMPLETED':
        return DrawStatus.completed;
      case 'CANCELLED':
        return DrawStatus.cancelled;
      default:
        return DrawStatus.pending;
    }
  }
}

/// Extension methods for converting WinCriteria enum to/from string
extension WinCriteriaX on WinCriteria {
  String get value {
    switch (this) {
      case WinCriteria.match6:
        return 'MATCH_6';
      case WinCriteria.match5:
        return 'MATCH_5';
      case WinCriteria.match4:
        return 'MATCH_4';
      case WinCriteria.match3Front:
        return 'MATCH_3_FRONT';
      case WinCriteria.match3Back:
        return 'MATCH_3_BACK';
      case WinCriteria.match2Front:
        return 'MATCH_2_FRONT';
      case WinCriteria.match2Back:
        return 'MATCH_2_BACK';
    }
  }

  static WinCriteria fromValue(String value) {
    switch (value.toUpperCase()) {
      case 'MATCH_6':
        return WinCriteria.match6;
      case 'MATCH_5':
        return WinCriteria.match5;
      case 'MATCH_4':
        return WinCriteria.match4;
      case 'MATCH_3_FRONT':
        return WinCriteria.match3Front;
      case 'MATCH_3_BACK':
        return WinCriteria.match3Back;
      case 'MATCH_2_FRONT':
        return WinCriteria.match2Front;
      case 'MATCH_2_BACK':
        return WinCriteria.match2Back;
      default:
        return WinCriteria.match6;
    }
  }
}

/// Extension methods for converting FriendStatus enum to/from string
extension FriendStatusX on FriendStatus {
  String get value {
    switch (this) {
      case FriendStatus.pending:
        return 'pending';
      case FriendStatus.accepted:
        return 'accepted';
      case FriendStatus.blocked:
        return 'blocked';
    }
  }

  static FriendStatus fromValue(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return FriendStatus.pending;
      case 'accepted':
        return FriendStatus.accepted;
      case 'blocked':
        return FriendStatus.blocked;
      default:
        return FriendStatus.pending;
    }
  }
}
