class MoviesController < ApplicationController
    def index
      @movies = Movie.left_joins(:reviews)
                       .group('movies.id, movie_average_ratings.average_rating')
                       .select('movies.*, AVG(reviews.stars) as average_rating')
                       .joins("LEFT JOIN movie_average_ratings ON movies.id = movie_average_ratings.movie_id")
                       .order("movie_average_ratings.average_rating DESC")
    end
  end
  