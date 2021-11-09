# Installation

## Basic Installation

You can load **Sagan** evaluating:

```smalltalk
Metacello new
  baseline: 'Sagan';
  repository: 'github://ba-st/Sagan:release-candidate/source';
  load.
```

> Change `release-candidate` to some released version if you want a pinned version

## Using as dependency

In order to include **Sagan** as part of your project, you should reference the
package in your product baseline:

```smalltalk
setUpDependencies: spec

  spec
    baseline: 'Sagan'
      with: [ spec
        repository: 'github://ba-st/Sagan:v{XX}/source';
        loads: #('Deployment') ];
    import: 'Sagan'.
```

> Replace `{XX}` with the version you want to depend on

> Replace `{Group}` with any of:
> - `PostgreSQL`
> - `SQLite`

```smalltalk
baseline: spec

  <baseline>
  spec
    for: #common
    do: [ self setUpDependencies: spec.
      spec package: 'My-Package' with: [ spec requires: #('Sagan') ] ]
```

## Provided groups

- `Deployment` will load all the packages needed in a deployed application
- `PostgreSQL` will load all the packages needed in a deployed application using
  PostgreSQL
- `SQLite` will load all the packages needed in a deployed application using SQLite
- `Tests` will load the test cases
- `Dependent-SUnit-Extensions` will load the extensions to the SUnit framework
- `Tools` will load the extensions to the SUnit framework and development tools
  (inspector and spotter extensions)
- `CI` is the group loaded in the continuous integration setup
- `Development` will load all the needed packages to develop and contribute to
  the project
