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

INSERT INTO league VALUES (NULL, 'americas', NULL);
INSERT INTO league VALUES (NULL, 'china', NULL);
INSERT INTO league VALUES (3, 'pacific', 'APAC');
INSERT INTO league VALUES (NULL, 'europe, middle east, and africa', 'EMEA');
INSERT INTO league VALUES (NULL, 'oceania', 'OCE');

INSERT INTO tier VALUES (NULL, 'Valorant Champions Tour', 'VCT', 'VALORANT Champions Tour (VCT) is the game’s Tier 1 competition, and is made up of four territories: Americas, EMEA, APAC, and China. Over the course of the 2025 season, teams participate in a series of regional and international events that culminate at the final international event, Champions, where the best team in the world is crowned.');
INSERT INTO tier VALUES (NULL, 'Challengers', NULL, 'Providing aspirational goals is imperative to ensuring the most talented teams and pros in esports select VALORANT as the game where they dedicate their time and effort. Next year, Challenger leagues within each of the three territories will culminate in a new event series that will crown the best team in their territory. Teams who secure victory at the three Challengers Ascension tournaments will earn a spot in the following year’s international league.');
INSERT INTO tier VALUES (NULL, 'Game Changers', 'GC', 'VCT Game Changers is a new program which will supplement the competitive season by creating new opportunities and exposure for women and other marginalized genders within VALORANT esports. The competitive VALORANT community is both diverse and incredibly global, and our esport should reflect that. Through Game Changers, we hope to build towards a VALORANT Champions Tour that is more inclusive and representative of our community.');
INSERT INTO tier VALUES (NULL, 'Premier', NULL, 'Valorant Premier is a structured, tournament-based game mode in VALORANT where teams compete in a tiered system, earning points and potentially qualifying for playoffs. Its designed to be a stepping stone for aspiring pro players and provides a more engaging experience for players who enjoy organized team play.');
INSERT INTO tier VALUES (NULL, 'Collegiate', NULL, 'College VALORANT is organized by Riot Games and the Riot Scholastic Association of America in association with third party organizers to give opportunities and scholarships to college/university students across North America.');

INSERT INTO `role` VALUES (NULL, 'player', 'actively competes on the team');
INSERT INTO `role` VALUES (NULL, 'igl', 'player who leads team/shot calls');
INSERT INTO `role` VALUES (NULL, 'sixth man', 'alternate player, does not actively compete');
INSERT INTO `role` VALUES (NULL, 'head coach', 'coaches team');
INSERT INTO `role` VALUES (NULL, 'assistant coach', 'assists head coach with coaching team');

INSERT INTO online_platform VALUES (NULL, 'twitch', 'a live streaming platform primarily focused on video games, but also featuring music, creative content, and "in real life" (IRL) streams.', 'https://www.twitch.tv/');
INSERT INTO online_platform VALUES (NULL, 'x', 'Twitter, Inc. was an American social media company based in San Francisco, California, which operated and was named for its flagship social media network prior to its rebrand as X', 'https://x.com/');
INSERT INTO online_platform VALUES (NULL, 'instagram', 'a free, online photo and video sharing app and social networking platform.', 'https://www.instagram.com/');
INSERT INTO online_platform VALUES (NULL, 'youtube', 'a video sharing service where users can watch, like, share, comment and upload their own videos.', 'https://www.youtube.com/');
INSERT INTO online_platform VALUES (NULL, 'tiktok', 'a social media platform for creating, sharing and discovering short videos.', 'https://www.tiktok.com/en/');

INSERT INTO country VALUES (NULL, 'United States of America');
INSERT INTO country VALUES (NULL, 'Canada');
INSERT INTO country VALUES (NULL, 'Brazil');
INSERT INTO country VALUES (NULL, 'Argentina');
INSERT INTO country VALUES (NULL, 'China');
INSERT INTO country VALUES (NULL, 'Morocco');

INSERT INTO class VALUES (NULL, 'Sentinel', 'defensive experts who can lock down areas and watch flanks, both on attacker and defender rounds.');
INSERT INTO class VALUES (NULL, 'Controller', 'experts in slicing up dangerous territory to set their team up for success.');
INSERT INTO class VALUES (NULL, 'Initiator', 'challenge angles by setting up their team to enter contested ground and push defenders away.');
INSERT INTO class VALUES (NULL, 'Dualist', 'self-sufficient fraggers who their team expects, through abilities and skills, to get high frags and seek out engagements first.');
/*there are only four classes!*/

INSERT INTO city VALUES (NULL, 'Los Angeles');
INSERT INTO city VALUES (NULL, 'Toronto');
INSERT INTO city VALUES (NULL, 'Sao Paolo');
INSERT INTO city VALUES (NULL, 'Madrid');
INSERT INTO city VALUES (NULL, 'Beijing');
INSERT INTO city VALUES (NULL, 'Bangkok');

INSERT INTO `organization` VALUES (NULL, 'Sentinels', 1 , 'Rob', 'Moore', '2016');
INSERT INTO `organization` VALUES (NULL, '100 Thieves', 1 , 'Matthew', 'Haag', '2017');
INSERT INTO `organization` VALUES (NULL, 'NRG Esports', 1 , 'Andy', 'Miller', '2015');
INSERT INTO `organization` VALUES (NULL, 'Made In Brazil', 1 , 'Paulo', 'Velloso', '2003');
INSERT INTO `organization` VALUES (NULL, 'Kru Esports', 1 , 'Sergio', 'Agüero', '2020');

INSERT INTO team VALUES (NULL, 2, 'Sentinels', 'SEN', NULL, 1);
INSERT INTO team VALUES (NULL, 3, '100 Thieves', '100T', NULL, 1);
INSERT INTO team VALUES (NULL, 4, 'NRG', 'NRG', NULL, 1);
INSERT INTO team VALUES (NULL, 5, 'Made In Brazil', 'MIBR', NULL, 1);
INSERT INTO team VALUES (NULL, 6, 'Visa Kru', 'KRÜ', NULL, 1);

INSERT INTO `member` VALUES (NULL, 'johnqt', 'Mohamed Amine', 'Ouarid', 19980921, 1, NULL, NULL);
INSERT INTO `member` VALUES (NULL, 'zellsis', 'Jordan', 'Montemurro', 19980302, 1, NULL, NULL);
INSERT INTO `member` VALUES (NULL, 'zekken', 'Zachary', 'Patrone', 20050319, 1, NULL, NULL);
INSERT INTO `member` VALUES (NULL, 'kaplan', 'Adam', 'Kaplan', 19940712, 1, NULL, NULL);
INSERT INTO `member` VALUES (NULL, 'reduxx', 'Yasseen', 'Aboulalazm', 20070423, 1, NULL, NULL);

INSERT INTO member_to_team_to_role VALUES (NULL, 1, 2, 2, 20230913, NULL);
INSERT INTO member_to_team_to_role VALUES (NULL, 2, 2, 1, 20240209, NULL);
INSERT INTO member_to_team_to_role VALUES (NULL, 3, 2, 1, 20221005, NULL);
INSERT INTO member_to_team_to_role VALUES (NULL, 4, 2, 4, 20230416, NULL);
INSERT INTO member_to_team_to_role VALUES (NULL, 5, 2, 3, 20241011, NULL);

INSERT INTO `account` VALUES (NULL, 1, 1, 'johnqtcs', 'https://www.twitch.tv/johnqtcs');
INSERT INTO `account` VALUES (NULL, 2, 1, 'zellsis', 'https://www.twitch.tv/zellsis');
INSERT INTO `account` VALUES (NULL, 3, 1, 'zekken', 'https://www.twitch.tv/zekken');
INSERT INTO `account` VALUES (NULL, 1, 3, '1johnqt', 'https://www.instagram.com/1johnqt/?hl=en');
INSERT INTO `account` VALUES (NULL, 3, 4, 'zekkenVAL', 'https://www.youtube.com/@zekkenVAL');

INSERT INTO agent VALUES (NULL, 'Tejo', 3, 'A veteran intelligence consultant from Colombia, Tejos ballistic guidance system pressures the enemy to relinquish their ground - or their lives. His targeted strikes keep opponents off balance and under his heel.');
INSERT INTO agent VALUES (NULL, 'Breach', 3, 'Breach, the bionic Swede, fires powerful, targeted kinetic blasts to aggressively clear a path through enemy ground. The damage and disruption he inflicts ensures no fight is ever fair.');
INSERT INTO agent VALUES (NULL, 'Viper', 2, 'The American Chemist, Viper deploys an array of poisonous chemical devices to control the battlefield and choke the enemys vision. If the toxins dont kill her prey, her mindgames surely will.');
INSERT INTO agent VALUES (NULL, 'Jett', 4, 'Representing her home country of South Korea, Jetts agile and evasive fighting style lets her take risks no one else can. She runs circles around every skirmish, cutting enemies before they even know what hit them.');
INSERT INTO agent VALUES (NULL, 'Cypher', 1, 'The Moroccan information broker, Cypher is a one-man surveillance network who keeps tabs on the enemys every move. No secret is safe. No maneuver goes unseen. Cypher is always watching.');

INSERT INTO pick VALUES (NULL, 1, 1);
INSERT INTO pick VALUES (NULL, 1, 2);
INSERT INTO pick VALUES (NULL, 2, 3);
INSERT INTO pick VALUES (NULL, 2, 5);
INSERT INTO pick VALUES (NULL, 3, 4);

INSERT INTO `event` VALUES (NULL, 'Champions Tour 2025: Americas Stage 1', NULL, 1, 1, 1, 20250321, 20250504, NULL);
INSERT INTO `event` VALUES (NULL, 'Champions Tour 2025: Masters Bangkok', 500000, NULL, NULL, 6, 20250220, 20250302, NULL);
INSERT INTO `event` VALUES (NULL, 'Champions Tour 2024: Americas Stage 1', 0, 1, 1, 1, 20240406, 20240512, 2);
INSERT INTO `event` VALUES (NULL, 'Champions Tour 2024: Americas Kickoff', 0, 1, 1, 1, 20240216, 20240303, 1);
INSERT INTO `event` VALUES (NULL, 'Champions Tour 2024: China Stage 2', NULL, 2, 5, NULL, 20240615, 20240721, NULL);

INSERT INTO showing VALUES (NULL, 1, 1, 1, 0, 20250424071500);
INSERT INTO showing VALUES (NULL, 2, 1, 0, 1, 20250424050000);
INSERT INTO showing VALUES (NULL, 4, 1, 1, 0, 20250424050000);
INSERT INTO showing VALUES (NULL, 2, 1, 0, 1, 20250425050000);
INSERT INTO showing VALUES (NULL, 3, 1, 1, 0, 20250425050000);
INSERT INTO showing VALUES (NULL, 1, 1, 1, 0, 20250502050000);
INSERT INTO showing VALUES (NULL, 4, 1, 0, 1, 20250502050000);

INSERT INTO player_stat VALUES (NULL, 1, 1, 207, 33/28/16);
INSERT INTO player_stat VALUES (NULL, 2, 1, 175, 29/27/12);
INSERT INTO player_stat VALUES (NULL, 3, 1, 275, 45/32/9);
INSERT INTO player_stat VALUES (NULL, 1, 6, 204, 32/23/20);
INSERT INTO player_stat VALUES (NULL, 3, 6, 313, 49/27/9);



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



