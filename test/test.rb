#!/usr/bin/env ruby

require '../metalink'

puts Metalink.new(
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
