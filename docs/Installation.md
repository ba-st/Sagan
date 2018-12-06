# Installation

## Basic Installation

You can load **Sagan** evaluating:
```smalltalk
Metacello new
	baseline: 'Sagan';
	repository: 'github://ba-st/Sagan:master/source';
	load.
```
>  Change `master` to some released version if you want a pinned version

## Using as dependency

In order to include **Sagan** as part of your project, you should reference the package in your product baseline:

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

```smalltalk
baseline: spec

	<baseline>
	spec
		for: #common
		do: [ self setUpDependencies: spec.
			spec package: 'My-Package' with: [ spec requires: #('Sagan') ] ]
```
