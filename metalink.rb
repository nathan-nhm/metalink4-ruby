
#require './metalink'
#Metalink.new("example.ext", time: "2009-05-15T12:23:23Z", identity: "Example", version: 1.0, language: "en", description: "A description of the example file for download.", urls: [ "ftp://ftp.example.com/example.ext", { url: "http://example.com/example.ext", location: "fr"}, { url: "http://example.com/example.ext.torrent", priority: 2 } ]).render

require 'builder'
require 'pathname'
require 'digest'

class Metalink

  # application/metalink4+xml
  # https://en.wikipedia.org/wiki/Metalink

  attr_accessor :pathname,
	:identity,
	:version,
	:language,
	:description,
	:time,
	:urls,
	:xml

  def initialize(file, opts = {})
  
	opts = opts.transform_keys {|key| key.to_sym }
  
    self.pathname = Pathname.new(file)
    self.identity = opts.fetch(:identity, nil)
    self.version = opts.fetch(:version, nil)
    self.language = opts.fetch(:language, nil)
    self.description = opts.fetch(:description, nil)
    self.time = opts.fetch(:time, nil).is_a?(Time) ? opts.fetch(:time, nil) : Time.now
  
    self.urls = []
    
    opts.fetch(:urls, []).each do |url|
      case url
      when String
		self.urls << {url: url, priority: 1 }
	  when Hash
		self.urls << {url: url[:url], location: url[:location], priority: [url[:priority].to_i, 1].max }.compact
	  else
	    raise "URL format"
	  end
	  
	  case self.urls.last[:url]
      when /\.torrent/
		self.urls.last[:mediatype] = "torrent"
	  else
		nil
	  end
    end
    
    
    self.xml = Builder::XmlMarkup.new
  end

  def render
	self.xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
    self.xml.metalink( :xmlns => "urn:ietf:params:xml:ns:metalink" ) do |metalink|
      metalink.published( self.time.strftime('%FT%T%:z') )
      metalink.file do |file|
        file.size( pathname.size )
        file.identity( self.identity ) if self.identity
        file.version( self.version ) if self.version
        file.language( self.language ) if self.language
        file.description( self.description ) if self.description
        file.hash( Digest::SHA256.file( self.pathname ).hexdigest, type: "sha-256" )
        self.urls.each do |url|
		  case url[:mediatype]
		  when "torrent"
			file.metaurl( url[:url], url.tap { |hs| hs.delete(:url) } )
		  else
			file.url( url[:url], url.tap { |hs| hs.delete(:url) } )
		  end
		end
      end
	end
    self.xml.target!
  end


end
