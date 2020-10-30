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
InMemoryRepositoryProvider >> destroyRepositories [
	
	" In memory all repositories are destroyed once the system is shut down "
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
