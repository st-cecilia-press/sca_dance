require 'fileutils'
require 'tempfile'
require 'yaml' 
require 'csv'
csv = CSV.foreach('./italian_15.csv') do | row|
  #directories = Dir.glob('*').select {|f| File.directory? f and f != "metadata" and f !=  "test"}
  #directories.each do  |dir|
  #directories.each do  |dir| #editions = YAML.load_file("./#{row[0]}/media.yaml") if File.exists?("./#{row[0]}/media.yaml")
  #sm_slugs = []
  ##name = "#{arranger}'s Arrangement"
  #source = 'http://pennsicdance.aands.org/pennsic45/PennsicPile45.pdf'
  #mf_name = 'Pennsic Pile Edition'
  #filename = "#{row[2]}.pdf"
  #editions['sheet_music'].push({'slug' => row[1], 'name' => row[3], 'music_files' => [ 'filename'=> filename, 'source' => source, 'name' => mf_name ]})
  #FileUtils.cp("/home/mrio/dev/pile/#{filename}", "./#{row[0]}/#{filename}")
  #sm_slugs.push(row[1])
        
    
    
  hash = YAML.load_file("./#{row[0]}/metadata.yaml")

  t_file = Tempfile.new('filename_temp.txt')
  #if hash['instructions'][0].key?('sheet_music')
  #  hash['instructions'][0]['sheet_music'].push(row[1])
  #else
  #  hash['instructions'][0]['sheet_music'] = [row[1]]
  #end
  hash['sources'] = ['slug' => row[1]] 
    
  t_file.puts hash.to_yaml
  #
  t_file.close
  #FileUtils.mv(t_file.path, "./test/#{row[0]}.yaml")
  FileUtils.mv(t_file.path, "#{row[0]}/metadata.yaml")
end
