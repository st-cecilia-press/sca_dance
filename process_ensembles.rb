require 'yaml'
require 'csv'
require 'fileutils'
require 'tempfile'
require 'byebug'

#directories = Dir.glob('*').select {|f| File.directory? f and f != "metadata" and f !=  "test"}
missing = []
CSV.foreach('./ensemble.csv') do |row|
  next if row[0] == 'band'
  t_file = Tempfile.new('filename_temp.txt')
  t_file2 = Tempfile.new('filename_temp2.txt')
  unless row[2].nil?
    media = {}
    media = YAML.load_file("./#{row[2]}/media.yaml") if File.file?("#{row[2]}/media.yaml")
    metadata = YAML.load_file("./#{row[2]}/metadata.yaml")
    slug = "#{row[0]}_#{row[2]}"
    unless row[4].nil?
      tag = row[4].downcase.tr(' ', '_')
      slug = "#{slug}_#{tag}"
    end
    
    audio = { "slug" => slug, "youtube" => row[1], "purchase_url" => row[5], "ensemble" => row[0], "file" => '' } 
    if media["audio"].nil?
      media["audio"] = []
    end
    media["audio"].push(audio)
    if metadata["instructions"][0]["audio"].nil?
      metadata["instructions"][0]["audio"] = []
    end
    metadata["instructions"][0]["audio"].push(slug)
    t_file.puts metadata.to_yaml
    t_file.close
    t_file2.puts media.to_yaml
    t_file2.close
    #FileUtils.mv(t_file.path, "./#{row[0]}/metadata.yaml")
    FileUtils.mv(t_file.path, "./test/#{row[2]}_metadata.yaml")
    FileUtils.mv(t_file2.path, "./test/#{row[2]}_media.yaml")
    
  else
    missing.push(row) 
  end  
end

   File.open("./test/remainder_ensemble.csv", "w") {|f| f.write(missing.inject([]) { |csv, row|  csv << CSV.generate_line(row) }.join(""))}

