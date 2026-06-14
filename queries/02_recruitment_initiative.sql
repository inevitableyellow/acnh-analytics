-- SQLite CLI settings, adjust as needed for other database systems
.mode column
.headers on

-- ========================================================================
-- "recruitment" initiative
-- identifies underrepresented personality types among villagers,
-- informing targeted efforts to "recruit" and retain
-- villagers with those traits which ensures a diverse and
-- inclusive community that reflects a wide range of personalities,
-- perspectives, and experiences
-- ========================================================================

-- -------------------------------------------------------------------------------------------
/* personality diversity:
analyzes the distribution of personality types among villagers,
as well as the percentage representation of each personality type
*/
WITH personality_diversity AS (
    SELECT s.name AS species,
           COUNT(DISTINCT p.personality) AS personality_types,

           -- out of 100%, where 8 is the total number of unique personality types
           ROUND(COUNT(DISTINCT p.personality) * 100.0 / 8, 1) AS pct_personality_coverage,
           COUNT(*) AS total_villagers,
           SUM(CASE WHEN v.gender = 'Female' THEN 1 ELSE 0 END) AS female,
           SUM(CASE WHEN v.gender = 'Male' THEN 1 ELSE 0 END) AS male
    FROM villagers v
    JOIN species s ON v.species_id = s.species_id
    JOIN personalities p ON v.personality_id = p.personality_id
    GROUP BY s.name
)
SELECT species,
       personality_types,
       pct_personality_coverage,
       total_villagers,
       female,
       male,

       /* recruitment priority:
       ranks species based on their personality diversity (pct_personality_coverage) and the
       number of unique personality types (personality_types), which informs targeted efforts
       to "recruit" and "retain" certain villagers (which is actually a main aim of many
       players of the game, curation of a diverse and interesting village is typically a key
       goal) */
       RANK() OVER (ORDER BY pct_personality_coverage ASC, personality_types ASC) AS recruitment_priority
FROM personality_diversity
ORDER BY recruitment_priority ASC;

-- -------------------------------------------------------------------------------------------
/* personality and gender diversity:
analyzes the specific impact of gender on the distribution of personality types and
recruitment priority among villagers, targeting which personalities and genders are
missing per species
*/
WITH all_combinations AS (
    SELECT s.name AS species, p.personality,
           MAX(v.gender) AS gender -- gender is consistent per personality so MAX is ok here
    FROM species s
    CROSS JOIN personalities p
    JOIN villagers v ON v.personality_id = p.personality_id
    GROUP BY s.name, p.personality
),
existing_combinations AS (
    SELECT DISTINCT s.name AS species, p.personality
    FROM villagers v
    JOIN species s on v.species_id = s.species_id
    JOIN personalities p on v.personality_id = p.personality_id
)
SELECT a.species, a.personality, a.gender
FROM all_combinations a
LEFT JOIN existing_combinations e ON a.species = e.species AND a.personality = e.personality
WHERE e.species IS NULL
ORDER BY a.species, a.personality;

-- -------------------------------------------------------------------------------------------
/* targeted groups:
synthesizes the insights from previous analyses to identify specific species and personality
combinations that are underrepresented and should be prioritized for "recruitment" efforts
*/
WITH personality_diversity AS (
    SELECT s.name AS species,
           COUNT(DISTINCT p.personality) AS personality_types,
           ROUND(COUNT(DISTINCT p.personality) * 100.0 / 8, 1) AS pct_personality_coverage,  -- out of 100%, where 8 is the total number of unique personality types
           COUNT(*) AS total_villagers,
           SUM(CASE WHEN v.gender = 'Female' THEN 1 ELSE 0 END) AS female,
           SUM(CASE WHEN v.gender = 'Male' THEN 1 ELSE 0 END) AS male,
           ROUND(ABS(SUM(CASE WHEN v.gender = 'Female' THEN 1 ELSE 0 END) -
                     SUM(CASE WHEN v.gender = 'Male' THEN 1 ELSE 0 END)) * 1.0 / COUNT(*) , 2) AS gender_imbalance_ratio,
           ROUND(ABS(COUNT(DISTINCT p.personality) - 8) * 1.0 / 8, 2) AS personality_gap_ratio
    FROM villagers v
    JOIN species s ON v.species_id = s.species_id
    JOIN personalities p ON v.personality_id = p.personality_id
    GROUP BY s.name
)
SELECT species,
       gender_imbalance_ratio,
       personality_gap_ratio,
       ROUND(gender_imbalance_ratio + personality_gap_ratio, 2) AS recruitment_score
FROM personality_diversity
ORDER BY recruitment_score DESC;