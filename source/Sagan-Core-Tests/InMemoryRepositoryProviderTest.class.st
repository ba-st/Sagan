"
I have the Unit Tests for the In Memory Repository implementation. 
"
Class {
	#name : #InMemoryRepositoryProviderTest,
	#superclass : #RepositoryBasedTest,
	#category : #'Sagan-Core-Tests'
}

{ #category : #initialization }
InMemoryRepositoryProviderTest >> setUpRepositoryWith: aConflictCheckingStrategy [

	extraterrestrials := InMemoryRepositoryProvider new
		createRepositoryStoringObjectsOfType: Extraterrestrial
		checkingConflictsAccordingTo: aConflictCheckingStrategy
]
