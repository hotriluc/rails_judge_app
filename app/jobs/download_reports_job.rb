class DownloadReportsJob <  Struct.new(:solutions)
  require 'zip'

  def perform

    file = "archive.zip"


    Zip::File.open(file, Zip::File::CREATE) do |zipfile|
      solutions.each do |solution|
        File.open("#{solution.name}_#{solution.id}.json", 'w') { |f| f.write(solution.to_json) }

        zipfile.add("#{solution.name}_#{solution.id}.json", "#{solution.name}_#{solution.id}.json")
      end
    end
    zip_data = File.read(file)

  end
end
