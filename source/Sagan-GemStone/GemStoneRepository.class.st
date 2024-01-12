"
I'm a GemStone repository. I will keep the managed objects in an collections optimized for GemStone indexes, and provide transactional semantics.

I require a working GemStone connection.
"
Class {
	#name : 'GemStoneRepository',
	#superclass : 'RepositoryBehavior',
	#instVars : [
		'conflictCheckingStrategy',
		'contents'
	],
	#category : 'Sagan-GemStone',
	#package : 'Sagan-GemStone'
}

{ #category : 'instance creation' }
GemStoneRepository class >> checkingConflictsAccordingTo: aConflictCheckingStrategy [

	^self new initializeCheckingConflictsAccordingTo: aConflictCheckingStrategy
]

{ #category : 'instance creation' }
GemStoneRepository class >> withoutCheckingConflicts [

	^ self checkingConflictsAccordingTo: DoNotCheckForConflictsStrategy new
]

{ #category : 'configuring' }
GemStoneRepository >> configureWith: aBlock [

	aBlock cull: self
]

{ #category : 'private - accessing' }
GemStoneRepository >> conflictCheckingStrategy [

	^ conflictCheckingStrategy
]

{ #category : 'querying' }
GemStoneRepository >> countMatching: aCriteriaOrBlockClosure [

	^ contents count: ( self asMatchingCriteria: aCriteriaOrBlockClosure )
]

{ #category : 'querying' }
GemStoneRepository >> findAll [

	^ contents copy
]

{ #category : 'querying' }
GemStoneRepository >> findAllMatching: aCriteriaOrBlock [

	^ contents select: ( self asMatchingCriteria: aCriteriaOrBlock )
]

{ #category : 'querying' }
GemStoneRepository >> findAllMatching: aCriteriaOrBlock sortedBy: aSortFunction [

	^ ( self findAllMatching: aCriteriaOrBlock ) sorted: aSortFunction
]

{ #category : 'configuring' }
GemStoneRepository >> indexByEquality: aPath typed: aType [

	GsIndexSpec new
		equalityIndex: ( 'each.<1s>' expandMacrosWith: aPath )
		lastElementClass: aType
		options: self saganGemStoneIndexOptions;
		createIndexesOn: contents
]

{ #category : 'configuring' }
GemStoneRepository >> indexByIdentity: aPath [

	GsIndexSpec new
		identityIndex: ( 'each.<1s>' expandMacrosWith: aPath ) options: self saganGemStoneIndexOptions;
		createIndexesOn: contents
]

{ #category : 'initialization' }
GemStoneRepository >> initializeCheckingConflictsAccordingTo: aConflictCheckingStrategy [

	conflictCheckingStrategy := aConflictCheckingStrategy.
	contents := RcIdentitySet new
]

{ #category : 'private - accessing' }
GemStoneRepository >> matchingCriteriaBuilder [

	^ GemStoneRepositoryMatchingCriteriaBuilder new
]

{ #category : 'private - management' }
GemStoneRepository >> purgeAfterCheckingInclusion: aDomainObject [

	contents remove: aDomainObject ifAbsent: [
		DataInconsistencyFound signal:
			( '<1p> was expected to be found in the contents, but it was not.' expandMacrosWith:
				  aDomainObject )
		].
	^ aDomainObject
]

{ #category : 'management' }
GemStoneRepository >> purgeAllMatching: aCriteriaOrBlock [

	contents := contents reject: ( self asMatchingCriteria: aCriteriaOrBlock )
]

{ #category : 'private - accessing' }
GemStoneRepository >> saganGemStoneIndexOptions [

	^ GsIndexOptions btreePlusIndex + GsIndexOptions optimizedComparison
	  + GsIndexOptions reducedConflict
]

{ #category : 'private - management' }
GemStoneRepository >> storeAfterCheckingConflicts: aDomainObject [

	contents add: aDomainObject.
	^ aDomainObject
]

{ #category : 'management' }
GemStoneRepository >> transact: aBlock [

	^ aBlock value
]

{ #category : 'management' }
GemStoneRepository >> update: aMutableDomainObject executing: aBlock [

	aBlock value: aMutableDomainObject
]

{ #category : 'private - management' }
GemStoneRepository >> updateAfterCheckingConflicts: aDomainObject with: anUpdatedDomainObject [

	self purgeAfterCheckingInclusion: aDomainObject.
	[ aDomainObject synchronizeWith: anUpdatedDomainObject ] ensure: [
		self storeAfterCheckingConflicts: aDomainObject ].
	^ aDomainObject
]

{ #category : 'querying' }
GemStoneRepository >> withOneMatching: aCriteriaOrBlock do: foundBlock else: noneBlock [

	^ contents
		  detect: ( self asMatchingCriteria: aCriteriaOrBlock )
		  ifFound: foundBlock
		  ifNone: noneBlock
]

{ #category : 'querying' }
GemStoneRepository >> withOneMatching: aCriteriaOrBlock sortedBy: aSortFunction do: foundBlock else: noneBlock [

	^ ( contents sorted: aSortFunction )
		  detect: ( self asMatchingCriteria: aCriteriaOrBlock )
		  ifFound: foundBlock
		  ifNone: noneBlock
]

{ #category : 'querying' }
GemStoneRepository >> withQueryFrom: aQueryString do: aBlock [

	^ aBlock value: ( ( GsQuery
			      fromString: aQueryString
			      options: GsQueryOptions default + GsQueryOptions cacheQueryResult )
			    on: contents;
			    yourself )
]
