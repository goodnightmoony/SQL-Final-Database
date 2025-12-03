CREATE DATABASE vct;
USE vct;

CREATE TABLE league (
	league_id INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50) NOT NULL,
	abbreviation VARCHAR(10)
);

CREATE TABLE tier (
  tier_id INT PRIMARY KEY AUTO_INCREMENT,
  tier_name VARCHAR(50) NOT NULL,
  abbreviation VARCHAR(50),
  `description` VARCHAR(500)
);

CREATE TABLE role (
  role_id INT PRIMARY KEY AUTO_INCREMENT,
  role_name VARCHAR(100) NOT NULL,
  `description` VARCHAR(500)
);

CREATE TABLE online_platform (
  platform_id INT PRIMARY KEY AUTO_INCREMENT,
  platform_name VARCHAR(50),
  `description` VARCHAR(500),
  url VARCHAR(500)
);

CREATE TABLE country (
  country_id INT PRIMARY KEY AUTO_INCREMENT,
  country_name VARCHAR(50) NOT NULL
);

CREATE TABLE class (
  class_id INT PRIMARY KEY AUTO_INCREMENT,
  class_name VARCHAR(50) NOT NULL,
  `description` VARCHAR(500)
);

CREATE TABLE city (
  city_id INT PRIMARY KEY AUTO_INCREMENT,
  city_name VARCHAR(50)
);

CREATE TABLE `organization` (
  org_id INT PRIMARY KEY AUTO_INCREMENT,
  org_name VARCHAR(50),
  league_id INT NOT NULL,
  founder_f_name VARCHAR(50),
  founder_l_name VARCHAR(50),
  year_founded YEAR,
    FOREIGN KEY (league_id)
    REFERENCES league(league_id)
      ON UPDATE RESTRICT
      ON DELETE RESTRICT
);

CREATE TABLE team (
  team_id INT PRIMARY KEY AUTO_INCREMENT,
  org_id INT NOT NULL,
  team_name VARCHAR(50),
  abbreviation VARCHAR(10),
  logo BLOB(3000),                                                         
  tier_id INT NOT NULL,
    FOREIGN KEY (org_id)
    REFERENCES `organization`(org_id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT,
    FOREIGN KEY (tier_id)
    REFERENCES tier(tier_id)
      ON UPDATE RESTRICT
      ON DELETE RESTRICT
);

CREATE TABLE `member` (
  member_id INT PRIMARY KEY AUTO_INCREMENT,
  ign VARCHAR(50),
  f_name VARCHAR(100),
  l_name VARCHAR(100),
  birthdate DATE,
  country_id INT NOT NULL,
  city_id INT,
  photo BLOB(3000),
    FOREIGN KEY (country_id)
    REFERENCES country(country_id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT,
    FOREIGN KEY (city_id)
    REFERENCES city(city_id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
);

CREATE TABLE member_to_team_to_role (
  mem_team_role_id INT PRIMARY KEY AUTO_INCREMENT,
  member_id INT NOT NULL,
  team_id INT NOT NULL,
  role_id INT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE,
    FOREIGN KEY (member_id)
    REFERENCES `member`(member_id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT,
    FOREIGN KEY (team_id)
    REFERENCES team(team_id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT,
    FOREIGN KEY (role_id)
    REFERENCES `role`(role_id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
);

CREATE TABLE `account` (
  account_id INT PRIMARY KEY AUTO_INCREMENT,
  member_id INT NOT NULL,
  platform_id INT NOT NULL,
  username VARCHAR(100) NOT NULL,
  url VARCHAR(500),
    FOREIGN KEY (member_id)
    REFERENCES `member`(member_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
    FOREIGN KEY (platform_id)
    REFERENCES online_platform(platform_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
);

CREATE TABLE agent (
  agent_id INT PRIMARY KEY AUTO_INCREMENT,
  agent_name VARCHAR(50) NOT NULL,
  class_id INT NOT NULL,
  `description` VARCHAR(500),
    FOREIGN KEY (class_id)
    REFERENCES class(class_id)
      ON UPDATE RESTRICT
      ON DELETE RESTRICT
);

CREATE TABLE pick (
  pick_id INT PRIMARY KEY AUTO_INCREMENT,
  member_id INT NOT NULL,
  agent_id INT NOT NULL,
    FOREIGN KEY (member_id)
    REFERENCES `member`(member_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
    FOREIGN KEY (agent_id)
    REFERENCES agent(agent_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
);

CREATE TABLE `event` (
  event_id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(50) NOT NULL,
  prize_pool INT,
  league_id INT,
  country_id INT,
  city_id INT,
  start_date DATE NOT NULL,
  end_date DATE,
  winning_team INT,
    FOREIGN KEY (league_id)
    REFERENCES league(league_id)
      ON UPDATE RESTRICT
      ON DELETE RESTRICT,
    FOREIGN KEY (country_id)
    REFERENCES country(country_id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT,
    FOREIGN KEY (city_id)
    REFERENCES city(city_id)
      ON UPDATE CASCADE
      ON DELETE SET NULL,
    FOREIGN KEY (winning_team)
    REFERENCES team(team_id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
);

CREATE TABLE showing (
  showing_id INT PRIMARY KEY AUTO_INCREMENT,
  team_id INT NOT NULL,
  event_id INT NOT NULL,
  win BOOL,
  loss BOOL,
  date DATETIME,
    FOREIGN KEY (team_id)
    REFERENCES team(team_id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT,
    FOREIGN KEY (event_id)
    REFERENCES `event`(event_id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
);

CREATE TABLE player_stat (
  stat_id INT PRIMARY KEY AUTO_INCREMENT,
  member_id INT NOT NULL,
  showing_id INT NOT NULL,
  acs INT,
  kda VARCHAR(20),
    FOREIGN KEY (member_id)
    REFERENCES `member`(member_id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT,
    FOREIGN KEY (showing_id)
    REFERENCES showing(showing_id)
      ON UPDATE RESTRICT
      ON DELETE RESTRICT
);

DELETE FROM `organization` WHERE org_id=1;

UPDATE `member` 
SET country_id=12
WHERE member_id=1;

SELECT `member`.ign AS 'Team Member', online_platform.platform_name AS 'Social Media', `account`.url AS 'Link' 
FROM `member` 
JOIN `account` ON `member`.member_id=`account`.member_id
JOIN online_platform ON `account`.platform_id=online_platform.platform_id
ORDER BY `member`.ign;

CREATE VIEW agent_pool AS
SELECT `member`.ign AS 'player', agent.agent_name AS 'agent'
FROM `member` 
JOIN pick ON `member`.member_id=pick.member_id
JOIN agent ON pick.agent_id=agent.agent_id;

SET autocommit=0;
START TRANSACTION;
DELETE FROM team
WHERE team_id IN
(SELECT team_id
FROM member_to_team_to_role
WHERE team_id = 1);
DELETE FROM `event`
WHERE team_id IN
(SELECT team_id
FROM `event`
WHERE team_id = 1);
ROLLBACK;

DELIMITER $$

CREATE TRIGGER win_loss
    BEFORE INSERT
    ON showing 
    FOR EACH ROW
BEGIN
    IF NEW.win = 1 THEN
        SET NEW.loss = 0;
    ELSEIF NEW.loss = 1 THEN
        SET NEW.win = 0;
    END IF;
END$$    

DELIMITER $$;

SELECT * FROM `event` 
WHERE league_id=
(SELECT league_id FROM league
WHERE league.name='americas');

SELECT `event`.title AS `Event`, team.team_name AS `Team`, SUM(showing.win) AS `Total Wins`, SUM(showing.loss) AS `Total Losses`
FROM `event`
JOIN showing ON `event`.event_id = showing.event_id
JOIN team ON showing.team_id = team.team_id
GROUP BY `event`.title, team.team_name;

CREATE VIEW roster AS
SELECT team.team_name AS 'Team', CONCAT(`member`.f_name, ' ', `member`.l_name) AS 'Name', `member`.ign AS 'In Game Name', `role`.role_name AS 'Role'
FROM team
JOIN member_to_team_to_role ON team.team_id=member_to_team_to_role.team_id
JOIN `member` ON `member`.member_id=member_to_team_to_role.member_id
JOIN `role` ON `role`.role_id=member_to_team_to_role.role_id; 



