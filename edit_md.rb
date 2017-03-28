require 'fileutils'
require 'tempfile'
directories = Dir.glob('*').select {|f| File.directory? f and f != "metadata" and f !=  "test"}
directories.each do  |dir|
  t_file = Tempfile.new('filename_temp.txt')
  terp = File.open("./#{dir}/terp.md").read
  text = ''
  flag = true 
  terp.each_line do |line|
    if flag
      line = line.gsub('== ','==')
      line = line.gsub(' ==','==')
      flag = false
    end 
    text = text + line
  end
  t_file.puts text
  
  t_file.close
  FileUtils.mv(t_file.path, "./#{dir}/terp.md")
end
