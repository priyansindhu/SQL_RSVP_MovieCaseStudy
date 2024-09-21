
USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:
-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT COUNT(*) AS No_of_rows_director_mapping FROM director_mapping;
-- No_of_rows_director_mapping:  3867

SELECT COUNT(*) AS No_of_rows_genre FROM genre;
-- No_of_rows_genre: 14662 

SELECT COUNT(*) AS No_of_rows_movies FROM movie;
-- No_of_rows_movies: 7997

SELECT COUNT(*) AS No_of_rows_names FROM names;
-- No_of_rows_names: 25735

SELECT COUNT(*) AS No_of_rows_ratings FROM ratings;
-- No_of_rows_ratings: 7997

SELECT COUNT(*) AS No_of_rows_role_mapping FROM role_mapping;
-- No_of_rows_role_mapping: 15615
    

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- case statements check for null present in each column of movie table and tells the number of null in it
SELECT 
    SUM(CASE
        WHEN id IS NULL THEN 1
        ELSE 0
        END) AS null_in_id,
    SUM(CASE
        WHEN title IS NULL THEN 1
        ELSE 0
        END) AS null_in_title,
    SUM(CASE
        WHEN year IS NULL THEN 1
        ELSE 0
        END) AS null_in_year,
    SUM(CASE
        WHEN date_published IS NULL THEN 1
        ELSE 0
        END) AS null_in_date_published,
    SUM(CASE
        WHEN duration IS NULL THEN 1
        ELSE 0
        END) AS null_in_duration,
    SUM(CASE
        WHEN country IS NULL THEN 1
        ELSE 0
        END) AS null_in_country,
    SUM(CASE
        WHEN worlwide_gross_income IS NULL THEN 1
        ELSE 0
        END) AS null_in_worlwide_gross_income,
    SUM(CASE
        WHEN languages IS NULL THEN 1
        ELSE 0
        END) AS null_in_languages,
    SUM(CASE
        WHEN production_company IS NULL THEN 1
        ELSE 0
        END) AS null_in_production_company
FROM
    movie;

/* output:

null_records_title	null_records_title	null_date_published	null_duration	null_records_country	null_records_income	null_records_languages	null_records_production_company
0	                   0	                      0	            0	                20	               3724                     	194	              528
*/

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:
+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+
Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
    year,
    COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY year
ORDER BY year;

/*output:
year, number_of_movies
2019	2001
2018	2944
2017	3052
*/

SELECT 
    MONTH(date_published) AS month_num,
    COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY month_num
ORDER BY month_num;

/*output:
month_num, number_of_movies
		1	804
		2	640
		3	824
		4	680
		5	625
		6	580
		7	493
		8	678
		9	809
		10	801
		11	625
		12	438
*/

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT 
    COUNT(id) AS Number_Of_Movies
FROM
    movie
WHERE
    (country REGEXP 'USA'  -- filters all the rows which has usa and india in it(multilingual languages included too)
        OR country REGEXP 'India')
        AND YEAR = 2019;

/* output:
Number_Of_Movies
1059
 */
 
/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT(genre) AS unique_list_of_genre
FROM genre
ORDER BY genre ;

/* output:
unique_list_of_genre
Action
Adventure
Comedy
Crime
Drama
Family
Fantasy
Horror
Mystery
Others
Romance
Sci-Fi
Thriller
*/

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
    genre, 
    COUNT(DISTINCT movie_id) AS number_of_movies
FROM
    genre
GROUP BY genre
ORDER BY number_of_movies DESC
LIMIT 1;

/*
genre  number_of_movies
Drama	4285
*/

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH Movies_with_one_genre_cte AS (
   SELECT m.id,
          m.title,
          COUNT(g.genre) AS number_of_genre
   FROM  movie m
        INNER JOIN
        genre g ON m.id = g.movie_id
   GROUP BY m.id
   HAVING number_of_genre = 1)
SELECT 
    COUNT(id) as Total_movies_of_one_genre
FROM
    Movies_with_one_genre_cte;
    
/*
Total_movies_of_one_genre
3289
*/

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)
/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
    g.genre, round(AVG(m.duration)) AS avg_duration
FROM
    movie m
        INNER JOIN
    genre g ON g.movie_id = m.id
GROUP BY g.genre
ORDER BY avg_duration DESC;

/*
output:
genre  avg_duration
Action	113
Romance	110
Drama	107
Crime	107
Fantasy	105
Comedy	103
Thriller	102
Adventure	102
Mystery	102
Family	101
Others	100
Sci-Fi	98
Horror	93
*/


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_rank_cte AS(
SELECT g.genre, 
      COUNT(DISTINCT m.id) AS movie_count,
      RANK() OVER(ORDER BY COUNT(DISTINCT m.id) DESC) AS genre_rank
FROM movie m 
      INNER JOIN
	  genre g
	  ON m.id= g.movie_id
GROUP BY g.genre)
SELECT * from genre_rank_cte
WHERE genre="Thriller";

/*
genre  movie_count genre_rank
Thriller	1484	3
*/

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:
-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
    ratings;
/*
min_avg_rating max_avg_rating min_total_votes max_total_votes min_median_rating max_median_rating
1.0                  10.0	        100	              725138	       1	                10
*/
/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
WITH movie_rank_cte AS(
      SELECT m.title, 
             r.avg_rating,
             DENSE_RANK()OVER(ORDER BY r.avg_rating DESC) AS movie_rank -- using dense rank for ranking without any gaps
      FROM movie m 
           INNER JOIN 
           ratings r
           ON m.id=r.movie_id)
	SELECT *
	FROM
       movie_rank_cte
    WHERE
       movie_rank <= 10;

/*
title  avg_rating  movie_rank
Kirket	10.0	     1
Love in Kilnerry	10.0	1
Gini Helida Kathe	9.8	2
Runam	9.7	3
Fan	9.6	4
Android Kunjappan Version 5.25	9.6	4
Yeh Suhaagraat Impossible	9.5	5
Safe	9.5	5
The Brighton Miracle	9.5	5
Shibu	9.4	6
Our Little Haven	9.4	6
Zana	9.4	6
Family of Thakurganj	9.4	6
Ananthu V/S Nusrath	9.4	6
Eghantham	9.3	7
Wheels	9.3	7
Turnover	9.2	8
Digbhayam	9.2	8
Tõde ja õigus	9.2	8
Ekvtime: Man of God	9.2	8
Leera the Soulmate	9.2	8
AA BB KK	9.2	8
Peranbu	9.2	8
Dokyala Shot	9.2	8
Ardaas Karaan	9.2	8
Kuasha jakhon	9.1	9
Oththa Seruppu Size 7	9.1	9
Adutha Chodyam	9.1	9
The Colour of Darkness	9.1	9
Aloko Udapadi	9.1	9
C/o Kancharapalem	9.1	9
Nagarkirtan	9.1	9
Jelita Sejuba: Mencintai Kesatria Negara	9.1	9
Shindisi	9.0	10
Officer Arjun Singh IPS	9.0	10
Oskars Amerika	9.0	10
Delaware Shore	9.0	10
Abstruse	9.0	10
National Theatre Live: Angels in America Part Two - Perestroika	9.0	10
Innocent	9.0	10
*/

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT 
    median_rating, COUNT(movie_id) AS movie_count
FROM
    ratings
GROUP BY median_rating
ORDER BY median_rating;

/*
output:
median_rating movie_count
	1	94
	2	119
	3	283
	4	479
	5	985
	6	1975
	7	2257
	8	1030
	9	429
	10	346
*/

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company,
       COUNT(distinct id) AS movie_count,
       DENSE_RANK() OVER (ORDER BY COUNT(id) desc) as prod_company_rank
FROM
    movie
WHERE 
    id in (SELECT 
					movie_id
			FROM
					ratings
			WHERE
					avg_rating > 8)
	AND
			production_company IS NOT NULL
GROUP BY 
	production_company;
/*
output:
production_company movie_count prod_company_rank
Dream Warrior Pictures	 3	     1
National Theatre Live	3	1
Central Base Productions	2	2
Colour Yellow Productions	2	2
Lietuvos Kinostudija	2	2
Marvel Studios	2	2
National Theatre	2	2
Painted Creek Productions	2	2
Panorama Studios	2	2
Swadharm Entertainment	2	2
1234 Cine Creations	1	3
20 Steps Productions	1	3
3 Ng Film	1	3
70 MM Entertainments	1	3
A square productions	1	3
A Studios	1	3
Aatpaat Production	1	3
Abis Studio	1	3
Acropolis Entertainment	1	3
Adenium Productions	1	3
Adrama	1	3
AKS Film Studio	1	3
Akshar Communications	1	3
Alchemy Vision Workz	1	3
Aletheia Films	1	3
Allfilm	1	3
Ancine	1	3
Angel Capital Film Group	1	3
Animonsta Studios	1	3
Annai Tamil Cinemas	1	3
Anto Joseph Film Company	1	3
Anwar Rasheed Entertainment	1	3
Appu Pathu Pappu Production House	1	3
Archangel Studios	1	3
Archway Pictures	1	3
Aries Telecasting	1	3
Arka Mediaworks	1	3
Art Movies	1	3
Ataraxia Entertainment	1	3
Atresmedia Cine	1	3
Ave Fenix Pictures	1	3
Avocado Media	1	3
Axess Film Factory	1	3
Ay Yapim	1	3
Banana Film DOOEL	1	3
Bayview Projects	1	3
Benaras Mediaworks	1	3
Benzy Productions	1	3
Bert Marcus Productions	1	3
Bestwin Production	1	3
Bhadrakali Pictures	1	3
Bioscope Film Framers	1	3
Blaze Film Enterprises	1	3
Blueprint Pictures	1	3
BOB Film Sweden AB	1	3
Bombay Walla Films	1	3
BR Productions and Riding High Pictures	1	3
Bradeway Pictures	1	3
Brainbox Studios	1	3
BrightKnight Entertainment	1	3
British Muslim TV	1	3
BRON Studios	1	3
Bulb Chamka	1	3
Cana Vista Films	1	3
Channambika Films	1	3
Chernin Entertainment	1	3
Cine Sarasavi Productions	1	3
Cineddiction Films	1	3
Cinenic Film	1	3
Cinepro Lanka International	1	3
Clown Town Productions	1	3
Clyde Vision Films	1	3
Coconut Motion Pictures	1	3
COMETE Films	1	3
Cross Creek Pictures	1	3
Crossing Bridges Films	1	3
Crystal Paark Cinemas	1	3
Dark Steel Entertainment	1	3
Dashami Studioz	1	3
Detailfilm	1	3
Diamond Works	1	3
Dijital Sanatlar Production	1	3
Doha Film Institute	1	3
Dream Tree Film Productions	1	3
DreamReality Movies	1	3
Dwarakish Chitra	1	3
Eastpool Films	1	3
EFilm	1	3
Epiphany Entertainments	1	3
Excel Entertainment	1	3
Fablemaze	1	3
Fábrica de Cine	1	3
Fahadh Faasil and Friends	1	3
Fenrir Films	1	3
Film Village	1	3
Fox STAR Studios	1	3
French Quarter Film	1	3
Frío Frío	1	3
Fulwell 73	1	3
Golden Horse Cinema	1	3
Goopy Bagha Productions Limited	1	3
Grahalakshmi Productions	1	3
Grass Root Film Company	1	3
GreenTouch Entertainment	1	3
Grooters Productions	1	3
Gurbani Media	1	3
Happy Hours Entertainments	1	3
Hayagriva Movie Adishtana	1	3
Hepifilms	1	3
Heyday Films	1	3
HI Film Productions	1	3
Hombale Films	1	3
HRX Films	1	3
Humble Motion Pictures	1	3
InnoVate Productions	1	3
Jar Pictures	1	3
Jayanna Combines	1	3
Jyot & Aagnya Anusaare Productions	1	3
Kaargo Cinemas	1	3
Kangaroo Broadcasting	1	3
Kannamthanam Films	1	3
Kharisma Starvision Plus PT	1	3
Kineo Filmproduktion	1	3
Loaded Dice Films	1	3
Lost Legends	1	3
Lovely World Entertainment	1	3
M-Films	1	3
Madras Enterprises	1	3
Maha Sithralu	1	3
Mahesh Manjrekar Movies	1	3
Mango Pickle Entertainment	1	3
Manikya Productions	1	3
Manyam Productions	1	3
Matchbox Pictures	1	3
Maxmedia	1	3
MD productions	1	3
Mirror Images LTD.	1	3
Missart produkcija	1	3
MNC Pictures	1	3
Moho Film	1	3
Moonshot Entertainments	1	3
Mooz Films	1	3
Moviee Mill	1	3
Mumba Devi Motion Pictures	1	3
Mumbai Film Company	1	3
Mythri Movie Makers	1	3
Namah Pictures	1	3
Narrator	1	3
NBW Films	1	3
Neelam Productions	1	3
Nokkhottro Cholochitra	1	3
O3 Turkey Medya	1	3
Oak Entertainments	1	3
OPM Cinemas	1	3
Orange Médias	1	3
Participant	1	3
Piecewing Productions	1	3
Plan J Studios	1	3
Potential Studios	1	3
Prime Zero Productions	1	3
PRK Productions	1	3
PVP Cinema	1	3
Ra.Mo.	1	3
Rapi Films	1	3
RedhanThe Cinema People	1	3
Reliance Entertainment	1	3
RGK Cinema	1	3
Rishab Shetty Films	1	3
RMCC Productions	1	3
Rocket Beans Entertainment	1	3
Ronk Film	1	3
Rotten Productions	1	3
Runaway Productions	1	3
Saanvi Pictures	1	3
Shree Raajalakshmi Films	1	3
Shreya Films International	1	3
Shreyasree Movies	1	3
Silent Hills Studio	1	3
Sithara Entertainments	1	3
Sixteen by Sixty-Four Productions	1	3
SLN Cinemas	1	3
Smash Entertainment!	1	3
Sony Pictures Entertainment (SPE)	1	3
Special Treats Production Company	1	3
SRaj Productions	1	3
StarFab Production	1	3
StarVision	1	3
Studio Green	1	3
Suresh Productions	1	3
Swami Samartha Creations	1	3
Swapna Cinema	1	3
Swonderful Pictures	1	3
Synergy Films	1	3
The Archers	1	3
The Church of Almighty God Film Center	1	3
The Icelandic Filmcompany	1	3
The SPA Studios	1	3
The United Team of Art	1	3
Think Music	1	3
Tigmanshu Dhulia Films	1	3
Tin Drum Beats	1	3
Toei Animation	1	3
Touch Wood Multimedia Creations	1	3
Trafalgar Releasing	1	3
Twentieth Century Fox	1	3
Urvashi Theaters	1	3
V. Creations	1	3
Vehli Janta Films	1	3
Viacom18 Motion Pictures	1	3
Viva Inen Productions	1	3
Vivid Films	1	3
Walt Disney Pictures	1	3
Warnuts Entertainment	1	3
Williams 4 Productions	1	3
WM Films	1	3
Wonder Head	1	3
*/

   /*
 Insights:- Dream Warrior Pictures or National Theatre Live  are the production houses with which RSVP Movies collaborate
*/

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
    g.genre, COUNT(DISTINCT (m.id)) AS movie_count
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    MONTH(m.date_published) = 3
        AND m.year = 2017
        AND m.country REGEXP 'usa'
        AND r.total_votes > 1000
GROUP BY g.genre
ORDER BY movie_count DESC;

/* 
output:

Drama	24
Comedy	9
Action	8
Thriller	8
Sci-Fi	7
Crime	6
Horror	6
Mystery	4
Romance	4
Adventure	3
Fantasy	3
Family	1*/
-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    m.title, r.avg_rating, g.genre
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    m.title REGEXP '^The'
        AND r.avg_rating > 8
ORDER BY g.genre DESC;

/*
output:
title                  avg_rating genre
Theeran Adhigaaram Ondru	8.3	Thriller
The King and I	8.2	Romance
The Blue Elephant 2	8.8	Mystery
....
....
....
*/

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.

-- with median
SELECT 
	 m.title,
    r.median_rating,
	g.genre
FROM
	movie m
		INNER JOIN
			genre g ON g.movie_id = m.id
		INNER JOIN
			ratings r ON r.movie_id = m.id
WHERE
	m.title regexp '^The' AND r.median_rating > 8
ORDER BY g.genre DESC;

/*
output:
title    median_rating  genre
The Nursery	  9	      Thriller
The Transcendents	10	Thriller
The Watcher	10	Thriller
....
....
....
*/
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT 
    r.median_rating, COUNT(distinct r.movie_id) AS movie_count
FROM
    movie m
        INNER JOIN
    ratings r ON  
    m.id = r.movie_id
WHERE
        r.median_rating = 8
        AND m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY r.median_rating;

/*
median_rating  movie_count
8	              361
*/

/*
+-------------------+-------------+
| median_rating    | movie_count |
+------------------+--------------+
| 8          	    |   361         | 
+-------------------+------------------+
*/

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

WITH  
german_language AS (
SELECT sum(r.total_votes) as total_votes_g FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
WHERE m.languages LIKE '%GERMAN%'),
italian_language AS (
SELECT sum(r.total_votes) as total_votes_i FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
WHERE m.languages LIKE '%Italian%')
SELECT total_votes_g AS German, total_votes_i AS Italian,
       case when total_votes_g>total_votes_i then "Yes" else "No" end as Is_German_votes_high
       from german_language, italian_language;

/*
German  Italian Is_German_votes_high
4421525	2559540	   Yes

*/

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:
-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT
           SUM(CASE
		   WHEN name IS NULL THEN 1
		   ELSE 0
           END) AS null_in_name, 
           SUM(CASE
		   WHEN height IS NULL THEN 1
		   ELSE 0
           END) AS null_in_height,
           SUM(CASE
		   WHEN date_of_birth IS NULL THEN 1
		   ELSE 0
           END) AS null_in_date_of_birth,
           SUM(CASE
		   WHEN known_for_movies IS NULL THEN 1
		   ELSE 0
           END) AS null_in_known_for_movies
FROM names;

/*
output:
null_in_name null_in_height null_in_date_of_birth null_in_known_for_movies
    0	          17335	          13431	              15226
*/


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_genre_summary AS (   -- lists top three genres with movies avg_rating>8
SELECT 
    g.genre, COUNT(distinct m.id) AS movie_count
FROM
    movie m
        INNER JOIN
    genre g ON g.movie_id = m.id
        INNER JOIN
    ratings r ON r.movie_id = m.id
WHERE
    r.avg_rating > 8
GROUP BY g.genre
ORDER BY movie_count DESC
LIMIT 3
)               
SELECT 
    name AS director_name, COUNT(movie_id) AS movie_count
FROM
    director_mapping
        INNER JOIN
    ratings USING (movie_id)
        INNER JOIN
    names ON name_id = id
        INNER JOIN
    genre USING (movie_id)
        INNER JOIN
    top_genre_summary USING (genre)
WHERE
    avg_rating > 8
GROUP BY director_name
ORDER BY movie_count DESC
LIMIT 3;

/*
output:
director_name movie_count
James Mangold	4
Anthony Russo	3
Soubin Shahir	3
*/

   /*
 Insights:- James Margold can be considered as a director for the next RSVP project.
*/



/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH actors_rank_summary as (
SELECT 
   n.name as actor_name, count(distinct rm.movie_id) as movie_count, dense_rank() OVER (ORDER BY count(distinct rm.movie_id) desc) as actor_rank
FROM
    role_mapping rm
        INNER JOIN
    ratings r USING (movie_id)
        INNER JOIN
    names n ON rm.name_id = n.id
WHERE
    median_rating >=8
GROUP BY actor_name
ORDER BY actor_rank
)
SELECT 
    actor_name, movie_count
FROM
    actors_rank_summary
WHERE
    actor_rank < 3
ORDER BY actor_rank;

 /*
 output:
 actor_name movie_count
 Mammootty	8
 Mohanlal	5
 */
   /*
 Insights:- Mammootty and Mohanlal could be consider as they are top two highest average median rating actors.
*/



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_house_summary AS (
SELECT 
   m.production_company, sum(r.total_votes) as vote_count, dense_rank() OVER (ORDER BY sum(r.total_votes) desc) as prod_comp_rank
FROM
    movie m
        INNER JOIN
    ratings r on m.id = r.movie_id
GROUP BY m.production_company
ORDER BY prod_comp_rank
)
SELECT 
    *
FROM
    production_house_summary
WHERE
    prod_comp_rank <= 3
ORDER BY prod_comp_rank;
 
 /*
 output:
 production_company vote_count prod_comp_rank
Marvel Studios	    2656967	      1
Twentieth Century Fox	2411163	2
Warner Bros.	2396057	3
 */
   /*
 Insights:- Marvel Studios,Twentieth Century Fox and Warner Bros. are top production houses based on number of votes received by their produced movies.
*/


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actors_cte AS
(
           SELECT n.NAME AS actor_name,
				  r.total_votes,
				  m.id,
				  r.avg_rating
           FROM   movie m
               INNER JOIN ratings r
               ON  m.id=r.movie_id
               INNER JOIN role_mapping ro
			   ON  ro.movie_id=m.id
               INNER JOIN names n
               ON  n.id=ro.name_id
           WHERE  m.country regexp "India"
           AND  ro.category="actor" )
SELECT   actor_name,
         sum(total_votes) AS total_votes,
         count(DISTINCT id) AS movie_count,
         round((sum(avg_rating*total_votes)/sum(total_votes)),2 ) AS actor_avg_rating,
         DENSE_RANK ()OVER(ORDER BY round((sum(avg_rating*total_votes)/sum(total_votes)),2 ) DESC, sum(total_votes) DESC) AS actor_rank
FROM     actors_cte
GROUP BY actor_name
HAVING   movie_count>=5 ;

/*
output:
actor_name     total_votes movie_count actor_avg_rating actor_rank
Vijay Sethupathi	23114	  5	                 8.42	    1
Fahadh Faasil	13557	5	7.99	2
Yogi Babu	8500	11	7.83	3
...
...
...
*/

  /*
 Insights:- Vijay Sethupathi can be chosen as an actor as he tops with 8.42 in average rating in indian movies
*/




-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
-- select distinct languages from movie;
WITH top_actress_table AS (
SELECT n.name as actress_name , 
		sum(r.total_votes) as total_votes, 
        count(rm.movie_id) as movie_count, 
        round(sum(avg_rating * total_votes)/sum(total_votes),2) as actor_avg_rating,
		dense_rank() OVER (ORDER BY round(sum(avg_rating * total_votes)/sum(total_votes),2) desc) as actress_rank
FROM movie m 
INNER JOIN 
		role_mapping  rm on m.id= rm.movie_id
INNER JOIN 
		names n on rm.name_id= n.id
INNER JOIN 
		ratings r on m.id= r.movie_id
WHERE 
		rm.category = 'actress' and m.country LIKE '%India%' AND m.languages LIKE '%Hindi%'
GROUP BY 
		rm.name_id
HAVING 
		count(rm.movie_id) >= 3
)
SELECT * FROM top_actress_table WHERE actress_rank <=5 
ORDER BY actress_rank;

/*
output:
actress_name total_votes movie_count actor_avg_rating actress_rank
Taapsee Pannu	18061	  3	                   7.74	    1
Kriti Sanon	21967	3	7.05	2
Divya Dutta	8579	3	6.88	3
Shraddha Kapoor	26779	3	6.63	4
Kriti Kharbanda	2549	3	4.80	5
*/

   /*
 Insights:- Tapsee pannu can be chosen as an actress as she tops with 7.74 in average rating in indian movies
*/


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

WITH thriller_movies_cte AS
( SELECT m.title,
         r.avg_rating, 
         m.id
  FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
        INNER JOIN
    genre g ON m.id = g.movie_id
  WHERE
    g.genre = 'Thriller'
)
SELECT 
    id,
    title,
    CASE
        WHEN avg_rating > 8 THEN 'Superhit movies'
        WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time watch movies'
        WHEN avg_rating < 5 THEN 'Flop movies'
    END AS category
FROM
    thriller_movies_cte
ORDER BY category DESC;

/*
output:
id           title     category
tt6271432	Abstruse	Superhit movies
tt10869474	Safe	Superhit movies
tt8561086	Joseph	Superhit movies
...
...
...
*/


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
		genre, 
        round(avg(m.duration)) as avg_duration,
		round(sum(avg(m.duration)) OVER( ORDER BY g.genre ROWS UNBOUNDED PRECEDING ),2)  AS running_total_duration,
		round (avg(avg(m.duration)) OVER (ORDER BY g.genre ROWS UNBOUNDED PRECEDING),2) AS moving_avg_duration
FROM 
		movie m
INNER JOIN 
		genre g
        ON id=movie_id
GROUP BY g.genre
ORDER BY g.genre;

/*
OUTPUT:
genre avg_duration running_total_duration moving_avg_duration
Action	 113	          112.88	       112.88
Adventure	102	214.75	107.38
Comedy	103	317.38	105.79
*/

-- Round is good to have and not a must have; Same thing applies to sorting





-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
WITH top_genre_summary AS (
SELECT 
    g.genre, COUNT(distinct g.movie_id) AS movie_count, row_number() over (Order by COUNT(distinct g.movie_id) desc) as rank_genre
FROM
	movie m
INNER JOIN genre g ON g.movie_id=m.id
INNER JOIN ratings r ON r.movie_id=m.id
WHERE r.avg_rating >8
GROUP BY g.genre
ORDER BY rank_genre
),
movies_rank_summary AS (
SELECT 
    genre, 
    year, 
    title as movie_name,
    CASE 
		WHEN worlwide_gross_income regexp '^INR' THEN cast(substring(worlwide_gross_income,4) AS double)* 0.012 -- currency conversion from INR to Dollar 
        WHEN worlwide_gross_income like '$%' THEN cast(substring(worlwide_gross_income,2) AS double)
        ELSE worlwide_gross_income
	END AS worlwide_gross_income1   
FROM
		movie
INNER JOIN
		genre on id= movie_id
WHERE genre in (Select genre from top_genre_summary where rank_genre<=3)
ORDER BY year
),
TOP_5 AS (
SELECT 
    genre,
    year,
	movie_name,
    CONCAT('$', worlwide_gross_income1) AS worlwide_gross_income, -- adding $ symbol again for displaying 
    dense_rank() over (PARTITION BY year ORDER BY CAST(worlwide_gross_income1 AS DOUBLE) desc ) as movie_rank
FROM

    movies_rank_summary
ORDER BY year)
SELECT * from TOP_5 where movie_rank <= 5
ORDER BY year,movie_rank;

/*
output:
genre   year                  movie_name             worlwide_gross_income2 movie_rank
Action	2017	Star Wars: Episode VIII - The Last Jedi	$1332539889         	1
Action	2017	The Fate of the Furious	$1236005118	2
Comedy	2017	Despicable Me 3	$1034799409	3
....
....
....
*/

   /*
 Insights:- Star Wars: Episode VIII - The Last Jedi;, Avengers: Infinity War and Avengers: Endgame are the  highest grossing movies of 2017,2018 and 2019
*/




-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_company_cte AS(
SELECT m.production_company, 
       COUNT(DISTINCT m.id) AS movie_count,
       DENSE_RANK()OVER(ORDER BY COUNT(DISTINCT m.id) DESC)AS prod_comp_rank
FROM movie m 
       INNER JOIN 
     ratings r
       ON m.id=r.movie_id
WHERE r.median_rating>=8 AND 
      m.production_company IS NOT NULL AND
      POSITION(',' IN languages)>0 
GROUP BY m.production_company
  ORDER BY movie_count DESC
)
SELECT 
    production_company, movie_count, prod_comp_rank
FROM
    production_company_cte
WHERE
    prod_comp_rank < 3
   ORDER BY movie_count DESC;
   
   /*
   output:
   production_company movie_count prod_comp_rank
   Star Cinema	         7	            1
   Twentieth Century Fox	4	2
   */
   
   /*
 Insights:- Star cinema and Twenty century fox have produced highest number of hits among multilingual movies. 
 RSVP can consider about partnership with any one of these.
*/



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language

-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH top_actress_table AS (
SELECT n.name as actress_name , 
		sum(r.total_votes) as total_votes, 
        count(rm.movie_id) as movie_count, 
        round(sum(avg_rating * total_votes)/sum(total_votes),2) as actress_avg_rating,
		dense_rank() OVER (ORDER BY round(sum(avg_rating * total_votes)/sum(total_votes),2) desc) as actress_rank
FROM movie m 
INNER JOIN 
		role_mapping  rm on m.id= rm.movie_id
INNER JOIN 
		names n on rm.name_id= n.id
INNER JOIN 
		ratings r on m.id= r.movie_id
INNER JOIN 
		genre g on m.id= g.movie_id
WHERE 
		rm.category = 'actress' and g.genre = 'Drama'
GROUP BY 
		rm.name_id

)
SELECT * FROM top_actress_table WHERE actress_rank <=3 
ORDER BY actress_rank;

/*
output:
actress_name   total_votes movie_count actress_avg_rating actress_rank
Sangeetha Bhat	1010	       1	         9.60	              1
Fatmire Sahiti	3932	1	9.40	2
Pranati Rai Prakash	897	1	9.40	2
Adriana Matoshi	4058	2	9.33	3
*/

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations


Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH director_summary AS (   -- filtering out the fields needed
SELECT 
    d.name_id AS director_id,
    n.name AS director_name,
    d.movie_id as movie_id,
    m.date_published as last_date_published,
    LEAD(m.date_published) OVER (PARTITION BY d.name_id ORDER BY m.date_published, d.movie_id) AS next_date_published,
    avg_rating,
    total_votes,
    duration
FROM
    movie m
        INNER JOIN
    director_mapping d ON d.movie_id = m.id
        INNER JOIN
    names n ON n.id = d.name_id
        INNER JOIN
    ratings r ON r.movie_id = m.id
ORDER BY d.name_id
    ),
    top_director AS ( -- will calculate the date difference between each movie
    SELECT 
    director_id,
    director_name,
    COUNT(DISTINCT movie_id) as number_of_movies,
    ROUND(AVG(DATEDIFF(next_date_published, last_date_published))) AS avg_inter_movie_days,
    ROUND(sum(avg_rating * total_votes)/sum(total_votes),2) AS avg_rating,
    SUM(total_votes) AS total_votes,
	MIN(avg_rating) AS min_rating,
    MAX(avg_rating) AS max_rating,
	SUM(duration) AS total_duration,
    dense_rank() over (ORDER BY COUNT(DISTINCT movie_id) desc) AS director_rank
FROM
    director_summary
GROUP BY director_id
ORDER BY COUNT(movie_id) DESC
)
SELECT director_id,director_name,number_of_movies,avg_inter_movie_days,avg_rating,total_votes,min_rating,max_rating,total_duration FROM top_director
WHERE director_rank <=9
ORDER BY director_rank;
 
 /*
 output:
director_id	director_name	number_of_movies	avg_inter_movie_days	avg_rating	total_votes	min_rating	max_rating	total_duration
nm1777967	A.L. Vijay      	5	                  177                  	5.65	1754	        3.7	          6.9	613
nm2096009	Andrew Jones	    5	                  191	                 3.04	1989	         2.7	     3.2	432
nm0001752	Steven Soderbergh	4	                  254	                 6.77	171684	        6.2	         7.0	401
 */
   
   /*
 Insights:- A.L. Vijay and Andrew Jones have produced highest number of directed movies.
*/






