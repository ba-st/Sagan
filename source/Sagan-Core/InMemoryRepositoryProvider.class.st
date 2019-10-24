Class {
	#name : #InMemoryRepositoryProvider,
	#superclass : #RepositoryProvider,
	#category : #'Sagan-Core'
}

{ #category : #building }
InMemoryRepositoryProvider >> createRepositoryStoringObjectsOfType: aBusinessObjectClass
	checkingConflictsAccordingTo: aConflictCheckingStrategy [

	^ InMemoryRepository checkingConflictsAccordingTo: aConflictCheckingStrategy
]

{ #category : #controlling }
InMemoryRepositoryProvider >> prepareForInitialPersistence [

	
]

{ #category : #controlling }
InMemoryRepositoryProvider >> prepareForShutDown [

	
]

{ #category : #initialization }
InMemoryRepositoryProvider >> reset [

	
]
