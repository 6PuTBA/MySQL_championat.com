DELIMITER //
DROP PROCEDURE IF EXISTS add_inform_in_tournaments_clubs //
CREATE PROCEDURE add_inform_in_tournaments_clubs(IN _id INT)
BEGIN
		UPDATE tournaments_clubs SET matches_complited = matches_complited + 1
		WHERE tournament_id = (SELECT tournament_id FROM matches WHERE matches.id = _id)	
		AND club_id = (SELECT home_club_id FROM matches WHERE id = _id);
		UPDATE tournaments_clubs SET matches_complited = matches_complited + 1
		WHERE tournament_id = (SELECT tournament_id FROM matches WHERE matches.id = _id)	
		AND club_id = (SELECT visiting_club_id FROM matches WHERE id = _id);
		IF 
			(SELECT COALESCE ((SELECT COUNT(*) FROM goals WHERE match_id = _id AND club_id = 
			(SELECT home_club_id FROM matches WHERE id = _id) GROUP BY club_id), 0)) >
			(SELECT COALESCE ((SELECT COUNT(*) FROM goals WHERE match_id = _id AND club_id = 
			(SELECT visiting_club_id FROM matches WHERE id = _id) GROUP BY club_id), 0))
		THEN 
			UPDATE tournaments_clubs SET matches_win = matches_win + 1
			WHERE tournament_id = (SELECT tournament_id FROM matches WHERE matches.id = _id)	
			AND club_id = (SELECT home_club_id FROM matches WHERE id = _id);
			UPDATE tournaments_clubs SET matches_loose = matches_loose + 1
			WHERE tournament_id = (SELECT tournament_id FROM matches WHERE matches.id = _id)	
			AND club_id = (SELECT visiting_club_id FROM matches WHERE id = _id);
			IF 
				(SELECT type FROM tournaments JOIN matches 
				ON tournaments.id = tournament_id WHERE matches.id =_id) = 'championat' 
			THEN 
				UPDATE tournaments_clubs SET points = points + 3
				WHERE tournament_id = (SELECT tournament_id FROM matches WHERE matches.id = _id)	
				AND club_id = (SELECT home_club_id FROM matches WHERE id = _id);
			END IF;			
		ELSEIF
			(SELECT COALESCE ((SELECT COUNT(*) FROM goals WHERE match_id = _id AND club_id = 
			(SELECT home_club_id FROM matches WHERE id = _id) GROUP BY club_id), 0)) =
			(SELECT COALESCE ((SELECT COUNT(*) FROM goals WHERE match_id = _id AND club_id = 
			(SELECT visiting_club_id FROM matches WHERE id = _id) GROUP BY club_id), 0))
		THEN 
			UPDATE tournaments_clubs SET matches_draw = matches_draw + 1
			WHERE tournament_id = (SELECT tournament_id FROM matches WHERE matches.id = _id)	
			AND club_id = (SELECT home_club_id FROM matches WHERE id = _id);
			UPDATE tournaments_clubs SET matches_draw = matches_draw + 1
			WHERE tournament_id = (SELECT tournament_id FROM matches WHERE matches.id = _id)	
			AND club_id = (SELECT visiting_club_id FROM matches WHERE id = _id);
			IF 
				(SELECT type FROM tournaments JOIN matches 
				ON tournaments.id = tournament_id WHERE matches.id =_id) = 'championat' 
			THEN 
				UPDATE tournaments_clubs SET points = points + 1
				WHERE tournament_id = (SELECT tournament_id FROM matches WHERE matches.id = _id)	
				AND club_id = (SELECT visiting_club_id FROM matches WHERE id = _id);
				UPDATE tournaments_clubs SET points = points + 1
				WHERE tournament_id = (SELECT tournament_id FROM matches WHERE matches.id = _id)	
				AND club_id = (SELECT home_club_id FROM matches WHERE id = _id);
			END IF;
		ELSE
			UPDATE tournaments_clubs SET matches_loose = matches_loose + 1
			WHERE tournament_id = (SELECT tournament_id FROM matches WHERE matches.id = _id)	
			AND club_id = (SELECT home_club_id FROM matches WHERE id = _id);
			UPDATE tournaments_clubs SET matches_win = matches_win + 1
			WHERE tournament_id = (SELECT tournament_id FROM matches WHERE matches.id = _id)	
			AND club_id = (SELECT visiting_club_id FROM matches WHERE id = _id);
			IF 
				(SELECT type FROM tournaments JOIN matches 
				ON tournaments.id = tournament_id WHERE matches.id =_id) = 'championat' 
			THEN 
				UPDATE tournaments_clubs SET points = points + 3
				WHERE tournament_id = (SELECT tournament_id FROM matches WHERE matches.id = _id)	
				AND club_id = (SELECT visiting_club_id FROM matches WHERE id = _id);
			END IF;
		END IF;
END //