Class {
	#name : 'RepositoryProvider',
	#superclass : 'Object',
	#category : 'Sagan-Core',
	#package : 'Sagan-Core'
}

{ #category : 'building' }
RepositoryProvider >> createRepositoryStoringObjectsOfType: aBusinessObjectClass
	checkingConflictsAccordingTo: aConflictCheckingStrategy [

	self subclassResponsibility
]

{ #category : 'controlling' }
RepositoryProvider >> destroyRepositories [

	self subclassResponsibility
]

{ #category : 'controlling' }
RepositoryProvider >> prepareForInitialPersistence [

	self subclassResponsibility
]

{ #category : 'controlling' }
RepositoryProvider >> prepareForShutDown [

	self subclassResponsibility
]

{ #category : 'initialization' }
RepositoryProvider >> reset [

	self subclassResponsibility
]
