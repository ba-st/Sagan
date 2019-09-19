"
I have the Unit Tests for the In Memory Repository implementation. 
"
Class {
	#name : #InMemoryRepositoryTest,
	#superclass : #RepositoryBasedTest,
	#category : #'Sagan-Core-Tests'
}

{ #category : #initialization }
InMemoryRepositoryTest >> setUpRepositoryWith: aConflictCheckingStrategy [

	extraterrestrials := InMemoryRepository checkingConflictsAccordingTo: aConflictCheckingStrategy
]
