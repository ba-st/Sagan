Class {
	#name : #RepositoryProviderSystem,
	#superclass : #SubsystemImplementation,
	#instVars : [
		'session',
		'repositoryProviders'
	],
	#category : #'Sagan-Kepler'
}

{ #category : #controlling }
RepositoryProviderSystem >> createRepositoryFor: aName
	storingObjectsOfType: aBusinessObjectClass
	checkingConflictsAccordingTo: aConflictCheckingStrategy [

	^ ( repositoryProviders at: aName )
		createRepositoryStoringObjectsOfType: aBusinessObjectClass
		checkingConflictsAccordingTo: aConflictCheckingStrategy
]

{ #category : #installing }
RepositoryProviderSystem >> dependencies [

	^ #()
]

{ #category : #installing }
RepositoryProviderSystem >> implementedInterfaces [

	^ #(#RepositoryProviderSystem)
]

{ #category : #acccessing }
RepositoryProviderSystem >> initialize [

	super initialize.
	repositoryProviders := Dictionary new
]

{ #category : #installing }
RepositoryProviderSystem >> name [ 

	^ 'Repository Provider'
]

{ #category : #controlling }
RepositoryProviderSystem >> prepareForInitialPersistence [

	repositoryProviders valuesDo: [ :provider | provider prepareForInitialPersistence ]
]

{ #category : #registration }
RepositoryProviderSystem >> register: aRepositoryProvider as: aName [

	repositoryProviders at: aName put: aRepositoryProvider
]

{ #category : #installing }
RepositoryProviderSystem >> resolveDependencies [

	super resolveDependencies.
	repositoryProviders valuesDo: [ :provider | provider reset ]
]
