# Sexy Back

<blockquote><pre>
I'm bringin' sexy back
Them other boys don't know how to act
I think it's special what's behind your back
So turn around and I'll pick up the slack
(Take 'em to the bridge)
</pre></blockquote>

OK, so here we are, at the bridge. Is sexyback just another mildly offensive
Ruby gem? **Awww hell no!** sexyback makes using Cassandra really, well,
awesomer.

Like JT, sexyback thinks it's special what's behind your back...end, per se.
Cassandra has a neat data model that is horribly explained in most docs. But if
you think about it in terms of the data structures that you can implement in
Cassandra, it's pretty rad.

A further similarity to Justin Timberlake, sexyback picks up the slack. It
gives you a library of nifty data structures that you can work with in
Cassandra. Most of them guarantee atomic operations; others require a lock and
multiple writes to do their nifty thing.

## The sexy

Atomic types:

- Append-only list
- Hash
- Set
- Lock
- Scoreboard

Non-atomic, but still awesome:

- Sorted set
- Single-entry list

TODO: copy everything from redback

## The data model

* How to set the keyspace and column family in use
* When to use a different column family
* How to configure sexyback for your app
* Example usage of the simple data structure

## License

Copyright 2011 Adam Keys. Sexyback is MIT licensed.
