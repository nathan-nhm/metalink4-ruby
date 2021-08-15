
require 'builder'
require 'pathname'
require 'digest'
require 'mime/types'
require 'time'

##
# Describes the download urls of files listed in the Metalink 4 file
class Metalink4FileUrl
  attr_accessor :url,
    :priority,
    :location
  ##
  # Options: url, location, priority.
  # if only a string it profided it must be the URL.
  def initialize(url = {})
    self.priority = 1
    case url
    when String
      self.url = url
    when Hash
      self.url = url[:url]
      self.location = url[:location]
      self.priority = url[:priority]
    else
      raise "URL format"
    end
  end

  ##
  # URI of remote file, HTTPS, HTTP, FTP, Bittorrent, etc.
  def url=(v)
    @url = URI.parse(v)
  end
  
  ##
  # ISO3166-1 2 character country code
  def location=(v)
    raise "Improper format" if v && v.to_s !~ /[a-z]{2}/
    @location = v
  end
  
  ##
  # Priority this url is to be considered in. 1 is top level, 999999 is absolulte last. Duplicates allowed.
  def priority=(v)
    @priority = [[v.to_i, 1].max, 999999].min 
  end
  
  ##
  # Fragement call for builder.
  def render(builder_metalink_file, local_path)
    if MIME::Types.type_for(local_path.to_s).first == MIME::Types.type_for( self.url.path ).first
      builder_metalink_file.url(
        self.url.to_s, {
        location: self.location,
        priority: self.priority || 1,
        }.compact
        )
    else
      builder_metalink_file.metaurl(
        self.url.to_s, {
        priority: self.priority || 1,
        mediatype: self.url.path =~ /\.torrent/ ? "torrent" : MIME::Types.type_for( self.url.path )
        }.compact
        )
    end
  end
end

##
#Describes the files listed in the Metalink 4 file
class Metalink4File

  attr_accessor :init,
    :local_path,
    :copyright,
    :description,
    :identity,
    :language,
    :logo,
    :os,
    :urls,
    :publisher_name,
    :publisher_url,
    :signature,
    :version,
    :piece_size,
    :piece_count
    
  ##
  # Options: local_path, copyright, description, identity, language, logo, os, urls, publisher_name, publisher_url, signature, version, piece_size, piece_count
  def initialize(file = {})
  
    raise "local path required" unless file.fetch(:local_path, nil)
  
    self.init = file
  
    self.local_path = file[:local_path]
    self.copyright = file.fetch(:copyright, nil)
    self.description = file.fetch(:description, nil)
    self.identity = file.fetch(:identity, nil)
    self.language = file.fetch(:language, nil)
    self.logo = file.fetch(:logo, nil)
    self.os = file.fetch(:os, nil)

    self.urls = []
    file.fetch(:urls, []).each do |url|
      self.urls << Metalink4FileUrl.new(url)
    end
      
    self.publisher_name = file.fetch(:publisher_name, nil)
    self.publisher_url = file.fetch(:publisher_url, nil) ? URI.parse(file.fetch(:publisher_url, nil)) : nil
    self.signature = file.fetch(:signature, nil)
    self.version = file.fetch(:version, nil)
    
    self.piece_size = file.fetch(:piece_size, nil) 
    self.piece_count = file.fetch(:piece_count, nil) 
  end
  
  ##
  # Path of local instance of file, relative to current working directory. 
  # relative path may be reproduced on the client side. MUST NOT include '.' or '..'
  # Must not include an absolute path ( begin with / or drive letter )
  #
  # use File.chdir if you must to achive this
  def local_path=(v)
    @local_path = Pathname.new(v)
    raise "No absolute paths" if @local_path.absolute?
    raise "No dots" if @local_path.to_s =~ /\.\/|\.\\/
    @local_path
  end
  
  ##
  # Overrides piece_count if set
  # minimum size of 1KB for a piece
  def piece_size=(v)
    return unless v
    @piece_count = nil
    @piece_size = [v, 1024].max
  end

  ##
  # Overrides piece_size if set
  # This will be a multiple of 1024, and the last file will be slightly smaller
  # this means 1KB is the minimum size for a piece
  def piece_count=(v)
    return if v.nil?
    @piece_count = v
    @piece_size = ((@local_path.size / v) / 1024.0).ceil * 1024 
  end
  
  
  
  ##
  # Fragement call for builder.
  def render(builder_metalink, metalink4)
    metalink4.file( name: self.local_path ) do |metalink_file| #MUST MANY, name is path/file no dots, no beginning with slash
      metalink_file.copyright( self.copyright ) if self.copyright #MAY ONE, human readable
      metalink_file.description( self.description ) if self.description #RECOMMENDED ONE, human readable
    
      metalink_file.identity( self.identity ) if self.identity # MAY ONE, human readable
        
      metalink_file.hash( Digest::SHA256.file( self.local_path ).hexdigest, type: "sha-256" ) #MAY MANY
      metalink_file.language( self.language ) if self.language #MAY MANY, rfc5646
        
      metalink_file.logo( self.logo ) if self.logo #MAY ONE, url, square, low res compatible
      metalink_file.os( self.os ) if self.os #MAY MANY, IANA registry named "Operating System Names"

      self.urls.each do |file_url|
        file_url.render(
          metalink_file,
          self.local_path
          )
      end

      if self.piece_size
        metalink_file.pieces( length: self.piece_size, type: "sha-256" ) do |pieces| #MAY MANY, length is byte length of all chunks but the last
          (0...self.local_path.size).step(self.piece_size).each do |offset|
            pieces.hash Digest::SHA256.hexdigest(File.read(self.local_path, self.piece_size, offset))
          end
        end
      end
          
      metalink_file.publisher( name: self.publisher_name, url: self.publisher_url.to_s) if self.publisher_name || self.publisher_url #MAY ONE, human readable name & URI
      metalink_file.signature( self.signature, mediatype: MIME::Types.type_for( self.signature ) ) if self.signature #MAY MANY, application/pgp-signature or somthing
    
      metalink_file.size( self.local_path.size ) #SHOULD, file bytesize
      metalink_file.version( self.version ) if self.version #MAY ONE, 3.5 for firefox 3.5
    end
  end
  
end

##
# Describes the base Metalink 4 file as specified by rfc5854
# If served, it should have a header of application/metalink4+xml
# https://en.wikipedia.org/wiki/Metalink
class Metalink4


  attr_accessor :files,
    :published,
    :updated,
    :origin,
    :origin_dynamic,
    :xml
    
    
    
  ##
  # Options: files, published, updated, origin, origin_dynamic
  def initialize(opts = {})
  
    raise "files not specified" if opts.fetch(:files, []).empty?
  
    opts = opts.transform_keys {|key| key.to_sym }
  
    self.files = []
    
    opts.fetch(:files).each do |file|
      self.files << Metalink4File.new(file)
    end

    self.published = opts.fetch(:published, nil)
    self.updated = opts.fetch(:updated, nil)
    self.origin = opts.fetch(:origin, nil)
    self.origin_dynamic = opts.fetch(:origin_dynamic, false)

    self.xml = Builder::XmlMarkup.new(indent: 2)
  end
  
  ##
  # original publish date. Equivelent of ActiveRecord's created_at
  def published=(v)
    case v
    when Time, nil
      @published = v
    when String
      @published = Time.parse(v)
    else
      raise "Not a Time"
    end
    @published 
  end
  
  ##
  # last publish date. Equivelent of ActiveRecord's updated_at
  def updated=(v)
    case v
    when Time, nil
      @updated = v
    when String
      @updated = Time.parse(v)
    else
      raise "Not a Time"
    end
    @updated 
  end
  
  ##
  # url this meta4 file was made available at. Updates are potentially at the same url.
  def origin=(v)
    @origin = v ? URI.parse(v) : nil
  end
  
  ##
  # if the meta4 file may have an update available
  def origin_dynamic=(v)
    @origin = !!v
  end
  

  ##
  # Render to XML
  def render
    self.xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
    self.xml.metalink( xmlns: "urn:ietf:params:xml:ns:metalink" ) do |metalink| #must
    
      metalink.generator("Sudrien/metalink-ruby 0.2.0") #may
      metalink.origin( self.origin, dynamic: self.origin_dynamic ) if self.origin #should
      
      metalink.published( self.published.strftime('%FT%T%:z') ) if self.published #may, earlier
      metalink.updated( self.updated.strftime('%FT%T%:z') ) if self.updated #may, later
    
    
      self.files.each do |file|
        file.render(self, metalink)
      end
    end
    self.xml.target!
  end


end
