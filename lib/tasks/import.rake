namespace :import do
    desc "Import movies, directors, actors, and reviews from CSV"
    task movies_and_reviews: :environment do
      require 'smarter_csv'
  
      chunk_size = 1000

      thread = Thread.new do
        # Import directors, locations, countries and movies
        directors = {}
        SmarterCSV.process(Rails.root.join('db', 'csv', 'movies.csv'), chunk_size: chunk_size) do |chunk|
          chunk.each do |row|

            director_name = row[:director]
            unless directors[director_name]
              directors[director_name] = Director.find_or_create_by(name: director_name)
            end
    
            location = FilmingLocation.find_or_create_by(name: row[:filming_location])
            country = Country.find_or_create_by(name: row[:country])
            
            director = directors[director_name]

            movie = Movie.find_by(title: row[:movie])
            unless movie
              movie = Movie.create(
                title: row[:movie],
                description: row[:description],
                year: row[:year],
                director: director,
                filming_location: location,
                country: country
              )
            end
    
            actor = Actor.find_or_create_by(name: row[:actor])
            MovieActor.find_or_create_by(movie: movie, actor: actor)
          end
        end
    
        # Import users and reviews
        users = {}
        SmarterCSV.process(Rails.root.join('db', 'csv', 'reviews.csv'), chunk_size: chunk_size) do |chunk|
          
          chunk.each do |row|
            user_name = row[:user]
            unless users[user_name]
              users[user_name] = User.find_or_create_by(name: user_name)
            end
    
            movie = Movie.find_by(title: row[:movie])
            if movie
              Review.find_or_create_by(
                movie: movie,
                user: users[user_name],
                stars: row[:stars],
                review: row[:review]
              )
            end
          end
        end

        puts "Movies, directors, actors, users, and reviews imported successfully"
      end

      thread.join

      refresh_materialized_view
    end
  end
  
  def refresh_materialized_view
    ActiveRecord::Base.connection.execute("REFRESH MATERIALIZED VIEW movie_average_ratings")
  end
