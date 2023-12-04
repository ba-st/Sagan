Class {
	#name : 'RepositoryProviderSystem',
	#superclass : 'SubsystemImplementation',
	#instVars : [
		'repositoryProviders'
	],
	#category : 'Sagan-Kepler',
	#package : 'Sagan-Kepler'
}

{ #category : 'as yet unclassified' }
RepositoryProviderSystem class >> registerInterfaces [

	<ignoreForCoverage>
	self
		registerInterfaceAt: #RepositoryProviderSystem
		named: 'Repository Provider System Interface'
		declaring:
			#( createRepositoryFor:storingObjectsOfType:checkingConflictsAccordingTo:
			   register:as: prepareForInitialPersistence
			   destroyRepositores )
]

{ #category : 'controlling' }
RepositoryProviderSystem >> createRepositoryFor: aName
	storingObjectsOfType: aBusinessObjectClass
	checkingConflictsAccordingTo: aConflictCheckingStrategy [

	^ ( repositoryProviders at: aName )
		createRepositoryStoringObjectsOfType: aBusinessObjectClass
		checkingConflictsAccordingTo: aConflictCheckingStrategy
]

{ #category : 'installing' }
RepositoryProviderSystem >> dependencies [

	^ #()
]

{ #category : 'installing' }
RepositoryProviderSystem >> destroyRepositories [

	repositoryProviders do: #destroyRepositories
]

{ #category : 'installing' }
RepositoryProviderSystem >> implementedInterfaces [

	^ #(#RepositoryProviderSystem)
]

{ #category : 'acccessing' }
RepositoryProviderSystem >> initialize [

	super initialize.
	repositoryProviders := Dictionary new
]

{ #category : 'installing' }
RepositoryProviderSystem >> name [ 

	^ 'Repository Provider'
]

{ #category : 'controlling' }
RepositoryProviderSystem >> prepareForInitialPersistence [

	repositoryProviders valuesDo: [ :provider | provider prepareForInitialPersistence ]
]

{ #category : 'registration' }
RepositoryProviderSystem >> register: aRepositoryProvider as: aName [

	repositoryProviders at: aName put: aRepositoryProvider
]

{ #category : 'installing' }
RepositoryProviderSystem >> resolveDependencies [

	super resolveDependencies.
	repositoryProviders valuesDo: [ :provider | provider reset ]
]

{ #category : 'private - controlling' }
RepositoryProviderSystem >> shutDownWhenStarted [

	repositoryProviders valuesDo: [ :provider | provider prepareForShutDown ].
	super shutDownWhenStarted
]
