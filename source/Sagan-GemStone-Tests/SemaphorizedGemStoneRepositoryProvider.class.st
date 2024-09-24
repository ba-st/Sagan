"
This class is specifically created for testing transaction management in crud services of repostiories
"
Class {
	#name : 'SemaphorizedGemStoneRepositoryProvider',
	#superclass : 'RepositoryProvider',
	#instVars : [
		'semaphore'
	],
	#category : 'Sagan-GemStone-Tests',
	#package : 'Sagan-GemStone-Tests'
}

{ #category : 'instance creation' }
SemaphorizedGemStoneRepositoryProvider class >> waitingOn: aSemaphore [

	^ self new initializeWaitingOn: aSemaphore
]

{ #category : 'building' }
SemaphorizedGemStoneRepositoryProvider >> createRepositoryStoringObjectsOfType: aBusinessObjectClass
	checkingConflictsAccordingTo: aConflictCheckingStrategy [


	^ SemaphorizedGemStoneRepository
		  checkingConflictsAccordingTo: aConflictCheckingStrategy
		  waitingOn: semaphore
]

{ #category : 'controlling' }
SemaphorizedGemStoneRepositoryProvider >> destroyRepositories [

	IndexManager current removeAllIndexes
]

{ #category : 'initialization' }
SemaphorizedGemStoneRepositoryProvider >> initializeWaitingOn: aSemaphore [

	semaphore := aSemaphore
]

{ #category : 'controlling' }
SemaphorizedGemStoneRepositoryProvider >> prepareForInitialPersistence [

	
]

{ #category : 'controlling' }
SemaphorizedGemStoneRepositoryProvider >> prepareForShutDown [

	
]

{ #category : 'initialization' }
SemaphorizedGemStoneRepositoryProvider >> reset [


]
