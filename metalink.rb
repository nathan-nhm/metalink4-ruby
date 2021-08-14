
#require './metalink'
#Metalink.new( published: "2009-05-15T12:23:23Z", files: [ {local_path: "example.ext", identity: "Example",  language: "en", description: "A description of the example file for download.", version: 1.0, urls: [ "ftp://ftp.example.com/example.ext", { url: "http://example.com/example.ext", location: "fr"}, { url: "http://example.com/example.ext.torrent", priority: 2 } ] } ]).render

require 'builder'
require 'pathname'
require 'digest'
require 'mime/types'

class Metalink

  # application/metalink4+xml
  # https://en.wikipedia.org/wiki/Metalink

  attr_accessor :files,
    :published,
    :updated,
    :origin,
    :origin_dynamic,
    :xml

  def initialize(opts = {})
  
    raise "files not specified" if opts.fetch(:files, []).empty?
  
    opts = opts.transform_keys {|key| key.to_sym }
  
    self.files = []
    
    opts.fetch(:files).each do |file|
    
    
      self.files << {}
      
      self.files.last[:local_path] = Pathname.new(file[:local_path])
		
      self.files.last[:copyright] = file.fetch(:copyright, nil)
      self.files.last[:description] = file.fetch(:description, nil)
      self.files.last[:identity] = file.fetch(:identity, nil)
      self.files.last[:language] = file.fetch(:language, nil)
      self.files.last[:logo] = file.fetch(:logo, nil)
      self.files.last[:os] = file.fetch(:os, nil)

      self.files.last[:urls] = []
      self.files.last[:metaurls] = []
    
      file.fetch(:urls, []).each do |url|
      
        url_hash = {}
    
        case url
        when String
          url_hash = {url: URI.parse(url), priority: 1 }
        when Hash
          url_hash = {url: URI.parse(url[:url]), location: url[:location], priority: [[url[:priority].to_i, 1].max, 999999].min }.compact #location is 2 char, [ISO3166-1] alpha-2
        else
          raise "URL format"
        end

        if MIME::Types.type_for(self.files.last[:local_path].to_s).first == MIME::Types.type_for( url_hash[:url].path ).first
          self.files.last[:urls] << url_hash
        else
          case url_hash[:url].path
          when /\.torrent/
            url_hash[:mediatype] = "torrent"
          when /\./
            url_hash[:mediatype] = MIME::Types.type_for( self.urls.last[:url] )
          end
        self.files.last[:metaurls] << url_hash
        end
      end
      
      self.files.last[:publisher_name] = file.fetch(:publisher_name, nil)
      self.files.last[:publisher_url] = file.fetch(:publisher_url, nil) ? URI.parse(file.fetch(:publisher_url, nil)) : nil
      self.files.last[:signature] = file.fetch(:signature, nil)
      self.files.last[:version] = file.fetch(:version, nil)
    end
    



    self.published = opts.fetch(:published, nil).is_a?(Time) ? opts.fetch(:published, nil) : nil
    self.updated = opts.fetch(:updated, nil).is_a?(Time) ? opts.fetch(:updated, nil) : nil
    self.origin = opts.fetch(:origin, nil) ? URI.parse(opts.fetch(:origin, nil)) : nil
    self.origin_dynamic = opts.fetch(:origin_dynamic, false)
  
 
    self.xml = Builder::XmlMarkup.new
  end

  def render
    self.xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
    self.xml.metalink( xmlns: "urn:ietf:params:xml:ns:metalink" ) do |metalink| #must
    
      metalink.generator("Sudrien/metalink-ruby 0.1") #may
      metalink.origin( self.origin, dynamic: self.origin_dynamic ) if self.origin #should
      
      metalink.published( self.published.strftime('%FT%T%:z') ) if self.published #may, earlier
      metalink.updated( self.updated.strftime('%FT%T%:z') ) if self.updated #may, later
    
    
      self.files.each do |file|
        metalink.file( name: file[:local_path] ) do |metalink_file| #MUST MANY, name is path/file no dots, no beginning with slash
          metalink_file.copyright( file[:copyright] ) #MAY ONE, human readable
          metalink_file.description( file[:description] ) if file[:description] #RECOMMENDED ONE, human readable
    
          metalink_file.identity( file[:identity] ) if file[:identity] # MAY ONE, human readable
        
          metalink_file.hash( Digest::SHA256.file( file[:local_path] ).hexdigest, type: "sha-256" ) #MAY MANY
          metalink_file.language( file[:language] ) if file[:language] #MAY MANY, rfc5646
        
          metalink_file.logo( file[:logo] ) if file[:logo] #MAY ONE, url, square, low res compatible
          metalink_file.os( file[:os] ) if file[:os] #MAY MANY, IANA registry named "Operating System Names"
        
        
          file[:urls].each do |url| #MUST
            metalink_file.url( url[:url].to_s, url.tap { |hs| hs.delete(:url) } )
          end
          
          file[:metaurls].each do |url| #MUST
            metalink_file.metaurl( url[:url].to_s, url.tap { |hs| hs.delete(:url) } )
          end
    
          metalink_file.pieces( length: nil, type: "sha-256" ) do |pieces| #MAY MANY, lenth is byt length of all chunks but the last
            pieces.hash nil
          end
          
          metalink_file.publisher(name: file[:publisher_name], url: file[:publisher_url].to_s) if file[:publisher_name] || file[:publisher_url] #MAY ONE, human readable name & URI
          metalink_file.signature(file[:signature], mediatype: MIME::Types.type_for(file[:signature]) ) if file[:signature] #MAY MANY, application/pgp-signature or somthing
    
          metalink_file.size( file[:local_path].size ) #SHOULD, file bytesize
          metalink_file.version( file[:version] ) if file[:version] #MAY ONE, 3.5 for firefox 3.5
    
        end #metalink_file
      end #self.files.each
    end
    self.xml.target!
  end


end
