# metalink4-ruby

Class to format Metalink 4 / rfc5854 / .meta4 XML


All rfc5854 metadata is supported, as well as Chunk checksumming, for
detecting errors early on bad internet connections - see piece_size and
piece_count options. 

All internally generated checksums are sha-256. Other checksum types
must be calculates externally and passed in.


No code taken from timsjoberg/metalink-ruby.

[![Gem Version](https://badge.fury.io/rb/metalink4-ruby.svg)](https://badge.fury.io/rb/metalink4-ruby)

## Installation

Requirements:

- Ruby >= 2.0

``` sh
$ gem install metalink4-ruby
```

- Ruby = 1.9.3

``` sh
$ gem install mime-types -v="2.99.3"
$ gem install metalink4-ruby --conservative
```

## Generation Examples

Please see https://github.com/Sudrien/metalink4-ruby/blob/main/test/test.rb


## Download Examples

metalink4-ruby 1.0.0 allows for the parsing of external meta4 files, but
does not support downloading and verifying checksums, as metalink supports
the listing of many protocols.

A presumed outdated list of clients is available at http://www.metalinker.org/implementation.html

Here is a partial list for convienece of easily scriptable programs for
convienence.

### curl
As of 7.78.0, curl removed Metalink support, rather than support a 'failure'
over a 'warning' when checksums did not match.

See: https://curl.se/docs/CVE-2021-22922.html




### aria2c example (recommended)
(Note: It is possible to compile binaries without metalink support)

Show file list
> aria2c test/1MB.meta4 -S

Download single file on that list
> aria2c test/1MB.meta4 --select-file=1

Check integrity of any files on disk instead of overwriting
> aria2c test/1MB.meta4 --check-integrity=true

More:
* https://aria2.github.io/manual/en/html/aria2c.html#bittorrent-metalink-options
* https://aria2.github.io/manual/en/html/aria2c.html#metalink-specific-options
  



### wget example (partial support)
(Note: It is possible to compile binaries without metalink support)

Download all files? 1MB.meta4.#1 a result, not obvious how to get correct filename
> wget --input-metalink=test/1MB.meta4 

Download single file on that list, supposedly
> wget --input-metalink=test/1MB.meta4 --metalink-index=1

More:
* https://www.gnu.org/software/wget/manual/html_node/Logging-and-Input-File-Options.html
