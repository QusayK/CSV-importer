class Movie < ApplicationRecord
  belongs_to :director
  belongs_to :country
  belongs_to :filming_location
  
  has_many :movie_actors 
  has_many :actors, through: :movie_actors
  has_many :reviews, dependent: :destroy
end
