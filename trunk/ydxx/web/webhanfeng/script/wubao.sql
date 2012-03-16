DELIMITER //
CREATE PROCEDURE t8()
BEGIN
    DECLARE v INT;
    DECLARE uid INT;
    DECLARE p INT;
    DECLARE f INT;
    DECLARE xx INT;
    DECLARE yy INT;
    DECLARE fen INT;
    DECLARE st INT;
    
    SET v = 1;
    SET p = 2500;
    SET f = 500;
    WHILE v < 144 DO
        SET fen = (SELECT is_alloted FROM hf_city WHERE id = v);
        IF fen = 1 THEN
            SET xx = (SELECT X FROM hf_city WHERE id = v);
            SET yy = (SELECT Y FROM hf_city WHERE id = v);
            SET st = 0;
            WHILE st < 120 DO
                INSERT INTO hf_wubao (city_id, people, family,prestige,X,Y,money,food,wood,iron,skin,gongxun) VALUES (v, p,f,1000,xx,yy,300000,40000,0,5000,0,100);
                SET st = st + 1;
            END WHILE;
        END IF;
        SET v = v + 1;
    END WHILE;
END;//

CALL t8()//
DROP PROCEDURE t8//