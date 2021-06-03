DROP TABLE IF EXISTS clubs;
CREATE TABLE clubs (
	id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(255) NOT NULL,
	country VARCHAR(255),
	city VARCHAR(255),
	created_at DATETIME DEFAULT current_timestamp(),
    updated_at DATETIME DEFAULT current_timestamp() ON UPDATE current_timestamp()); 
   
CREATE INDEX clubs_name_idx ON clubs(name);


DROP TABLE IF EXISTS players;
CREATE TABLE players (
	id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	club_id INT UNSIGNED,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	patronymic VARCHAR(255) COMMENT 'Отчество',
	created_at DATETIME DEFAULT current_timestamp(),
    updated_at DATETIME DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  	CONSTRAINT players_club_id_fk FOREIGN KEY (club_id) 
  	REFERENCES clubs(id) ON DELETE SET NULL);

CREATE INDEX players_last_name_idx ON players(last_name);  
  

DROP TABLE IF EXISTS tournaments;
CREATE TABLE tournaments (
	id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(255) NOT NULL COMMENT 'Название турнира',
	type ENUM('cup','championat') NOT NULL COMMENT 'Тип турнира',
	date_start DATE COMMENT 'Дата начала турнира',
	date_finish DATE COMMENT 'Дата окончания турнира',
	created_at DATETIME DEFAULT current_timestamp(),
    updated_at DATETIME DEFAULT current_timestamp() ON UPDATE current_timestamp()); 
   
CREATE INDEX tournaments_name_idx ON tournaments(name);  


DROP TABLE IF EXISTS tournaments_clubs;
CREATE TABLE tournaments_clubs (
	tournament_id INT UNSIGNED NOT NULL,
	club_id INT UNSIGNED NOT NULL,
	matches_complited TINYINT UNSIGNED NOT NULL COMMENT 'Колличество проведенных матчей клубом в данном турнире',
	matches_win TINYINT UNSIGNED NOT NULL COMMENT 'Колличество выигранных матчей клубом в данном турнире',
	matches_draw TINYINT UNSIGNED NOT NULL COMMENT 'Колличество ничейных матчей клубом в данном турнире',
	matches_loose TINYINT UNSIGNED NOT NULL COMMENT 'Колличество проигранных матчей клубом в данном турнире',
	goals TINYINT UNSIGNED NOT NULL COMMENT 'Колличество забитых голов клубом в данном турнире',
	goals_against TINYINT UNSIGNED NOT NULL COMMENT 'Колличество пропущенных голов клубом в данном турнире',
	points TINYINT UNSIGNED NOT NULL COMMENT 'Колличество заработанных очков клубом в данном турнире',
	created_at DATETIME DEFAULT current_timestamp(),
    updated_at DATETIME DEFAULT current_timestamp() ON UPDATE current_timestamp(), 
	PRIMARY KEY (tournament_id,club_id),
	CONSTRAINT tournaments_clubs_tournament_id_fk FOREIGN KEY (tournament_id) 
   	REFERENCES tournaments(id) ON DELETE CASCADE,
   	CONSTRAINT tournaments_clubs_club_id_fk FOREIGN KEY (club_id) 
   	REFERENCES clubs(id) ON DELETE CASCADE);
 

DROP TABLE IF EXISTS profile_players;
CREATE TABLE profile_players(
	id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	player_id INT UNSIGNED NOT NULL,
	gender CHAR(1) NOT NULL,
	birthday DATE,
	country VARCHAR(255),
	number TINYINT UNSIGNED COMMENT 'Игровой номер игрока',
	amplua ENUM ('goalkeeper', 'defender', 'midfielder', 'forward') NOT NULL,
	height TINYINT UNSIGNED COMMENT 'Рост игрока',
	weight TINYINT UNSIGNED COMMENT 'Вес игрока',
	created_at DATETIME DEFAULT current_timestamp(),
    updated_at DATETIME DEFAULT current_timestamp() ON UPDATE current_timestamp(),
   	CONSTRAINT profile_players_player_id_fk FOREIGN KEY (player_id) 
   	REFERENCES players(id) ON DELETE CASCADE); 


DROP TABLE IF EXISTS referees;
CREATE TABLE referees (
	id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	patronymic VARCHAR(255),
	country VARCHAR(255),
	created_at DATETIME DEFAULT current_timestamp(),
    updated_at DATETIME DEFAULT current_timestamp() ON UPDATE current_timestamp());
 
   
DROP TABLE IF EXISTS stadiums;
CREATE TABLE stadiums (
	id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(255) COMMENT 'Название стадиона',
	city VARCHAR(255),
	capacity INT UNSIGNED COMMENT 'Вместимость стадиона',
	created_at DATETIME DEFAULT current_timestamp(),
    updated_at DATETIME DEFAULT current_timestamp() ON UPDATE current_timestamp());

   
DROP TABLE IF EXISTS matches;
CREATE TABLE matches (
	id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	home_club_id INT UNSIGNED NOT NULL,
	visiting_club_id INT UNSIGNED NOT NULL,
	tournament_id INT UNSIGNED NOT NULL,
	stadium_id INT UNSIGNED NOT NULL,
	referee_id INT UNSIGNED NOT NULL,
	start_time DATETIME NOT NULL COMMENT 'Дата и время начала матча',
	status ENUM ('not started', 'continue', 'finished') NOT NULL,
	created_at DATETIME DEFAULT current_timestamp(),
    updated_at DATETIME DEFAULT current_timestamp() ON UPDATE current_timestamp(),
	CONSTRAINT matches_home_club_id_fk FOREIGN KEY (home_club_id) 
   	REFERENCES clubs(id) ON DELETE NO ACTION,
   	CONSTRAINT matches_visiting_club_id_fk FOREIGN KEY (visiting_club_id) 
   	REFERENCES clubs(id) ON DELETE NO ACTION,
   	CONSTRAINT matches_tournament_id_fk FOREIGN KEY (tournament_id) 
   	REFERENCES tournaments(id) ON DELETE NO ACTION,
  	CONSTRAINT matches_stadium_id_fk FOREIGN KEY (stadium_id) 
   	REFERENCES stadiums(id) ON DELETE NO ACTION,
  	CONSTRAINT matches_referee_id_fk FOREIGN KEY (referee_id) 
   	REFERENCES referees(id) ON DELETE NO ACTION); 

   
DROP TABLE IF EXISTS matches_players;
CREATE TABLE matches_players (
	match_id INT UNSIGNED NOT NULL,
	player_id INT UNSIGNED NOT NULL,
	minute_in TINYINT UNSIGNED NOT NULL COMMENT 'Минута выхода игрока на поле',
	minute_out TINYINT UNSIGNED NOT NULL COMMENT 'Минута выхода игрока на поле',
	created_at DATETIME DEFAULT current_timestamp(),
    updated_at DATETIME DEFAULT current_timestamp() ON UPDATE current_timestamp(),
	PRIMARY KEY (match_id,player_id),
	CONSTRAINT matches_players_match_id_fk FOREIGN KEY (match_id) 
   	REFERENCES matches(id) ON DELETE NO ACTION,
  	CONSTRAINT matches_players_player_id_fk FOREIGN KEY (player_id) 
   	REFERENCES players(id) ON DELETE NO ACTION);


DROP TABLE IF EXISTS goals;
CREATE TABLE goals (
	id SERIAL PRIMARY KEY,
	match_id INT UNSIGNED NOT NULL,
	club_id INT UNSIGNED NOT NULL,
	player_id INT UNSIGNED NOT NULL,
	minute_scored TINYINT UNSIGNED NOT NULL COMMENT 'Минута на которой был забит гол',
    created_at DATETIME DEFAULT current_timestamp(),
    updated_at DATETIME DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    CONSTRAINT goals_match_id_fk FOREIGN KEY (match_id) 
  	REFERENCES matches(id) ON DELETE NO ACTION,
  	CONSTRAINT goals_club_id_fk FOREIGN KEY (club_id) 
  	REFERENCES clubs(id) ON DELETE NO ACTION,
  	CONSTRAINT goals_player_id_fk FOREIGN KEY (player_id) 
  	REFERENCES players(id) ON DELETE NO ACTION);
  

DROP TABLE IF EXISTS passes;
CREATE TABLE passes (
	id SERIAL PRIMARY KEY,
	match_id INT UNSIGNED NOT NULL,
	player_id INT UNSIGNED NOT NULL,
	minute_pass TINYINT UNSIGNED NOT NULL COMMENT 'Минута на которой был выполнен голевой пас',
    created_at DATETIME DEFAULT current_timestamp(),
    updated_at DATETIME DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    CONSTRAINT passes_match_id_fk FOREIGN KEY (match_id) 
  	REFERENCES matches(id) ON DELETE NO ACTION,
  	CONSTRAINT passes_player_id_fk FOREIGN KEY (player_id) 
  	REFERENCES players(id) ON DELETE NO ACTION);
 

DROP TABLE IF EXISTS cards;
CREATE TABLE cards (
	id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	match_id INT UNSIGNED NOT NULL,
	club_id INT UNSIGNED NOT NULL,
	player_id INT UNSIGNED NOT NULL,
	color ENUM ('yellow', 'red') COMMENT 'Вид карточки', 
	minute_get TINYINT UNSIGNED NOT NULL COMMENT 'Минута на которой получена карточка',
	created_at DATETIME DEFAULT current_timestamp(),
    updated_at DATETIME DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    CONSTRAINT cards_match_id_fk FOREIGN KEY (match_id) 
  	REFERENCES matches(id) ON DELETE NO ACTION,
  	CONSTRAINT cards_club_id_fk FOREIGN KEY (club_id) 
  	REFERENCES clubs(id) ON DELETE NO ACTION,
  	CONSTRAINT cards_player_id_fk FOREIGN KEY (player_id) 
  	REFERENCES players(id) ON DELETE NO ACTION);
 

DROP TABLE IF EXISTS statistic_matches;
CREATE TABLE statistic_matches (
	match_id INT UNSIGNED NOT NULL,
	club_id INT UNSIGNED NOT NULL,
	attempts TINYINT UNSIGNED COMMENT 'Колличество ударов',
	attempts_on_target TINYINT UNSIGNED COMMENT 'Колличество ударов в створ ворот',
	fouls TINYINT UNSIGNED COMMENT 'Колличество фолов',
	corners TINYINT UNSIGNED COMMENT 'Колличество угловых',
	offcides TINYINT UNSIGNED COMMENT 'Колличество оффсайдов',
	posessions TINYINT UNSIGNED COMMENT 'Процент владения мячом',
	attempts_blocked TINYINT UNSIGNED COMMENT 'Колличество заблокированных ударов',
	free_kicks TINYINT UNSIGNED COMMENT 'Колличество штрафных ударов',
	goal_kicks TINYINT UNSIGNED COMMENT 'Колличество ударов от ворот',
	outs TINYINT UNSIGNED COMMENT 'Колличество аутов', 
	created_at DATETIME DEFAULT current_timestamp(),
    updated_at DATETIME DEFAULT current_timestamp() ON UPDATE current_timestamp(),
	PRIMARY KEY (match_id,club_id),
	CONSTRAINT statistic_matches_match_id_fk FOREIGN KEY (match_id) 
   	REFERENCES matches(id) ON DELETE NO ACTION,
  	CONSTRAINT statistic_matches_club_id_fk FOREIGN KEY (club_id) 
   	REFERENCES clubs(id) ON DELETE NO ACTION);
 
   
DROP TABLE IF EXISTS tournaments_players;
CREATE TABLE tournaments_players (
	tournament_id INT UNSIGNED NOT NULL,
	player_id INT UNSIGNED NOT NULL,
	matches_complited TINYINT UNSIGNED NOT NULL COMMENT 'Колличество сыгранных матчей',
	matches_in_start TINYINT UNSIGNED NOT NULL COMMENT 'Колличество матчей в основе',
	matches_on_replace TINYINT UNSIGNED NOT NULL COMMENT 'Колличество матчей в которых игрок вышел на замену',
	matches_replaced TINYINT UNSIGNED NOT NULL COMMENT 'Колличество матчей в которых игрок был заменен',
	matches_in_reserve TINYINT UNSIGNED NOT NULL COMMENT 'Колличество матчей в запасе',
	minutes_on_field INT UNSIGNED NOT NULL COMMENT 'Колличество минут на поле',
	goals_scored TINYINT UNSIGNED NOT NULL COMMENT 'Колличество голов забил игрок',
	goals_conceded TINYINT UNSIGNED NOT NULL COMMENT 'Колличество голов пропущено, если амплуа goalkeeper',
	passes_complited TINYINT UNSIGNED NOT NULL COMMENT 'Колличество голевых пасов',
	yellow_cards TINYINT UNSIGNED NOT NULL COMMENT 'Колличество полученных желтных карточек',
	red_cards TINYINT UNSIGNED NOT NULL COMMENT 'Колличество полученных красных карточек',
	created_at DATETIME DEFAULT current_timestamp(),
    updated_at DATETIME DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    PRIMARY KEY (tournament_id,player_id),   	
    CONSTRAINT tournaments_players_tournament_id_fk FOREIGN KEY (tournament_id) 
   	REFERENCES tournaments(id) ON DELETE CASCADE,
  	CONSTRAINT tournaments_players_player_id_fk FOREIGN KEY (player_id) 
   	REFERENCES players(id) ON DELETE CASCADE);

	
DROP TABLE IF EXISTS media;
CREATE TABLE media (
	id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(255) NOT NULL UNIQUE COMMENT 'Ссылка на файл',
	type ENUM ('image', 'video'),
	created_at DATETIME DEFAULT current_timestamp(),
    updated_at DATETIME DEFAULT current_timestamp() ON UPDATE current_timestamp());


DROP TABLE IF EXISTS authors;
CREATE TABLE authors (
	id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	patronymic VARCHAR(255),
	created_at DATETIME DEFAULT current_timestamp(),
    updated_at DATETIME DEFAULT current_timestamp() ON UPDATE current_timestamp());

   
DROP TABLE IF EXISTS articles;
CREATE TABLE articles (
	id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	author_id INT UNSIGNED NOT NULL,
	media_id INT UNSIGNED NOT NULL, 
	date_publication DATETIME,
	head TEXT NOT NULL,
	body TEXT NOT NULL,
	created_at DATETIME DEFAULT current_timestamp(),
    updated_at DATETIME DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    CONSTRAINT posts_author_id_fk FOREIGN KEY (author_id) 
   	REFERENCES authors(id) ON DELETE NO ACTION,
  	CONSTRAINT posts_media_id_fk FOREIGN KEY (media_id) 
   	REFERENCES media(id) ON DELETE NO ACTION);


	

	
	