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
- Set
- Append-only list (TODO)
- Lock (TODO)
- Scoreboard (TODO)

Non-atomic, but still awesome:

- Sorted set (TODO)
- Single-entry list (TODO)

TODO: copy everything from redback
TODO: Redis duck-type compatible driver-esque object

## Operations, atomicity, and locking

Sexyback attempts to implement all of the awesome commands that Redis does.
However, some of these commands cannot be implemented on top of Cassandra
consistently giving its atomicity guarantees. Hopefully, there is a happy fuzzy
middle-ground.

The base type for each data structure implements the operations that only
require Cassandra's atomicity guarantees. Each base type has a subclass that
implements the other operations using extra locks or data structures that are
also stored in Cassandra.

Sexyback locks on a per-object basis; essentially, each row in a column family
can be locked. The lock is based on PID and thread ID. Additionally, each lock
is stored with a TTL so that dead processes don't deadlock a resource. Make
sure you set the TTL high enough for long running processes to maintain the
lock, or touch the lock during processing.

On locking:

http://wiki.apache.org/cassandra/Locking?highlight=%28ttl%29
http://en.wikipedia.org/wiki/Lamport%27s_bakery_algorithm
http://nob.cs.ucdavis.edu/classes/ecs150-1999-02/sync-bakery.html

## The data model

* How to set the keyspace and column family in use?
* When to use a different column family?
* How to configure sexyback for your app?
* Example usage of the simple data structure?

## License

Copyright 2011 Adam Keys. Sexyback is MIT licensed.
