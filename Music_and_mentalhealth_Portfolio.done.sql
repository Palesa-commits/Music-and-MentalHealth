-- Calculate respondent count per age group
SELECT 
    age_group,
    COUNT(*) AS respondent_count
FROM
    music_and_mentalhealth
GROUP BY age_group;

-- Count the number of records for each combination of age group and favorite genre
SELECT 
    age_group, fav_genre, COUNT(*) AS genre_count
FROM
    music_and_mentalhealth
GROUP BY age_group, fav_genre
ORDER BY age_group, genre_count DESC;

-- Count the number of records for each music effect
SELECT 
    music_effects, COUNT(*) AS number
FROM
    music_and_mentalhealth
GROUP BY music_effects
ORDER BY number DESC;

-- Calculate total and average hours spent listening to music by age group
SELECT 
    age_group,
    COUNT(hours_per_day) AS total_hours_per_day,
    AVG(hours_per_day) AS avg_hours_per_day
FROM
    music_and_mentalhealth
GROUP BY age_group
ORDER BY avg_hours_per_day DESC;

-- Calculate average hours spent listening to music across streaming platforms
SELECT 
    primary_streaming_service,
    AVG(hours_per_day) AS avg_hours_per_day
FROM
    music_and_mentalhealth
GROUP BY primary_streaming_service
ORDER BY avg_hours_per_day DESC;

-- Create a view to summarize mental health-related insights by age group, music effects, and condition
CREATE VIEW mental_health_insights AS
    SELECT 
        age_group,
        primary_streaming_service,
        fav_genre,
        music_effects,
        COUNT(*) AS num_respondents,
        AVG(depression) AS average_depression_score,
        MAX(depression) AS max_depression_score,
        MIN(depression) AS min_depression_score,
        AVG(anxiety) AS average_anxiety_score,
        MAX(anxiety) AS max_anxiety_score,
        MIN(anxiety) AS min_anxiety_score,
        AVG(insomnia) AS average_insomnia_score,
        MAX(insomnia) AS max_insomnia_score,
        MIN(insomnia) AS min_insomnia_score,
        AVG(ocd) AS average_ocd_score,
        MAX(ocd) AS max_ocd_score,
        MIN(ocd) AS min_ocd_score
    FROM
        music_and_mentalhealth
    GROUP BY age_group, music_effects;

-- Retrieve specific insights for different conditions
SELECT 
    *
FROM
    mental_health_insights;

SELECT 
    *
FROM
    mental_health_insights
WHERE
    fav_genre = 'Video game music';

SELECT 
    *
FROM
    mental_health_insights
WHERE
    music_effects = 'Worsen';

SELECT 
    *
FROM
    mental_health_insights
WHERE
    age_group = '0-19';
    
-- Compare mental health scores and preferred music genres 
SELECT 
    AVG(depression) AS avg_depression_score,
    AVG(anxiety) AS avg_anxiety_score,
    AVG(insomnia) AS avg_insomnia_score,
    AVG(ocd) AS avg_ocd_score, 
    fav_genre
FROM
    music_and_mentalhealth
GROUP BY fav_genre
ORDER BY avg_depression_score DESC; 

-- Show the relationship between favourite genre and reported music effects
SELECT 
    fav_genre, COUNT(*) AS number_of_improved
FROM
    music_and_mentalhealth
WHERE
    music_effects = 'Improve'
GROUP BY fav_genre
ORDER BY number_of_improved DESC;

SELECT 
    fav_genre, COUNT(*) AS number_of_worsened
FROM
    music_and_mentalhealth
WHERE
    music_effects = 'Worsen'
GROUP BY fav_genre
ORDER BY number_of_worsened DESC;

-- Analyze relationship between mental health condittions and music listening hours
SELECT 
    hours_per_day, 
    AVG(depression) AS avg_depression,
    AVG(anxiety) AS avg_anxiety,
    AVG(insomnia) AS avg_insomnia
FROM
    music_and_mentalhealth
GROUP BY hours_per_day
ORDER BY hours_per_day DESC;

-- Compare mental health scores across different streaming services
SELECT 
    primary_streaming_service,
    AVG(depression) AS avg_depression_score,
    AVG(anxiety) AS avg_anxiety_score,
    AVG(insomnia) AS avg_insomnia_score,
    AVG(ocd) AS avg_ocd_score
FROM
    music_and_mentalhealth
GROUP BY primary_streaming_service
ORDER BY avg_depression_score DESC;

-- Stored function to get favorite genre description
DELIMITER //
CREATE FUNCTION get_fav_genre_description(genre VARCHAR(50)) RETURNS VARCHAR(50)
DETERMINISTIC 
BEGIN
    DECLARE description VARCHAR(50);
    CASE 
        WHEN genre = 'Classical' THEN SET description = 'Relaxing and soothing';
        WHEN genre = 'Rock' THEN SET description = 'Energetic and intense';
        WHEN genre = 'Pop' THEN SET description = 'Upbeat and catchy';
        WHEN genre = 'Jazz' THEN SET description = 'Smooth and improvisational';
        WHEN genre = 'Hip-hop' THEN SET description = 'Rhythmic and lyrical';
        ELSE SET description = 'Diverse and Unique';
    END CASE;
    RETURN description;
END //
DELIMITER ;

-- Select average mental health scores ,favorite genre and music effects with genre description
SELECT fav_genre,
    AVG(depression) AS avg_depression_score,
    AVG(anxiety) AS avg_anxiety_score,
    AVG(insomnia) AS avg_insomnia_score,
    AVG(ocd) AS avg_ocd_score,
    music_effects,
    GET_FAV_GENRE_DESCRIPTION(fav_genre) AS genre_description       -- Stored function to get favorite genre description
FROM
    music_and_mentalhealth
GROUP BY fav_genre
ORDER BY avg_depression_score desc;

-- Get descriptions for different favorite genres
SELECT 
    fav_genre,
    GET_FAV_GENRE_DESCRIPTION(fav_genre) AS genre_description,
    COUNT(*) AS count
FROM
    music_and_mentalhealth
GROUP BY fav_genre
ORDER BY count DESC;

-- Count respondents who listen to music while working, broken down by favourite genre 
SELECT 
    fav_genre,
    COUNT(*) AS number_that_listen_while_working,
    GET_FAV_GENRE_DESCRIPTION(fav_genre) AS genre_description
FROM
    music_and_mentalhealth
WHERE
    while_working = 'Yes'
GROUP BY fav_genre
ORDER BY number_that_listen_while_working DESC;

-- Count the number of records for each depression level
SELECT 
    depression, COUNT(*) AS depression_count
FROM
    music_and_mentalhealth
GROUP BY depression
ORDER BY depression;

-- Procedure to determine depression levels
DELIMITER // 
CREATE PROCEDURE Depression_Levels() 
BEGIN
    SELECT 
        depression, age_group,
        CASE
            WHEN depression <= 3 THEN 'Low'
            WHEN depression BETWEEN 4 AND 6 THEN 'Moderate'
            WHEN depression >= 7 THEN 'High'
            ELSE '-'
        END AS depression_level
    FROM
        music_and_mentalhealth;
END //
DELIMITER ;

-- Execute the Depression_Levels procedure
CALL Depression_Levels();
