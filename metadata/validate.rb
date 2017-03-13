require 'byebug'
require 'yaml'

class Validator
  def initialize(sources_yaml='./sources.yaml', ensembles_yaml='./ensembles.yaml')
    @sources_yaml = sources_yaml
    @ensembles_yaml = ensembles_yaml 
    @directories = Dir.glob('*').select {|f| File.directory? f and  f != "metadata" }
    @errors = []
  end
  def validate_repo
    @directories.each do |slug| 
      metadata_fn = "#{slug}/metadata.yaml"
      media_fn = "#{slug}/media.yaml"
      if File.exist?(media_fn)
        valid, message = valid_yaml_string?(media_fn)
        if !valid
          @errors.push(message)
        else
          media = YAML.load_file(media_fn)
          output = validate_media(media, slug)  
          @errors.push("#{slug}: #{output}") unless output == 'OK'
        end
      end
      valid, message = valid_yaml_string?(metadata_fn)
      if !valid
        @errors.push(message)
      else
        metadata = YAML.load_file(metadata_fn)
        output = validate(metadata, slug)  
        @errors.push("#{slug}: #{output}") unless output == 'OK'
      end
    end
    if @errors.nil? or @errors.empty?
      return true
    else
      return false, @errors
    end
  end
  def valid_yaml_string?(yaml)
    begin
      !!YAML.load_file(yaml)
    rescue Exception => e
      return false, e.message
    end
  end
  def validate_media(media, slug)
    my_errors = []
    if media['sheet_music']
      media['sheet_music'].each do |sm|
        my_errors.push('need sheet_music slug') if sm['slug'].nil? or sm['slug'].empty?
        my_errors.push('need sheet_music name') if sm['name'].nil? or sm['name'].empty?
        if sm['music_files'].nil? or sm['music_files'].empty?
          my_errors.push("need music files for #{sm['slug']}")
        else
          sm['music_files'].each do |mf|
            my_errors.push('need music_file filename') if mf['filename'].nil? or mf['filename'].empty?
            my_errors.push("#{mf['filename']} does not exist") unless File.exists?("./#{slug}/#{mf['filename']}")
            my_errors.push('need music_file name') if mf['name'].nil? or mf['name'].empty?
          end
        end
      end
    end
    if media['audio']
      media['audio'].each do |aud|
        my_errors.push('need audio slug') if aud['slug'].nil? or aud['slug'].empty?
        my_errors.push('need ensemble') if aud['ensemble'].nil? or aud['ensemble'].empty?
        ens = YAML.load_file(@ensembles_yaml)
        my_errors.push("#{aud['ensemble']} not in ensembles.yaml") unless ens.detect { |e| e['slug'] == aud['ensemble']}
      end
    end
    if my_errors.nil? or my_errors.empty?
      return 'OK'
    else
      return my_errors
    end    
  end
  def validate(metadata, slug)
    #byebug
    my_errors = []
    my_errors.push('Need Title') if metadata['title'].nil? or metadata['title'].empty?
    my_errors.push('Need Person') if metadata['person'].nil? or metadata['person'].empty?
    my_errors.push('Need Category') if metadata['category'].nil? or metadata['category'].empty?
    if metadata['instructions'].nil? or metadata['instructions'].empty?
      my_errors.push('Need Instructions') 
    else
      metadata['instructions'].each do |inst|
        my_errors.push("#{inst['filename']} does not exist") unless File.exists?("./#{slug}/#{metadata['instructions'][0]["filename"]}")
      
        my_errors.push('instruction_type should be reconstruction or choreography') if inst['instruction_type'] != 'choreography' and inst['instruction_type'] != 'reconstruction'
        if inst['video']
          inst['video'].each do |vid|
            my_errors.push('need video name') if vid['name'].nil? or vid['name'].empty?
            my_errors.push('need youtube string') if vid['youtube'].nil? or vid['youtube'].empty?
          end
        end 
        if inst['sheet_music']
          media = YAML.load_file("./#{slug}/media.yaml")
          inst['sheet_music'].each do |sm|
            my_errors.push("#{sm} not in media.yaml sheet_music") unless media['sheet_music'].detect { |s| s['slug'] == sm}
          end
        end
        if inst['audio']
          media = YAML.load_file("./#{slug}/media.yaml")
          inst['audio'].each do |aud|
            my_errors.push("#{aud} not in media.yaml audio") unless media['audio'].detect { |s| s['slug'] == aud}
          end
        end
      end
      if metadata['sources']
        metadata['sources'].each do |src|
          my_errors.push('need source slug') if src['slug'].nil? or src['slug'].empty?  
          src_data = YAML.load_file(@sources_yaml)
          my_errors.push("#{src['slug']} not in source.yaml") unless src_data.detect { |s| s['slug'] == src['slug']}
          if src['images']
            src['images'].each do |img|
              my_errors.push("need image filename") if img['filename'].nil? or img['filename'].empty?
              my_errors.push("#{img['filename']} does not exist") unless File.exists?("./#{slug}/#{img['filename']}") 
              my_errors.push("need image name") if img['name'].nil? or img['name'].empty?
            end
          end
          if src['translations']
            src['translations'].each do |tr|
              my_errors.push("need translation url") if tr['url'].nil? or tr['url'].empty?
              my_errors.push("need translation name") if tr['name'].nil? or tr['name'].empty?
            end
          end
        end
      end #srcs
      

    end
    
    if my_errors.nil? or my_errors.empty?
      return 'OK'
    else
      return my_errors
    end    
  end
end
