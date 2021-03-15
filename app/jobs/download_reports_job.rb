class DownloadReportsJob <  Struct.new(:solutions)
  require 'zip'

  def perform

    file = "archive.zip"

    # solutions.each do |solution|
    #   file = File.open('public/event.json', 'w') { |f| f.write(solution.all.to_json) }
    # end



    Zip::File.open(file, Zip::File::CREATE) do |zipfile|
      solutions.each do |solution|
        File.open("#{solution.name}_#{solution.id}.json", 'w') { |f| f.write(solution.to_json) }

        zipfile.add("#{solution.name}_#{solution.id}.json", "#{solution.name}_#{solution.id}.json")
      end
    end
    zip_data = File.read(file)
    puts zip_data

    # send_file(zip_data, :type => 'application/zip', :filename => "All submissions")
  end
end
