-- This file is to bootstrap a database for the CS3200 project. 

DROP virtualStudyGroupOrganizer_db;

-- Create a new database.  You can change the name later.  You'll
-- need this name in the FLASK API file(s),  the AppSmith 
-- data source creation.
create database virtualStudyGroupOrganizer_db;

-- Via the Docker Compose file, a special user called webapp will 
-- be created in MySQL. We are going to grant that user 
-- all privilages to the new database we just created. 
-- TODO: If you changed the name of the database above, you need 
-- to change it here too.
grant all privileges on virtualStudyGroupOrganizer_db.* to 'webapp'@'%';
flush privileges;

-- Move into the database we just created.
-- TODO: If you changed the name of the database above, you need to
-- change it here too. 
use virtualStudyGroupOrganizer_db;

-- OUR DDL

-- user table 
CREATE TABLE user (
  userID int PRIMARY KEY AUTO_INCREMENT,
  firstName varchar(50) NOT NULL,
  lastName varchar(50) NOT NULL, 
  userYear char(3),
  major varchar(50),
  banned boolean NOT NULL DEFAULT 0,
  moderatorID int,
  preferredSubject varchar(100) NOT NULL
  FOREIGN KEY (moderatorID) REFERENCES moderator (moderatorID) ON UPDATE cascade ON DELETE cascade
);

-- report table
CREATE TABLE report (
  authorID int NOT NULL,
  reporteeID int NOT NULL,
  reportedMessage int NOT NULL, 
  reasoning varchar(100) NOT NULL,
  resolved boolean NOT NULL DEFAULT 0,
  moderatorID int,
  PRIMARY KEY(authorID, reporteeID, reportMessage),
  FOREIGN KEY (authorID) REFERENCES user (userID) ON UPDATE cascade ON DELETE cascade,
  FOREIGN KEY (reporteeID) REFERENCES user (userID) ON UPDATE cascade ON DELETE cascade,
  FOREIGN KEY (reportedMessage) REFERENCES messages (messageID) ON UPDATE cascade ON DELETE cascade,
  FOREIGN KEY (moderatorID) REFERENCES moderator (moderatorID) ON UPDATE cascade ON DELETE cascade
);

-- bookmark table
CREATE TABLE bookmark (
  userID int NOT NULL,
  messageBoardID int NOT NULL,
  PRIMARY KEY (userID, authorID),
  FOREIGN KEY (userID) REFERENCES user (userID) ON UPDATE cascade ON DELETE cascade,
  FOREIGN KEY (messageBoardID) REFERENCES messageBoard (messageBoardID) ON UPDATE cascade ON DELETE cascade
);

-- messages table
CREATE TABLE messages (
  messageID int PRIMARY KEY AUTO_INCREMENT,
  author int NOT NULL,
  replyToID int,
  messageBoardID int NOT NULL,
  publishTime datetime, 
  content text,
  published boolean DEFAULT 0,
  moderatorID int,
  FOREIGN KEY (author) REFERENCES user (userID) ON UPDATE cascade ON DELETE cascade,
  FOREIGN KEY (replyToID) REFERENCES messages (messageID) ON UPDATE cascade ON DELETE cascade,
  FOREIGN KEY (messageBoardID) REFERENCES messageBoard (messageBoardID) ON UPDATE cascade ON DELETE cascade,
  FOREIGN KEY (moderatorID) REFERENCES moderator (moderatorID) ON UPDATE cascade ON DELETE cascade
);

-- messages board table
CREATE TABLE messageBoard (
    messageBoardID int PRIMARY KEY AUTO_INCREMENT,
    boardName varchar(50) NOT NULL,
    moderatorID int,
    FOREIGN KEY (moderatorID) REFERENCES moderator (moderatorID) ON UPDATE cascade ON DELETE cascade
);


CREATE TABLE attendance (
  userID int NOT NULL,
  groupID int NOT NULL,
  sessionDate DATETIME NOT NULL,
  attended boolean NOT NULL,
  PRIMARY KEY(userID, groupID, sessionDate)
);

CREATE TABLE subjects (
  subjectID int PRIMARY KEY AUTO_INCREMENT,
  subjectName varchar(50) NOT NULL
);


CREATE TABLE studyGroup (
  groupID int PRIMARY KEY AUTO_INCREMENT,
  studySubject int NOT NULL,
  organizer int NOT NULL,
  groupName varchar(50) NOT NULL,
  meetingTime datetime,
  capacity int NOT NULL,
  enrollment int DEFAULT 0,
  goal varchar(100) NOT NULL,
  moderatorID int,
  FOREIGN KEY (studySubject) REFERENCES subjects (subjectID) ON UPDATE cascade ON DELETE cascade,
  FOREIGN KEY (organizer) REFERENCES user (userID) ON UPDATE cascade ON DELETE cascade,
  FOREIGN KEY (moderatorID) REFERENCES moderator (moderatorID) ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE review (
  reviewID int PRIMARY KEY AUTO_INCREMENT,
  groupID int NOT NULL,
  author int NOT NULL,
  review varchar(100) NOT NULL,
  rating int NOT NULL CHECK (rating >= 1 AND rating <= 5)
  FOREIGN KEY (groupID) REFERENCES studyGroup (groupID) ON UPDATE cascade ON DELETE cascade,
  FOREIGN KEY (author) REFERENCES user (userID) ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE resource (
  resourceID int PRIMARY KEY AUTO_INCREMENT,
  uploader int NOT NULL,
  uploadDateTime datetime DEFAULT CURRENT_TIMESTAMP,
  uploadedResource varchar(100) NOT NULL, -- idk what to put for the type
  published boolean NOT NULL DEFAULT 0,
  groupID int NOT NULL,
  moderatorID int,
  FOREIGN KEY (uploader) REFERENCES user (userID) ON UPDATE cascade ON DELETE cascade,
  FOREIGN KEY (groupID) REFERENCES studyGroup (groupID) ON UPDATE cascade ON DELETE cascade,
  FOREIGN KEY (moderatorID) REFERENCES moderator (moderatorID) ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE moderator (
  moderatorID int PRIMARY KEY AUTO_INCREMENT,
  firstName varchar(50) NOT NULL,
  lastName varchar(50) NOT NULL
);

CREATE TABLE userInGroup (
  userID int NOT NULL,
  groupID int NOT NULL,
  PRIMARY KEY (userID, groupID),
  FOREIGN KEY (userID) REFERENCES user (userID) ON UPDATE cascade ON DELETE cascade,
  FOREIGN KEY (groupID) REFERENCES studyGroup (groupID) ON UPDATE cascade ON DELETE cascade
);

-- -- Put your DDL 
-- CREATE TABLE fav_colors (
--   name VARCHAR(20),
--   color VARCHAR(10)
-- );

-- -- Add sample data. 
-- INSERT INTO fav_colors
--   (name, color)
-- VALUES
--   ('dev', 'blue'),
--   ('pro', 'yellow'),
--   ('junior', 'red');
