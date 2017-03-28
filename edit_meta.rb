require 'fileutils'
require 'tempfile'
require 'yaml'
require 'csv'
csv = CSV.foreach('./period.csv') do | row|
#directories = Dir.glob('*').select {|f| File.directory? f and f != "metadata" and f !=  "test"}
#directories.each do  |dir|
  next if row[1].nil?
  editions = {'sheet_music' => []}
  sm_slugs = []
  Dir["/home/mrio/dev/pile/#{row[1]}/*.ly"].each do |ly|
    basename = File.basename(ly)
    #name = "#{arranger}'s Arrangement"
    source = 'http://pennsicdance.aands.org/pennsic45/PennsicPile45.pdf'
    mf_name = 'Pennsic Pile Edition'
    filename = basename.gsub('ly','pdf')
    editions['sheet_music'].push({'slug' => row[2], 'name' => row[3], 'music_files' => [ 'filename'=> filename, 'source' => source, 'name' => mf_name ]})
    #FileUtils.cp("/home/mrio/dev/pile/#{filename}", "./#{row[0]}/#{filename}")
    sm_slugs.push(row[2])
        
    
    
    #puts row[1] if editions['sheet_music'].count == 0
  end
  hash = YAML.load_file("./#{row[0]}/metadata.yaml")
  t_file = Tempfile.new('filename_temp.txt')
  t_file2 = Tempfile.new('filename_temp2.txt')
  hash['instructions'][0]['sheet_music'] = sm_slugs
  #hash['sources'] = ['slug' => row[1]] 
    
  t_file.puts editions.to_yaml
  t_file2.puts hash.to_yaml
  #
  t_file.close
  t_file2.close
  #FileUtils.mv(t_file.path, "./test/#{row[0]}_media.yaml")
  #FileUtils.mv(t_file2.path, "./test/#{row[0]}_meta.yaml")
  FileUtils.mv(t_file.path, "#{row[0]}/media.yaml")
  FileUtils.mv(t_file2.path, "#{row[0]}/metadata.yaml")
end
