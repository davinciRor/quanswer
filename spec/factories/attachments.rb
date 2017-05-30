FactoryGirl.define do
  factory :attachment do
    file do
      Rack::Test::UploadedFile.new(
          File.join(Rails.root, 'spec', 'support', 'files', 'factory_file.txt')
      )
    end
  end
end
