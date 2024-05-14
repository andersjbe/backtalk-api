CREATE MIGRATION m1mf2wifvh4zqu4odd3vovsksbmnmzncp5u3dqoqea5fy33gbaez7a
    ONTO initial
{
  CREATE ABSTRACT TYPE default::Auditable {
      CREATE REQUIRED PROPERTY created_at: std::datetime {
          SET default := (std::datetime_current());
          SET readonly := true;
      };
  };
  CREATE TYPE default::Session EXTENDING default::Auditable {
      CREATE REQUIRED PROPERTY publicId: std::str {
          CREATE CONSTRAINT std::exclusive;
      };
      CREATE INDEX ON (.publicId);
      CREATE REQUIRED PROPERTY expiresAt: std::datetime;
  };
  CREATE TYPE default::Speaker EXTENDING default::Auditable {
      CREATE PROPERTY linkedinHandle: std::str;
      CREATE REQUIRED PROPERTY name: std::str {
          CREATE CONSTRAINT std::exclusive;
      };
      CREATE PROPERTY positionTitle: std::str;
      CREATE PROPERTY xHandle: std::str;
  };
  CREATE TYPE default::TalkRecording EXTENDING default::Auditable {
      CREATE REQUIRED MULTI LINK speakers: default::Speaker;
      CREATE PROPERTY description: std::str;
      CREATE REQUIRED PROPERTY length: std::duration;
      CREATE REQUIRED PROPERTY title: std::str;
      CREATE REQUIRED PROPERTY videoUrl: std::str;
      CREATE REQUIRED PROPERTY year: std::int32;
  };
  CREATE TYPE default::TalkTag EXTENDING default::Auditable {
      CREATE REQUIRED PROPERTY name: std::str {
          CREATE CONSTRAINT std::exclusive;
      };
  };
  CREATE TYPE default::User EXTENDING default::Auditable {
      CREATE MULTI LINK vieweRecordings: default::TalkRecording {
          CREATE PROPERTY lastViewed: std::datetime {
              SET default := (std::datetime_current());
          };
          CREATE PROPERTY liked: std::bool {
              SET default := false;
          };
      };
      CREATE REQUIRED PROPERTY publicId: std::str {
          CREATE CONSTRAINT std::exclusive;
      };
      CREATE INDEX ON (.publicId);
      CREATE REQUIRED PROPERTY username: std::str;
      CREATE INDEX ON (.username);
      CREATE REQUIRED PROPERTY githubId: std::int64 {
          CREATE CONSTRAINT std::exclusive;
      };
  };
  ALTER TYPE default::Session {
      CREATE REQUIRED LINK user: default::User {
          ON TARGET DELETE DELETE SOURCE;
      };
  };
  ALTER TYPE default::User {
      CREATE MULTI LINK sessions := (.<user[IS default::Session]);
  };
  ALTER TYPE default::Speaker {
      CREATE LINK talk := (.<speakers[IS default::TalkRecording]);
  };
  ALTER TYPE default::TalkRecording {
      CREATE MULTI LINK tags: default::TalkTag;
      CREATE LINK userViews := (.<vieweRecordings[IS default::User]);
  };
  ALTER TYPE default::TalkTag {
      CREATE LINK talks := (.<tags[IS default::TalkRecording]);
  };
};
