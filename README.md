# metalink-ruby

Class to format Metalink 4 / rfc5854 / .meta4 XML

No code taken from timsjoberg/metalink-ruby


All rfc5854 metadata in the process of being supported. Only supporting sha-256, as reccomended by the spec - so no configuration options there.

Chunk checksumming is supported, for detecthing errors early on bad internet connections. Specify piece_size (in bytes) or piece_count.


Future development:
* usage samples
* more passed-in data validation.
