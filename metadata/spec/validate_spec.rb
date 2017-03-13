require 'spec_helper'
describe "validate" do
  context "basic data" do
    before(:each) do
      @metadata = YAML.load_file('./spec/fixtures/basic.yaml')  
      @validator = Validator.new
      @slug = 'slug'
      Dir.mkdir("./slug")
      `touch ./slug/terp.md`
    end
    after(:each) do
      FileUtils.rm_r "./slug" 
    end
    it "Outputs OK" do
      val = @validator.validate(@metadata,@slug)
      expect(val).to eq('OK')
    end
    it "rejects empty title" do
      @metadata["title"] = ""
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('Need Title')
    end
    it "rejects nil title" do
      @metadata["title"] = nil
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('Need Title')
    end
    it "rejects empty person" do
      @metadata["person"] = ""
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('Need Person')
    end
    it "rejects nil person" do
      @metadata["person"] = nil
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('Need Person')
    end
    it "rejects empty category" do
      @metadata["category"] = ""
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('Need Category')
    end
    it "rejects nil category" do
      @metadata["category"] = nil
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('Need Category')
    end
    it "rejects empty instructions" do
      @metadata["instructions"] = ""
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('Need Instructions')
    end
    it "rejects nil instructions" do
      @metadata["instructions"] = nil
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('Need Instructions')
    end
    it 'rejects if markdown file does not exist' do
      @metadata['instructions'][0]['filename'] = 'not_there.md'
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('not_there.md does not exist')
    end
    it 'passes if instruction_type is choreography' do
      @metadata['instructions'][0]['instruction_type'] = 'choreography'
      val = @validator.validate(@metadata,@slug)
      expect(val).to eq('OK')
    end
    it 'rejects if instruction_type is not choreography or reconstruction' do
      @metadata['instructions'][0]['instruction_type'] = 'blahblahblah'
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('instruction_type should be reconstruction or choreography')
    end
    it 'rejects empty name for video' do
      @metadata['instructions'][0]['video'][0]['name'] = ''
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('need video name')
    end
    it 'rejects nil name for video' do
      @metadata['instructions'][0]['video'][0]['name'] = nil
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('need video name')
    end
    it 'rejects empty youtube for video' do
      @metadata['instructions'][0]['video'][0]['youtube'] = ''
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('need youtube string')
    end
    it 'rejects nil youtube for video' do
      @metadata['instructions'][0]['video'][0]['youtube'] = nil
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('need youtube string')
    end

  end
  context 'Facsimile Images and Translations' do
    before(:each) do
      @metadata = YAML.load_file('./spec/fixtures/images.yaml')  
      @validator = Validator.new('../sources.yaml')
      @slug = 'slug'
      Dir.mkdir("./slug")
      `touch ./slug/terp.md`
      `touch ./slug/image.gif`
    end
    after(:each) do
      FileUtils.rm_r "./slug" 
    end
    it 'rejects empty source slug' do
      @metadata['sources'][0]['slug'] = ''
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('need source slug')
    end
    it 'rejects nil source slug' do
      @metadata['sources'][0]['slug'] = nil
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('need source slug')
    end
    it 'rejects empty source slug' do
      @metadata['sources'][0]['slug'] = 'not_a_slug'
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('not_a_slug not in source.yaml')
    end
    it 'rejects if image filename is empty' do
      @metadata['sources'][0]['images'][0]['filename'] = ''
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('need image filename')
    end
    it 'rejects if image filename is nil' do
      @metadata['sources'][0]['images'][0]['filename'] = nil 
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('need image filename')
    end
    it 'rejects if image filename does not exist' do
      @metadata['sources'][0]['images'][0]['filename'] = 'not_a_file.jpg'
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('not_a_file.jpg does not exist')
    end
    it 'rejects if image name is empty' do 
      @metadata['sources'][0]['images'][0]['name'] = ''
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('need image name')
    end
    it 'rejects if image name is nil' do 
      @metadata['sources'][0]['images'][0]['name'] = nil
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('need image name')
    end
    it 'rejects if translation url is empty' do 
      @metadata['sources'][0]['translations'][0]['url'] = ''
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('need translation url')
    end
    it 'rejects if translation url is nil' do 
      @metadata['sources'][0]['translations'][0]['url'] = nil 
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('need translation url')
    end
    it 'rejects if translation name is empty' do 
      @metadata['sources'][0]['translations'][0]['name'] = ''
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('need translation name')
    end
    it 'rejects if translation name is nil' do 
      @metadata['sources'][0]['translations'][0]['name'] = nil 
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('need translation name')
    end
  end
  context 'Sheet Music and Media' do
    before(:each) do
      @metadata = YAML.load_file('./spec/fixtures/basic_media.yaml')  
      @validator = Validator.new('../sources.yaml')
      @slug = 'slug'
      Dir.mkdir("./slug")
      `touch ./slug/terp.md`
      `touch ./slug/image.gif`
      `cp ./spec/fixtures/media.yaml ./slug/`
    end
    after(:each) do
      FileUtils.rm_r "./slug" 
    end
    it 'passes valid metadata' do
      val = @validator.validate(@metadata,@slug)
      expect(val).to eq('OK')
    end
    it 'rejects sheet music not in media.yaml' do
      @metadata['instructions'][0]['sheet_music'][0] = 'blah_blah'
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('blah_blah not in media.yaml sheet_music')

    end
    it 'rejects audio not in media.yaml' do
      @metadata['instructions'][0]['audio'][0] = 'blah_blah'
      val = @validator.validate(@metadata,@slug)
      expect(val[0]).to eq('blah_blah not in media.yaml audio')
    end
  end 
end
describe 'validate_media' do
  before(:each) do
    @media = YAML.load_file('./spec/fixtures/media.yaml')  
    @validator = Validator.new('../sources.yaml','../ensembles.yaml')
    @slug = 'slug'
    Dir.mkdir("./slug")
    `touch ./slug/gathering_peascods.pdf`
    `touch ./slug/peascods.mp3`
  end
  after(:each) do
    FileUtils.rm_r "./slug" 
  end
  it 'accepts valid media metadata' do 
    val = @validator.validate_media(@media,@slug)
    expect(val).to eq('OK')
  end
  it 'rejects empty sheet_music slug' do
    @media['sheet_music'][0]['slug'] = ''
    val = @validator.validate_media(@media,@slug)
    expect(val[0]).to eq('need sheet_music slug')
  end
  it 'rejects nil sheet_music slug' do
    @media['sheet_music'][0]['slug'] = nil
    val = @validator.validate_media(@media,@slug)
    expect(val[0]).to eq('need sheet_music slug')
  end
  it 'rejects empty sheet_music name' do
    @media['sheet_music'][0]['name'] = ''
    val = @validator.validate_media(@media,@slug)
    expect(val[0]).to eq('need sheet_music name')
  end
  it 'rejects nil sheet_music name' do
    @media['sheet_music'][0]['name'] = nil
    val = @validator.validate_media(@media,@slug)
    expect(val[0]).to eq('need sheet_music name')
  end

  it 'rejects empty music_files' do
    @media['sheet_music'][0]['music_files'] = ''
    val = @validator.validate_media(@media,@slug)
    expect(val[0]).to eq("need music files for #{@media['sheet_music'][0]['slug']}")
  end
  it 'rejects nil music_files' do
    @media['sheet_music'][0]['music_files'] = nil
    val = @validator.validate_media(@media,@slug)
    expect(val[0]).to eq("need music files for #{@media['sheet_music'][0]['slug']}")
  end
  it 'rejects empty music_file filename' do
    @media['sheet_music'][0]['music_files'][0]['filename'] = ''
    val = @validator.validate_media(@media,@slug)
    expect(val[0]).to eq("need music_file filename")
  end
  it 'rejects nil music_file filename' do
    @media['sheet_music'][0]['music_files'][0]['filename'] = nil
    val = @validator.validate_media(@media,@slug)
    expect(val[0]).to eq("need music_file filename")
  end
  it 'rejects non existant music_file file' do
    @media['sheet_music'][0]['music_files'][0]['filename'] = 'does_not_exist.pdf'
    val = @validator.validate_media(@media,@slug)
    expect(val[0]).to eq("does_not_exist.pdf does not exist")
    
  end
  it 'rejects empty music_file name' do
    @media['sheet_music'][0]['music_files'][0]['name'] = ''
    val = @validator.validate_media(@media,@slug)
    expect(val[0]).to eq("need music_file name")
  end
  it 'rejects nil music_file name' do
    @media['sheet_music'][0]['music_files'][0]['name'] = nil
    val = @validator.validate_media(@media,@slug)
    expect(val[0]).to eq("need music_file name")
  end

  it 'rejects empty audio slug' do
    @media['audio'][0]['slug'] = ''
    val = @validator.validate_media(@media,@slug)
    expect(val[0]).to eq('need audio slug')
  end
  it 'rejects nil audio slug' do
    @media['audio'][0]['slug'] = nil
    val = @validator.validate_media(@media,@slug)
    expect(val[0]).to eq('need audio slug')
  end
  it 'rejects empty ensemble' do
    @media['audio'][0]['ensemble'] = ''
    val = @validator.validate_media(@media,@slug)
    expect(val[0]).to eq('need ensemble')
  end
  it 'rejects nil ensemble' do
    @media['audio'][0]['ensemble'] = nil
    val = @validator.validate_media(@media,@slug)
    expect(val[0]).to eq('need ensemble')
  end
  it 'rejects ensemble not in ensembles.yaml' do
    @media['audio'][0]['ensemble'] = 'blah_blah'
    val = @validator.validate_media(@media,@slug)
    expect(val[0]).to eq('blah_blah not in ensembles.yaml')
  end
end
