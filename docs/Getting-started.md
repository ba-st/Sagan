# Getting started with Sagan

## How can I start my project with Sagan?

First, of course, [install it](how-to/how-to-load-in-pharo.md). We recommend to
load the
group `Development` so you have all the tests and can use them as examples.

The main feature in Sagan is the notion of [`Repository`](../source/Sagan-Core/Repository.class.st).
You'll use them to store, purge and query objects of some domain. Conceptually,
a Repository encapsulates the set of objects persisted in a data store and the
operations performed over them, providing a more object-oriented view of the
persistence layer.

Currently Sagan supports two types of repositories:

- [`InMemoryRepository`](../source/Sagan-Core/InMemoryRepository.class.st): this
  one will keep the managed objects in an OrderedCollection and I will not provide
  any transactional semantics. It is useful when you start prototyping and
  writing tests, and don't want to struggle with mapping your objects to any db yet.
- [`RDBMSRepository`](../source/Sagan-RDBMS/RDBMSRepository.class.st): once you're
  comfortable with your model, you might start thinking on a more robust and
  permanent persistence of your objects. So where you used the in-memory
  repository, you can swap it with this one, which is an abstraction of
  relational databases and is built on top of [Glorp](https://github.com/pharo-rdbms/glorp).

When creating one, you must provide a [`RDBMSSessionProvider`](../source/Sagan-RDBMS/RDBMSSessionProvider.class.st)
that will wrap the actual Glorp Session, whose responsibility, among other
things, is to login to your database of choice.

At first, it's a good choice to use the [`SingleRDBMSSessionProvider`](../source/Sagan-RDBMS/SingleRDBMSSessionProvider.class.st),
and only worry about defining the mapping for your object correctly (see
[Define the mapping to your RDBMS](#define-the-mapping-to-your-rdbms)).
If you intend to have a heavy concurrent workload on your database, then we
recommend you consider using the [`PooledRDBMSSessionProvider`](../source/Sagan-RDBMS/PooledRDBMSSessionProvider.class.st).

The usual case you're probably be facing is the need of more than one Repository,
one for each type of object in your project's domain. To ease the
standardized way of creating them, the proper way is using a [`RepositoryProvider`](../source/Sagan-Core/RepositoryProvider.class.st).
There are 3 different ways of instantiating a provider:

- `InMemoryRepositoryProvider new`
- `RDBMSRepositoryProvider usingSingleSessionWith: aLogin`
- `RDBMSRepositoryProvider usingSessionPoolWith: aLogin configuredBy: configurationAction`.

Valid options for the session pooling configuration are:

- `maxIdleSessionsCount` defaulting to 10
- `minIdleSessionsCount` defaulting to 5
- `maxActiveSessionsCount` defaulting to 12

For both session providers' configuration, you can customize the connection retries upon any failure:
- `maximumConnectionAttemps` defaulting to 3
- `timeSlotBetweenConnectionRetriesInMs` defaulting to 3000 ms

Concretely, the complete algorithm to start a project with persistence using
Sagan is:

1. Instantiate a repository provider
2. Use it to create the repositories for each of your business objects you want
   to store
3. Configure the mappings for every repository (this step is not necessary if in-memory)
4. Send the message `#prepareForInitialPersistence` to the provider. If you're
   using the RDBMS repositories, this will create all the database structures
   needed to deploy the server.

As said before, you can start using the in-memory provider, and once you got
all your project setup and running, you can swap to a RDBMS provider with any of
the servers will show in the next section.

## Setting up your database (with Docker)

As Sagan is an abstraction layer on top of Glorp, it support all the database
servers Glorp does, but we guarantee that will work fairly with Postgres, and
SQLite3. If you use SQLServer or any other that Glorp supports and wish to
contribute to Sagan please check [this](../CONTRIBUTING.md).

Note that Glorp (and therefore Sagan) requires the database drivers in your
computer, or at least a reachable server, for the actual database connectivity.

In order to try any of these servers in an isolated environment, we provide you
with a [docker-compose](../docker/docker-compose.yml) that ease you the deploy of
the server.

### PostgreSQL

For instance, say you want to try Postgres with your project, all you need to do
is write this in the console:

```bash
cd docker; 
docker-compose up -d postgres
```

This will start the latest PostgreSQL 14 with an empty database called `test`,
configured with the user `postgres` and password `secret`, listening in the
default port 5432.

Then you can create your repository provider as follow

```smalltalk
RDBMSRepositoryProvider using: (
    Login new
        database: PostgreSQLPlatform new;
        username: 'postgres';
        password: 'secret';
        host: 'localhost';
        port: 5432;
        databaseName: 'test';
        setSSL;
        yourself)
```

Of course you can change the database name, port and passwords, just edit the
`docker-compose.yml` and change the login parameters accordingly.

To shutdown the database server, just execute:

```bash
cd docker; 
docker-compose stop 
```

## Define the mapping to your RDBMS

For every business object you intend to store in a relational database, you'll
need to define at least the 3 following objects:

- `ClassModelDefinition` to acknowledge Sagan about the business object's class
  and its collection of `AttributeDefinition`.
- `TableDefinition` that will hold the table name and column definitions
  specified by `TableFieldDefinition` (depending the complexity of your model,
  you might need to define more than one `RealTableDefinition` or maybe an `ImaginaryTableDefinition`)
- `DescriptorDefinition` that describes to Sagan the mapping from the class model
  definition to the table definition using a collection of `MappingDefinition`.
