# encoding: utf-8

namespace :data do

  desc 'Re-saves all stored files to make sure no chunk is larger than a 65k BLOB'
  task :fix_storage_chunks => :full_environment do
    Storage::File.find_each do |storage_file|
      storage_file.transaction do
        old_data = storage_file.data
        storage_file.data = old_data
        storage_file.save!
      end
    end
  end
end
