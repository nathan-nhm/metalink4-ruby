# metalink4-ruby

Class to format Metalink 4 / rfc5854 / .meta4 XML

No code taken from timsjoberg/metalink-ruby


All rfc5854 metadata in the process of being supported. Only supporting sha-256, as reccomended by the spec - so no configuration options there.

Chunk checksumming is supported, for detecting errors early on bad internet connections. Specify piece_size (in bytes) or piece_count.






## wget example
(Gentoo did not have metalink USE flag enabled by default)

Download all files? 1MB.meta4.#1 a result, not obvious how to get correct filename
> wget --input-metalink=test/1MB.meta4 

Download single file on that list, supposedly
> wget --input-metalink=test/1MB.meta4 --metalink-index=1

More: https://www.gnu.org/software/wget/manual/html_node/Logging-and-Input-File-Options.html


## aria2c example
(Gentoo did not have metalink USE flag enabled by default)

Show file list
> aria2c test/1MB.meta4 -S

Download single file on that list
> aria2c test/1MB.meta4 --select-file=1

Check integrity of any files on disk instead of overwriting
> aria2c test/1MB.meta4 --check-integrity=true

More: https://aria2.github.io/manual/en/html/aria2c.html#bittorrent-metalink-options https://aria2.github.io/manual/en/html/aria2c.html#metalink-specific-options


## Future development / documentation
* usage samples
* more passed-in data validation.
