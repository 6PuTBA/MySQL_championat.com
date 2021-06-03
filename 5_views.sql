#Турнирные таблицы турниров
CREATE VIEW RFPL_table AS
	SELECT name, 
		   matches_complited AS 'matches',
		   matches_win AS 'win', 
		   matches_draw AS 'draw',
		   matches_loose AS 'loose',
		   points
		FROM clubs JOIN tournaments_clubs 
			ON clubs.id = club_id AND tournament_id = 1 ORDER BY points DESC;		

SELECT * FROM goal_pass gp ;		
		
CREATE VIEW Cup_of_russia_table AS
	SELECT name, 
		   matches_complited AS 'matches',
		   matches_win AS 'win', 
		   matches_draw AS 'draw',
		   matches_loose AS 'loose',
		   points
		FROM clubs JOIN tournaments_clubs 
			ON clubs.id = club_id AND tournament_id = 2 ORDER BY points DESC;		

#Список лучших бомбардиров турнира
CREATE VIEW bombardiers AS
		SELECT CONCAT (first_name, ' ', last_name) AS player, 		
			clubs.name AS club,
			amplua,
			goals_scored,
			minutes_on_field / goals_scored AS 'min on goal',
			minutes_on_field AS 'minutes',
			matches_complited AS 'matches'
			FROM players JOIN clubs ON clubs.id = club_id 
				JOIN profile_players ON players.id = profile_players.player_id 
					JOIN tournaments_players ON players.id = tournaments_players.player_id 
					AND goals_scored > 0 AND tournament_id = 2 ORDER BY goals_scored DESC LIMIT 20;


#Список лучших распасовщиков турнира
CREATE VIEW passers AS
		SELECT CONCAT (first_name, ' ', last_name) AS player,
		clubs.name AS club,
		amplua,
		passes_complited AS passes
			FROM players JOIN clubs ON clubs.id = club_id 
				JOIN profile_players ON players.id = profile_players.player_id 
					JOIN tournaments_players ON players.id = tournaments_players.player_id 
					AND passes_complited > 0 AND tournament_id = 2 ORDER BY passes_complited DESC LIMIT 20;

				SELECT * FROM passers;
				
#Список лучших игроков турнира по системе гол + пас
CREATE VIEW goal_pass AS
		SELECT CONCAT (first_name, ' ', last_name) AS player, 		
			clubs.name AS club,
			amplua,
			goals_scored + passes_complited AS 'gol+pass',
			goals_scored AS 'goals',
			passes_complited AS passes,
			matches_complited AS 'matches'
			FROM players JOIN clubs ON clubs.id = club_id 
				JOIN profile_players ON players.id = profile_players.player_id 
					JOIN tournaments_players ON players.id = tournaments_players.player_id 
					AND goals_scored + passes_complited> 0 AND tournament_id = 1 
					ORDER BY goals_scored + passes_complited DESC LIMIT 20;

