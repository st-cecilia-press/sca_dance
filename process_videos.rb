require 'yaml'
require 'csv'
require 'fileutils'
require 'tempfile'
require 'byebug'

directories = Dir.glob('*').select {|f| File.directory? f and f != "metadata" and f !=  "test"}
missing = []
CSV.foreach('./videos.csv') do |row|
  t_file = Tempfile.new('filename_temp.txt')
  if directories.include?(row[0])
    metadata = YAML.load_file("./#{row[0]}/metadata.yaml")
    vid = { "name" => "Darius's Recording", "youtube" => row[1] } 
    unless row[2].nil?
     vid["name"]  = "Darius's Recording: #{row[2]}"
    end
    if metadata["instructions"][0]["videos"].nil?
      metadata["instructions"][0]["videos"] = []
    end
    metadata["instructions"][0]["videos"].push(vid)
    t_file.puts metadata.to_yaml
    t_file.close
    FileUtils.mv(t_file.path, "./#{row[0]}/metadata.yaml")
  else
    missing.push(row) 
  end  
end

   File.open("test/missing.csv", "w") {|f| f.write(missing.inject([]) { |csv, row|  csv << CSV.generate_line(row) }.join(""))}

