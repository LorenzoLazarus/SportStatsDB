USE master
IF EXISTS(select * from sys.databases where name='SportStatsDB')
DROP DATABASE SportStatsDB

CREATE DATABASE SportStatsDB;
GO

USE TestDB;
GO

CREATE TABLE Manager(
    manager_id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	first_name varchar(120) NOT NULL,
	last_name varchar(120) NOT NULL,
    date_of_birth date NOT NULL,
    country_0f_birth varchar(120) NOT NULL,
);
GO

CREATE TABLE Country (
	country_id [int] IDENTITY(1,1) NOT NULL,
	country_name varchar(100) NOT NULL,
	flag varchar(200) NULL,
	CONSTRAINT pk_country PRIMARY KEY CLUSTERED 
	(
		country_id ASC
	)
);
GO

CREATE TABLE League(
	league_id int IDENTITY(1,1) NOT NULL,
	league_name varchar(50) NOT NULL,
	country_id int FOREIGN KEY REFERENCES Country(country_id) NOT NULL,
	logo varchar(200) NULL,
	CONSTRAINT pk_league PRIMARY KEY CLUSTERED 
	(
		league_id ASC
	)
);
GO

CREATE TABLE Stadium(
    stadium_id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	stadium_name varchar (120) NOT NULL,
	stadium_capacity int NOT NULL,
);
GO

CREATE TABLE Team(
    team_id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	manager_id int FOREIGN KEY REFERENCES Manager(manager_id) NOT NULL,
	league_id int FOREIGN KEY REFERENCES League(league_id) NOT NULL,
	stadium_id int FOREIGN KEY REFERENCES Stadium(stadium_id) NOT NULL,
	team_name VARCHAR(64) NOT NULL,
	no_of_players int NOT NULL,
	team_logo varchar(256) NOT NULL
);
GO

CREATE TABLE Team_Stats(
    team_league_id int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	team_id int FOREIGN KEY REFERENCES Team(team_id) NOT NULL,
	league_pos int NOT NULL,
	goals_against int NOT NULL,
	goals_for int NOT NULL,
	goal_diff int NOT NULL,
	points int NOT NULL,
	losses int NOT NULL,
	draws int NOT NULL,
	wins int NOT NULL,
	no_games_played int NOT NULL
);
GO

CREATE TABLE Position(
	position_id int IDENTITY(1,1) NOT NULL,
	position_name varchar(50) NOT NULL,
	CONSTRAINT pk_position PRIMARY KEY CLUSTERED 
	(
		position_id ASC
	)
);
GO

CREATE TABLE Player(player_id INT PRIMARY KEY,team_id INT NOT NULL,player_name VARCHAR(128) NOT NULL,height INT NOT NULL,photo VARCHAR(250) NOT NULL,injury_status INT NOT NULL,position_id INT NOT NULL,player_league_stats_id INT)
GO
CREATE TABLE Player_league_stats(player_league_stats_id INT PRIMARY KEY,league_id INT,goals INT NOT NULL,yellow_cards INT NOT NULL,red_cards INT NOT NULL,appearances INT NOT NULL)
GO
ALTER TABLE Player
    ADD CONSTRAINT fk_player_stats FOREIGN KEY(player_league_stats_id)
    REFERENCES Player_league_stats(player_league_stats_id)
GO



CREATE TABLE Match_Details (
	match_id INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
	home_team_id INT FOREIGN KEY REFERENCES Team(team_id) NOT NULL,
	away_team_id INT FOREIGN KEY REFERENCES Team(team_id) NOT NULL,
	league_id INT FOREIGN KEY REFERENCES League(league_id) NOT NULL,
	season INT NOT NULL CHECK (season > 1850 AND season < 2100),
	match_date DATE NOT NULL CHECK (match_date > '1850-01-01' AND match_date < '2100-01-01'),
	match_time TIME,
	stadium VARCHAR(128),
	home_goals TINYINT DEFAULT 0,
	away_goals TINYINT DEFAULT 0,
	referee VARCHAR(64),
	match_status VARCHAR(32) NOT NULL,
	CONSTRAINT distinct_teams CHECK (home_team_id <> away_team_id)
);
GO
