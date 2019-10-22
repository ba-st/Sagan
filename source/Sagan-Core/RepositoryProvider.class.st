Class {
	#name : #RepositoryProvider,
	#superclass : #Object,
	#category : #'Sagan-Core'
}

{ #category : #building }
RepositoryProvider >> createRepositoryStoringObjectsOfType: aBusinessObjectClass
	checkingConflictsAccordingTo: aConflictCheckingStrategy [

	self subclassResponsibility
]

{ #category : #controlling }
RepositoryProvider >> prepareForInitialPersistence [

	self subclassResponsibility
]

{ #category : #initialization }
RepositoryProvider >> reset [

	self subclassResponsibility
]
