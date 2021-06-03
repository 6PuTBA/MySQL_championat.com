DELIMITER //

# Добавление статистики игрока в таблицу tournaments_players
DROP TRIGGER IF EXISTS add_player_in_tournament // 
CREATE TRIGGER add_player_in_tournament AFTER INSERT ON matches_players
FOR EACH ROW
BEGIN
	IF 
		(SELECT NOT EXISTS(SELECT 1 FROM tournaments_players WHERE player_id = NEW.player_id 
		AND tournament_id = (SELECT tournament_id FROM matches WHERE id = NEW.match_id))) 
	THEN
		INSERT INTO tournaments_players (tournament_id,player_id,matches_complited,
	matches_in_start,matches_on_replace,matches_replaced,matches_in_reserve,goals_scored,goals_conceded,
	passes_complited,yellow_cards,red_cards,minutes_on_field) 
		VALUES ((SELECT tournament_id FROM matches WHERE id = NEW.match_id), NEW.player_id, 
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0); 
	END IF;
	IF
		NEW.minute_in = 0 AND NEW.minute_out != 0 THEN 
		UPDATE tournaments_players SET matches_in_start = matches_in_start + 1
		WHERE player_id = NEW.player_id 
		AND tournament_id = (SELECT tournament_id FROM matches WHERE id = NEW.match_id);
		IF
			NEW.minute_in = 0 AND NEW.minute_out BETWEEN 1 AND 89 THEN 
			UPDATE tournaments_players SET matches_replaced = matches_replaced + 1
			WHERE player_id = NEW.player_id 
			AND tournament_id = (SELECT tournament_id FROM matches WHERE id = NEW.match_id);
		END IF;
	ELSEIF
			NEW.minute_in != 0 AND NEW.minute_out != 0 THEN 
			UPDATE tournaments_players SET matches_on_replace = matches_on_replace + 1
			WHERE player_id = NEW.player_id 
			AND tournament_id = (SELECT tournament_id FROM matches WHERE id = NEW.match_id);
	ELSEIF
			NEW.minute_in = 0 AND NEW.minute_out = 0 THEN 
			UPDATE tournaments_players SET matches_in_reserve = matches_in_reserve + 1
			WHERE player_id = NEW.player_id 
			AND tournament_id = (SELECT tournament_id FROM matches WHERE id = NEW.match_id);
	END IF;	
	UPDATE tournaments_players SET matches_complited = matches_complited + 1
		WHERE player_id = NEW.player_id 
		AND tournament_id = (SELECT tournament_id FROM matches WHERE id = NEW.match_id);
	UPDATE tournaments_players SET minutes_on_field = minutes_on_field + NEW.minute_out - NEW.minute_in
		WHERE player_id = NEW.player_id 
		AND tournament_id = (SELECT tournament_id FROM matches WHERE id = NEW.match_id);
END//	


# Вызов процедуры подсчета результатов после окончания матча
DELIMITER //

DROP TRIGGER IF EXISTS add_matches_in_tournaments_clubs // 
CREATE TRIGGER add_matches_in_tournaments_clubs AFTER UPDATE ON matches
FOR EACH ROW
BEGIN
	IF NEW.status = 'finished'
	THEN
		CALL add_inform_in_tournaments_clubs(NEW.id);
	END IF;
END//	 

# Добавление голов в статистику игроков и клубов
DELIMITER //

DROP TRIGGER IF EXISTS add_goal_in_stat // 
CREATE TRIGGER add_goal_in_stat AFTER INSERT ON goals
FOR EACH ROW
BEGIN
	UPDATE tournaments_players SET goals_scored = goals_scored + 1
	WHERE player_id = NEW.player_id 
	AND tournament_id = (SELECT tournament_id FROM matches WHERE id = NEW.match_id);
	UPDATE tournaments_clubs SET goals = goals + 1
	WHERE tournament_id = (SELECT tournament_id FROM matches WHERE id = NEW.match_id)	
	AND club_id = NEW.club_id;
	UPDATE tournaments_clubs SET goals_against = goals_against + 1
	WHERE tournament_id = (SELECT tournament_id FROM matches WHERE id = NEW.match_id)	
	AND club_id = (SELECT 
	IF((SELECT home_club_id FROM matches WHERE id = NEW.match_id) = NEW.club_id, visiting_club_id, home_club_id) 
	FROM matches WHERE id = NEW.match_id);
END//

#Добавление пасов в статистику игрока в турнире
DELIMITER //

DROP TRIGGER IF EXISTS add_pass_in_stat_player // 
CREATE TRIGGER add_pass_in_stat_player AFTER INSERT ON passes
FOR EACH ROW
BEGIN
	UPDATE tournaments_players SET passes_complited = passes_complited + 1
	WHERE player_id = NEW.player_id 
	AND tournament_id = (SELECT tournament_id FROM matches WHERE id = NEW.match_id);
END//

#Добавление карточек в статистику игрока в турнире
DELIMITER //

DROP TRIGGER IF EXISTS add_card_in_stat_player // 
CREATE TRIGGER add_card_in_stat_player AFTER INSERT ON cards
FOR EACH ROW
BEGIN
	IF NEW.color = 'yellow' THEN
		UPDATE tournaments_players SET yellow_cards = yellow_cards + 1
		WHERE player_id = NEW.player_id 
		AND tournament_id = (SELECT tournament_id FROM matches WHERE id = NEW.match_id);
	ELSEIF NEW.color = 'red' THEN
		UPDATE tournaments_players SET red_cards = red_cards + 1
		WHERE player_id = NEW.player_id 
		AND tournament_id = (SELECT tournament_id FROM matches WHERE id = NEW.match_id);
	END IF;
END//