Class {
	#name : 'GemStoneRepositoryProvider',
	#superclass : 'RepositoryProvider',
	#category : 'Sagan-GemStone',
	#package : 'Sagan-GemStone'
}

{ #category : 'building' }
GemStoneRepositoryProvider >> createRepositoryStoringObjectsOfType: aBusinessObjectClass
	checkingConflictsAccordingTo: aConflictCheckingStrategy [

	^ GemStoneRepository checkingConflictsAccordingTo: aConflictCheckingStrategy
]

{ #category : 'controlling' }
GemStoneRepositoryProvider >> destroyRepositories [
	
	" In memory all repositories are destroyed once the system is shut down "
]

{ #category : 'controlling' }
GemStoneRepositoryProvider >> prepareForInitialPersistence [

	
]

{ #category : 'controlling' }
GemStoneRepositoryProvider >> prepareForShutDown [

	
]

{ #category : 'initialization' }
GemStoneRepositoryProvider >> reset [

	
]
