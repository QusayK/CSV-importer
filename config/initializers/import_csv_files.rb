require 'rake'

def import_csv_files
    Rake::Task.clear
  
    Rails.application.load_tasks
  
    Rake::Task['import:movies_and_reviews'].invoke
end
  
Rails.application.config.after_initialize do
import_csv_files
end