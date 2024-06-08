class Movie < ApplicationRecord
  belongs_to :director
  has_many :movie_actors 
  has_many :actors, through: :movie_actors
  has_many :reviews, dependent: :destroy
end
