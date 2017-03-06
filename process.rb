require 'yaml'
terp = File.open('./terp.txt').read
flag = 0
slug, title, person, category, markdown = '', '', '', '', ''
terp.each_line do |line|
  if flag == 0 && line.match(/^%%%/)
    slug = line.gsub('%%%','').chomp 
    flag = 1
    next
  elsif flag == 1
    title = line.chomp
    flag = 2
    next
  elsif flag == 2
    person = line.chomp
    flag = 3
    next
  elsif flag == 3
    category = line.chomp
    flag = 4
    next
  elsif flag == 4 && line !~ /@@@@@/
    markdown = markdown + line.to_s
    next
  elsif flag == 4 && line =~ /@@@@@/  
    metadata = { 'title' => title, 'person' => person, 'category' => category, 
       'instructions' => [ { 'filename' => 'terp.md', 'person' => '', 'instruction_type' => 'reconstruction' } ] }
       
    Dir.mkdir(slug)
    File.write("#{slug}/metadata.yaml", metadata.to_yaml)
    File.write("#{slug}/terp.md", markdown)
    slug, title, person, category, markdown = '', '', '', '', ''
    flag = 0
    next
    
  end
end
