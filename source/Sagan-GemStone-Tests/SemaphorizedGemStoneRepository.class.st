"
This class is specifically created for testing transaction management in crud services of repostiories
"
Class {
	#name : 'SemaphorizedGemStoneRepository',
	#superclass : 'GemStoneRepository',
	#instVars : [
		'semaphore'
	],
	#category : 'Sagan-GemStone-Tests',
	#package : 'Sagan-GemStone-Tests'
}

{ #category : 'instance creation' }
SemaphorizedGemStoneRepository class >> checkingConflictsAccordingTo: aConflictCheckingStrategy waitingOn: aSemaphore [

	^ self new initializeCheckingConflictsAccordingTo: aConflictCheckingStrategy waitingOn: aSemaphore
]

{ #category : 'initialization' }
SemaphorizedGemStoneRepository >> initializeCheckingConflictsAccordingTo: aConflictCheckingStrategy waitingOn: aSemaphore [

	self initializeCheckingConflictsAccordingTo: aConflictCheckingStrategy.
	semaphore := aSemaphore
]

{ #category : 'private - management' }
SemaphorizedGemStoneRepository >> synchronize: aDomainObject with: anUpdatedDomainObject [

	super synchronize: aDomainObject with: anUpdatedDomainObject.
	semaphore wait
]
