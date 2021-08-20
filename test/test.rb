#!/usr/bin/env ruby

require_relative '../lib/metalink4'


=begin
File.open('test/16.meta4', 'w') { |f| f.write(

Metalink4.new(
  published: "2009-05-15T12:23:23Z",
  files: [ {
    local_path: "test/10mb.bin",
    identity: "Example",
    language: "en",
    description: "A description of the example file for download.",
    version: 1.0,
    urls: [
      "https://raw.githubusercontent.com/Sudrien/metalink4-ruby/main/test/10mb.bin",
      { url: "http://download.xs4all.nl/test/10mb.bin", location: "nl", priority: 2 },
      { url: "https://raw.githubusercontent.com/Sudrien/metalink4-ruby/main/test/10mb.bin.torrent", priority: 3 }
      ],
    piece_count: 16
    } ]
  ).render
) }


File.open('test/1MB.meta4', 'w') { |f| f.write(
 Metalink4.new(
  published: "2009-05-15T12:23:23Z",
  files: [ {
    local_path: "test/10mb.bin",
    identity: "Example",
    language: "en",
    description: "A description of the example file for download.",
    version: 1.0,
    urls: [
      "https://raw.githubusercontent.com/Sudrien/metalink4-ruby/main/test/10mb.bin",
      { url: "http://download.xs4all.nl/test/10mb.bin", location: "nl", priority: 2 },
      { url: "https://raw.githubusercontent.com/Sudrien/metalink4-ruby/main/test/10mb.bin.torrent", priority: 3 }
      ],
    piece_size: 1024 ** 2
    } ]
  ).render
) }


File.open('test/single.meta4', 'w') { |f| f.write(
 Metalink4.new(
  published: "2009-05-15T12:23:23Z",
  files: [ {
    local_path: "test/10mb.bin",
    identity: "Example",
    language: "en",
    description: "A description of the example file for download.",
    version: 1.0,
    urls: [
      "https://raw.githubusercontent.com/Sudrien/metalink4-ruby/main/test/10mb.bin",
      { url: "http://download.xs4all.nl/test/10mb.bin", location: "nl", priority: 2 },
      { url: "https://raw.githubusercontent.com/Sudrien/metalink4-ruby/main/test/10mb.bin.torrent", priority: 3 }
      ]
    } ]
  ).render
) }


File.open('test/single_again.meta4', 'w') { |f| f.write(
  Metalink4.read('test/single.meta4').render
) }

File.open('test/1MB_again.meta4', 'w') { |f| f.write(
  Metalink4.read('test/1MB.meta4').render
) }


=end



File.open('test/full.meta4', 'w') { |f| 

  full = Metalink4.new
  full.published = Time.now
  full.updated = Time.now
  full.origin = "https://raw.githubusercontent.com/Sudrien/metalink4-ruby/main/test/full.meta4"
  full.origin_dynamic = true
    
  full.files << Metalink4File.new
  full.files.last.local_path = "10mb_stuff.bin"
  full.files.last.checksum!("test/10mb.bin", piece_count: 3, debug: true)
  full.files.last.copyright = %Q(MIT License

Copyright (c) 2021 Sudrien

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.)
  

      full.files.last.description = "10 Megabyte binary test file"
      full.files.last.identity = "10mb"
      full.files.last.language = ["en","nl"]
      full.files.last.language << "fr" #should append
      full.files.last.logo = "https://avatars.githubusercontent.com/u/24167"
      full.files.last.os = ["WIN64","LINUX"]
      full.files.last.os = "FREEBSD" #should replace
      
      full.files.last.publisher_name = "Sudrien"
      full.files.last.publisher_url = "https://sudrien.net/"
      full.files.last.signature = %Q(-----BEGIN PGP SIGNATURE-----

iQGzBAABCAAdFiEE4aCsdxZbNnMhEdEGV40AumdeEVQFAmEfC/wACgkQV40Aumde
EVRrzQv6AgJjZHqVTx0pYDZW+JeNtXx/Yh/H5YR5Whi0VRi9r67zZ2vXKf99yfru
H57wVHYYXO2Nv7NbwXiZmKAzD0w3r220n2DRWejENOtZ21JuE6bjeWs1FAVUfZ1q
I2EtSn/qwZaML+Pw8OmF75U1Yp20F5um8MY/yw0ZhO8FT89QkpFChRct+39Ls1MG
JYSUDJKY4dEzO6nD6pwO2LUwaZUezbgDDhqp+sg2ouQUtLfA7kJgk2hzJ9xPm6W8
VRsUKoJIriVZ7iCJTnfzG7Y2lM5FHT5gGtBgoEXTPaImTgVgrQBNGfJQ9MBClzaW
6UE85/DMs0rPo/a9qP/5vme7ngze7va9VrP7VgRYDsDhGQpoGxf0k3r9YKPjto/T
90H4SGOGANBaFnXSN2NlkFOP5HFTKKYvIQkP86lA9AHR/ti9PdtsHvYEcN38LSZ5
AayZrrvbUIDUPOu1Qenjk037T804UT/Rbe6UmY5Yx2bG+BrpsPPLmGQdT2cGLbUD
dicaRy/5
=Ixe6
-----END PGP SIGNATURE-----
)
      full.files.last.version = 1.0
      
	  full.files.last.urls << Metalink4FileUrl.new("https://raw.githubusercontent.com/Sudrien/metalink4-ruby/main/test/10mb.bin")
	  
	  
	  full.files.last.urls << Metalink4FileUrl.new
      full.files.last.urls.last.url = "http://download.xs4all.nl/test/10mb.bin"
      full.files.last.urls.last.location = "nl"
      full.files.last.urls.last.priority = 2

      full.files.last.urls << Metalink4FileUrl.new
      full.files.last.urls.last.url = "https://raw.githubusercontent.com/Sudrien/metalink4-ruby/main/test/10mb.bin.torrent"
      full.files.last.urls.last.priority = 3

  

  f.write(full.render)

  }
