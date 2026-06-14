-- SQLite CLI settings, adjust as needed for other database systems
.mode column
.headers on

-- ========================================
-- "workforce" composition
-- analyzes the overal demographic
-- makeup of the animal crossing community
-- ========================================

-- -------------------------------------------------------------------------------------------
/*
total headcount:
baseline measurement and understanding of the size of the community,
which is essential for making informed decisions across all areas of people
development
*/
SELECT COUNT(*) AS total_headcount
FROM villagers;

-- -------------------------------------------------------------------------------------------
/*
species and gender distribution:
informs which species are most and least common among villagers, as well
as the representation of each gender, which is useful for understanding the
diversity of the community and making informed decisions about inclusion and
representation which can inform diversity and affinity initiatives
*/
SELECT s.name AS species, COUNT(*) AS total,
    SUM(CASE WHEN v.gender = 'Female' THEN 1 ELSE 0 END) AS female,
    SUM(CASE WHEN v.gender = 'Male' THEN 1 ELSE 0 END) AS male
FROM villagers v
JOIN species s ON v.species_id = s.species_id
GROUP BY s.name
ORDER BY s.name;

-- -------------------------------------------------------------------------------------------
/*
personality distribution:
provides insight into the variation of personality types among villagers,
which informs efforts to create engaging, stimulating, and inclusive environments for all
*/
SELECT p.personality, COUNT(*) AS headcount
FROM villagers v
JOIN personalities p ON v.personality_id = p.personality_id
GROUP BY p.personality
ORDER BY headcount DESC;

-- -------------------------------------------------------------------------------------------
/*
gender balance:
given that personality types are unique to gender in this example,
how does the gender balance across the community interact with the
distribution of personality types? this insight can inform
efforts to create engaging and equitable environments and create a
whole picture of the community's composition, while also surfacing
underrepresentatino that gender counts alone may obscure
*/
SELECT v.gender, p.personality, COUNT(*) AS headcount,
    ROUND(COUNT(*) * 100.00 / (SELECT COUNT(*) FROM villagers), 2) AS percentage
FROM villagers v
JOIN personalities p ON v.personality_id = p.personality_id
GROUP BY v.gender, p.personality
ORDER BY v.gender, headcount DESC;
