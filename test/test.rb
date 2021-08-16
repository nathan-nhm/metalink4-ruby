#!/usr/bin/env ruby

require_relative '../lib/metalink4'

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
  Metalink4.read('test/1MB.meta4').render
) }
