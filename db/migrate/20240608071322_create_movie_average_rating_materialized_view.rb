class CreateMovieAverageRatingMaterializedView < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      DROP MATERIALIZED VIEW IF EXISTS movie_average_ratings;

      CREATE MATERIALIZED VIEW movie_average_ratings AS
      SELECT
        movies.id AS movie_id,
        COALESCE(AVG(reviews.stars), 0) AS average_rating
      FROM
        movies
      LEFT JOIN
        reviews ON reviews.movie_id = movies.id
      GROUP BY
        movies.id
      WITH DATA;

      CREATE UNIQUE INDEX index_movie_average_ratings_on_movie_id
      ON movie_average_ratings(movie_id);
    SQL
  end

  def down
    execute <<-SQL
      DROP MATERIALIZED VIEW IF EXISTS movie_average_ratings;
    SQL
  end
end
