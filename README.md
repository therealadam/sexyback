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

## Show me what you got

It's a bit rough at this point, but here's a hash that is stored into
a Cassandra row.

    Sexyback::Hash.connection = Cassandra.new('SomeKeyspace')
    Sexyback::Hash.column_family = :Hash

    hsh = Sexyback::Hash.new
    hsh.row_key = 'example'
    hsh.set('alice', 'bob')
    hsh.set('bob', 'charlie')
    hsh.set('charlie', 'alice')
    hsh.get_all # => {'alice' => 'bob', 'bob' => 'charlie', 'charlie' => 'alice'} 

The bits where `connection` and `column_family` are global are obviously crap,
but hopefully the other bits are interesting.

---

Everything above this line is hot air and everything below this line is
ambition. Don't judge me.

## The sexy

Atomic types:

- Hash
- Set (TODO)
- Append-only list (TODO)
- Lock (TODO)
- Scoreboard (TODO)

Non-atomic, but still awesome:

- Sorted set (TODO)
- Single-entry list (TODO)

TODO: copy everything from redback

## The data model

* How to set the keyspace and column family in use?
* When to use a different column family?
* How to configure sexyback for your app?
* Example usage of the simple data structure?

## License

Copyright 2011 Adam Keys. Sexyback is MIT licensed.
