#!/usr/bin/env ruby

require_relative '../metalink'

File.open('test/16.meta4', 'w') { |f| f.write(

Metalink.new(
  published: "2009-05-15T12:23:23Z",
  piece_count: 16,
  files: [ {
    local_path: "test/10mb.bin",
    identity: "Example",
    language: "en",
    description: "A description of the example file for download.",
    version: 1.0,
    urls: [
      "https://raw.githubusercontent.com/Sudrien/metalink-ruby/main/test/10mb.bin",
      { url: "http://download.xs4all.nl/test/10mb.bin", location: "nl"},
      { url: "https://raw.githubusercontent.com/Sudrien/metalink-ruby/main/test/10mb.bin.torrent", priority: 2 }
      ]
    } ]
  ).render
) }


File.open('test/1MB.meta4', 'w') { |f| f.write(
 Metalink.new(
  published: "2009-05-15T12:23:23Z",
  piece_size: 1024 ** 2,
  files: [ {
    local_path: "test/10mb.bin",
    identity: "Example",
    language: "en",
    description: "A description of the example file for download.",
    version: 1.0,
    urls: [
      "https://raw.githubusercontent.com/Sudrien/metalink-ruby/main/test/10mb.bin",
      { url: "http://download.xs4all.nl/test/10mb.bin", location: "nl"},
      { url: "https://raw.githubusercontent.com/Sudrien/metalink-ruby/main/test/10mb.bin.torrent", priority: 2 }
      ]
    } ]
  ).render
) }


File.open('test/single.meta4', 'w') { |f| f.write(
 Metalink.new(
  published: "2009-05-15T12:23:23Z",
  files: [ {
    local_path: "test/10mb.bin",
    identity: "Example",
    language: "en",
    description: "A description of the example file for download.",
    version: 1.0,
    urls: [
      "https://raw.githubusercontent.com/Sudrien/metalink-ruby/main/test/10mb.bin",
      { url: "http://download.xs4all.nl/test/10mb.bin", location: "nl"},
      { url: "https://raw.githubusercontent.com/Sudrien/metalink-ruby/main/test/10mb.bin.torrent", priority: 2 }
      ]
    } ]
  ).render
) }
