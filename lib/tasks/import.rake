namespace :import do
    desc "Import movies, directors, actors, and reviews from CSV"
    task movies_and_reviews: :environment do
      require 'smarter_csv'
  
      chunk_size = 1000

      # Import directors and movies
      directors = {}
      SmarterCSV.process(Rails.root.join('db', 'csv', 'movies.csv'), chunk_size: 100) do |chunk|
        chunk.each do |row|
          director_name = row[:director]
          unless directors[director_name]
            directors[director_name] = Director.find_or_create_by(name: director_name)
          end
  
          director = directors[director_name]
          movie = Movie.find_or_create_by(
            title: row[:movie],
            description: row[:description],
            year: row[:year],
            director: director,
            country: row[:country],
            filming_location: row[:filming_location]
          )
  
          actor = Actor.find_or_create_by(name: row[:actor])
          MovieActor.find_or_create_by(movie: movie, actor: actor)
        end
      end
  
      # Import users and reviews
      users = {}
      SmarterCSV.process(Rails.root.join('db', 'csv', 'reviews.csv'), chunk_size: 100) do |chunk|
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
    end
  end
  