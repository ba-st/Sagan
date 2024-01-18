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

	IndexManager current removeAllIndexes
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
