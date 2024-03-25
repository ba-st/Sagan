"
I'm an in-memory repository. I will keep the managed objects in an OrderedCollection and I will not provide transactional semantics.

I'm useful for testing purposes and initial prototyping.
"
Class {
	#name : 'InMemoryRepository',
	#superclass : 'RepositoryBehavior',
	#instVars : [
		'conflictCheckingStrategy',
		'contents'
	],
	#category : 'Sagan-Core',
	#package : 'Sagan-Core'
}

{ #category : 'instance creation' }
InMemoryRepository class >> checkingConflictsAccordingTo: aConflictCheckingStrategy [

	^self new initializeCheckingConflictsAccordingTo: aConflictCheckingStrategy
]

{ #category : 'instance creation' }
InMemoryRepository class >> withoutCheckingConflicts [

	^ self checkingConflictsAccordingTo: DoNotCheckForConflictsStrategy new
]

{ #category : 'configuring' }
InMemoryRepository >> configureWith: aBlock [

	
]

{ #category : 'private - accessing' }
InMemoryRepository >> conflictCheckingStrategy [

	^ conflictCheckingStrategy
]

{ #category : 'querying' }
InMemoryRepository >> countAll [

	^ contents size
]

{ #category : 'querying' }
InMemoryRepository >> countMatching: aCriteriaOrBlockClosure [

	^ contents count: ( self asMatchingCriteria: aCriteriaOrBlockClosure )
]

{ #category : 'querying' }
InMemoryRepository >> findAll [

	^ contents copy
]

{ #category : 'querying' }
InMemoryRepository >> findAllMatching: aCriteriaOrBlock [

	^ contents select: ( self asMatchingCriteria: aCriteriaOrBlock )
]

{ #category : 'querying' }
InMemoryRepository >> findAllMatching: aCriteriaOrBlock sortedBy: aSortFunction [

	^ ( self findAllMatching: aCriteriaOrBlock ) sorted: aSortFunction
]

{ #category : 'initialization' }
InMemoryRepository >> initializeCheckingConflictsAccordingTo: aConflictCheckingStrategy [

	conflictCheckingStrategy := aConflictCheckingStrategy.
	contents := Set new
]

{ #category : 'private - accessing' }
InMemoryRepository >> matchingCriteriaBuilder [

	^ InMemoryRepositoryMatchingCriteriaBuilder  new
]

{ #category : 'private - management' }
InMemoryRepository >> purgeAfterCheckingInclusion: aDomainObject [

	contents
		remove: aDomainObject
		ifAbsent: [ 
			DataInconsistencyFound
				signal: ( '<1p> was expected to be found in the contents, but it was not.' expandMacrosWith: aDomainObject )
			].
	^ aDomainObject
]

{ #category : 'management' }
InMemoryRepository >> purgeAllMatching: aCriteriaOrBlock [

	contents := contents reject: ( self asMatchingCriteria: aCriteriaOrBlock )
]

{ #category : 'private - management' }
InMemoryRepository >> storeAfterCheckingConflicts: aDomainObject [

	contents add: aDomainObject.
	^ aDomainObject
]

{ #category : 'management' }
InMemoryRepository >> transact: aBlock [

	^ aBlock value
]

{ #category : 'management' }
InMemoryRepository >> update: aMutableDomainObject executing: aBlock [

	aBlock value: aMutableDomainObject
]

{ #category : 'private - management' }
InMemoryRepository >> updateAfterCheckingConflicts: aDomainObject with: anUpdatedDomainObject [

	self purgeAfterCheckingInclusion: aDomainObject.
	[ aDomainObject synchronizeWith: anUpdatedDomainObject ] ensure: [
		self storeAfterCheckingConflicts: aDomainObject ].
	^ aDomainObject
]

{ #category : 'private - querying' }
InMemoryRepository >> validatedFindAllFrom: aStartingPosition upTo: aMaximumPosition sortedByAscending: aVariableName [

	| from to |

	( contents isEmpty or: [ aStartingPosition > contents size ] ) ifTrue: [ ^ Set new ].

	from := aStartingPosition max: 1.
	to := ( aMaximumPosition min: contents size ) max: 1.

	^ ( contents sorted: [ :a :b |
		    ( a instVarNamed: aVariableName asString ) <= ( b instVarNamed: aVariableName asString ) ] )
		  copyFrom: from
		  to: to
]

{ #category : 'querying' }
InMemoryRepository >> withOneMatching: aCriteriaOrBlock do: foundBlock else: noneBlock [

	^ contents detect: ( self asMatchingCriteria: aCriteriaOrBlock ) ifFound: foundBlock ifNone: noneBlock
]

{ #category : 'querying' }
InMemoryRepository >> withOneMatching: aCriteriaOrBlock sortedBy: aSortFunction do: foundBlock else: noneBlock [

	^ ( contents sorted: aSortFunction ) detect: ( self asMatchingCriteria: aCriteriaOrBlock ) ifFound: foundBlock ifNone: noneBlock
]
