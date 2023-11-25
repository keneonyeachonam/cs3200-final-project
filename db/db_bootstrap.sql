-- This file is to bootstrap a database for the CS3200 project. 

-- Create a new database.  You can change the name later.  You'll
-- need this name in the FLASK API file(s),  the AppSmith 
-- data source creation.
create database IF NOT EXISTS cool_db;

-- Via the Docker Compose file, a special user called webapp will 
-- be created in MySQL. We are going to grant that user 
-- all privilages to the new database we just created. 
-- TODO: If you changed the name of the database above, you need 
-- to change it here too.
grant all privileges on cool_db.* to 'webapp'@'%';
flush privileges;

-- Move into the database we just created.
-- TODO: If you changed the name of the database above, you need to
-- change it here too. 
use cool_db;

-- OUR DDL

-- user table 
CREATE TABLE IF NOT EXISTS users (
  userID int UNIQUE NOT NULL PRIMARY KEY,
  firstName varchar(50) NOT NULL,
  lastName (50) NOT NULL, 
  userYear char(3),
  major varchar(50),
  banned boolean,
  moderatorID int UNIQUE NOT NULL,
  preferredSubject varchar(100) NOT NULL
);
-- ALTER TABLE users ADD FOREIGN KEY (moderatorID) REFERENCES moderator (moderatorID) ON UPDATE cascade ON DELETE cascade;

-- report table
CREATE TABLE IF NOT EXISTS report (
  authorID int UNIQUE,
  reporteeID int UNIQUE,
  reportMessage varchar(100) NOT NULL, -- message in report table in doc
  reasoning varchar(100) NOT NULL,
  isResolved boolean,
  moderatorID int UNIQUE NOT NULL,
  PRIMARY KEY(authorID, reporteeID, reportMessage)
)
-- ALTER TABLE report ADD FOREIGN KEY (moderatorID) REFERENCES moderator (moderatorID) ON UPDATE cascade ON DELETE cascade;

-- bookmarks table
CREATE TABLE IF NOT EXISTS bookmarks (
  userID int UNIQUE NOT NULL,
  messageBoardID int UNIQUE NOT NULL,
  PRIMARY KEY(userID, authorID)
)
-- ALTER TABLE bookmarks ADD FOREIGN KEY (userID) REFERENCES users (userID) ON UPDATE cascade ON DELETE cascade;
-- ALTER TABLE bookmarks ADD FOREIGN KEY (messageBoardID) REFERENCES messages (messageBoardID) ON UPDATE cascade ON DELETE cascade;

-- messages table
CREATE TABLE IF NOT EXISTS messages (
   authorID int UNIQUE NOT NULL PRIMARY KEY,
   replyToID int UNIQUE NOT NULL,
   messageBoardID int UNIQUE NOT NULL,
   publishTime timestamp, 
   content text,
   published boolean,
   moderatorID int UNIQUE NOT NULL,
   messageID int UNIQUE NOT NULL
)
-- ALTER TABLE messages ADD FOREIGN KEY (messageBoardID) REFERENCES messages (messageBoardID) ON UPDATE cascade ON DELETE cascade;
-- ALTER TABLE messages ADD FOREIGN KEY (moderatorID) REFERENCES moderator (moderatorID) ON UPDATE cascade ON DELETE cascade;

-- message board table
CREATE TABLE IF NOT EXISTS messageBoard (
    messageBoardID int UNIQUE NOT NULL,
    name varchar(50),
    moderatorID int UNIQUE NOT NULL
)
-- ALTER TABLE messageBoard ADD FOREIGN KEY (moderatorID) REFERENCES moderator (moderatorID) ON UPDATE cascade ON DELETE cascade;




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
