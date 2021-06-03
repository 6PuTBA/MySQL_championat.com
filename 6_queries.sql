
SELECT CONCAT( 
	c_h.name,
	' - ',
	c_v.name,
	'  ',
	(SELECT COUNT(id) FROM goals WHERE match_id = 2 AND club_id = (SELECT visiting_club_id FROM matches WHERE id = 2)),
	' : ',
	(SELECT COUNT(id) FROM goals WHERE match_id = 2 AND club_id = (SELECT home_club_id FROM matches WHERE id = 2))) AS 'result match'
	FROM matches JOIN clubs AS c_h ON c_h.id = matches.home_club_id AND matches.id = 2
	JOIN clubs AS c_v ON c_v.id = matches.visiting_club_id AND matches.id = 2;
	
		
