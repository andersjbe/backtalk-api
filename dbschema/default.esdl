module default {
  abstract type Auditable {
    required created_at: datetime {
      readonly := true;
      default := datetime_current();
    }
  }

  type User extending Auditable {
    required publicId: str {
      constraint exclusive;
    }
    required username: str;
    required githubId: int64 {
      constraint exclusive;
    }
    multi sessions := (.<user[is Session]);
    multi vieweRecordings: TalkRecording {
      liked: bool {
         default := false;
       }
       lastViewed: datetime {
         default := datetime_current();
       }
    }

    index on (.username);
    index on (.publicId)
  }

  type Session extending Auditable {
    required publicId: str {
      constraint exclusive;
    }
    required expiresAt: datetime;
    required user: User {
      on target delete delete source;
    }

    index on (.publicId)
  }

  type Speaker extending Auditable {
    required name: str {
      constraint exclusive;
    }
    positionTitle: str;
    xHandle: str;
    linkedinHandle: str;

    talk := .<speakers[is TalkRecording];
  }

  type TalkRecording extending Auditable {
    required title: str;
    description: str;
    required videoUrl: str;
    required year: int32;
    required length: duration;

    required multi speakers: Speaker;
    multi tags: TalkTag;
    userViews := .<vieweRecordings[is User];
  }

  type TalkTag extending Auditable {
    required name: str {
      constraint exclusive;
    }

    talks := .<tags[is TalkRecording];
  }
}