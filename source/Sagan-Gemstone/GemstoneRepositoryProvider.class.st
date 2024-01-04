Class {
	#name : 'GemstoneRepositoryProvider',
	#superclass : 'RepositoryProvider',
	#category : 'Sagan-Gemstone',
	#package : 'Sagan-Gemstone'
}

{ #category : 'building' }
GemstoneRepositoryProvider >> createRepositoryStoringObjectsOfType: aBusinessObjectClass
	checkingConflictsAccordingTo: aConflictCheckingStrategy [

	^ GemstoneRepository checkingConflictsAccordingTo: aConflictCheckingStrategy
]

{ #category : 'controlling' }
GemstoneRepositoryProvider >> destroyRepositories [
	
	" In memory all repositories are destroyed once the system is shut down "
]

{ #category : 'controlling' }
GemstoneRepositoryProvider >> prepareForInitialPersistence [

	
]

{ #category : 'controlling' }
GemstoneRepositoryProvider >> prepareForShutDown [

	
]

{ #category : 'initialization' }
GemstoneRepositoryProvider >> reset [

	
]
