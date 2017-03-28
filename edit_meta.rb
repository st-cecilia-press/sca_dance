require 'fileutils'
require 'tempfile'
require 'yaml'
require 'csv'
csv = CSV.foreach('./all.csv') do | row|
#directories = Dir.glob('*').select {|f| File.directory? f and f != "metadata" and f !=  "test"}
#directories.each do  |dir|
  next if row[1].nil?
  editions = {'sheet_music' => []}
  Dir["/home/mrio/dev/pile/#{row[1]}/*.ly"].each do |ly|
    basename = File.basename(ly)
    lily = File.open(ly).read
    lily.each_line do |line|
      if line.match(/arr\./)
        arranger = line.split('arr. ')[1].split('"')[0]
        slug = arranger.gsub(' ','_').gsub('.','').downcase + '_' + row[0] 
        name = "#{arranger}'s Arrangement"
        source = 'http://pennsicdance.aands.org/pennsic45/PennsicPile45.pdf'
        mf_name = 'Pennsic Pile Edition'
        filename = basename.gsub('ly','pdf')
        editions['sheet_music'].push({'slug' => slug, 'name' => name, 'music_files' => [ 'filename'=> filename, 'source' => source, 'name' => mf_name ]})
        
      end
    end
    
    #puts row[1] if editions['sheet_music'].count == 0
  end
  puts editions.to_yaml 
  #hash = YAML.load_file("./#{row[0]}/metadata.yaml")
  #t_file = Tempfile.new('filename_temp.txt')
  #hash['sources'] = ['slug' => row[1]] 
    

  #t_file.puts hash.to_yaml
  #
  #t_file.close
  ##FileUtils.mv(t_file.path, "./test/#{row[0]}.yaml")
  #FileUtils.mv(t_file.path, "#{row[0]}/metadata.yaml")
end
