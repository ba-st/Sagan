"
I'm a Gemstone repository. I will keep the managed objects in an collections optimized for Gemstone indexes, and provide transactional semantics.

I require a working Gemstone connection.
"
Class {
	#name : 'GemstoneRepository',
	#superclass : 'RepositoryBehavior',
	#instVars : [
		'conflictCheckingStrategy',
		'contents'
	],
	#category : 'Sagan-Gemstone',
	#package : 'Sagan-Gemstone'
}

{ #category : 'instance creation' }
GemstoneRepository class >> checkingConflictsAccordingTo: aConflictCheckingStrategy [

	^self new initializeCheckingConflictsAccordingTo: aConflictCheckingStrategy
]

{ #category : 'instance creation' }
GemstoneRepository class >> withoutCheckingConflicts [

	^ self checkingConflictsAccordingTo: DoNotCheckForConflictsStrategy new
]

{ #category : 'configuring' }
GemstoneRepository >> configureMappingsIn: aBlock [

	
]

{ #category : 'private - accessing' }
GemstoneRepository >> conflictCheckingStrategy [

	^ conflictCheckingStrategy
]

{ #category : 'querying' }
GemstoneRepository >> countMatching: aCriteriaOrBlockClosure [

	^ contents count: ( self asMatchingCriteria: aCriteriaOrBlockClosure )
]

{ #category : 'querying' }
GemstoneRepository >> findAll [

	^ contents copy
]

{ #category : 'querying' }
GemstoneRepository >> findAllMatching: aCriteriaOrBlock [

	^ contents select: ( self asMatchingCriteria: aCriteriaOrBlock )
]

{ #category : 'querying' }
GemstoneRepository >> findAllMatching: aCriteriaOrBlock sortedBy: aSortFunction [

	^ ( self findAllMatching: aCriteriaOrBlock ) sorted: aSortFunction
]

{ #category : 'initialization' }
GemstoneRepository >> initializeCheckingConflictsAccordingTo: aConflictCheckingStrategy [

	conflictCheckingStrategy := aConflictCheckingStrategy.
	contents := OrderedCollection new
]

{ #category : 'private - accessing' }
GemstoneRepository >> matchingCriteriaBuilder [

	^ GemstoneRepositoryMatchingCriteriaBuilder new
]

{ #category : 'private - management' }
GemstoneRepository >> purgeAfterCheckingInclusion: aDomainObject [

	contents remove: aDomainObject ifAbsent: [
		DataInconsistencyFound signal:
			( '<1p> was expected to be found in the contents, but it was not.' expandMacrosWith:
				  aDomainObject )
		].
	^ aDomainObject
]

{ #category : 'management' }
GemstoneRepository >> purgeAllMatching: aCriteriaOrBlock [

	contents := contents reject: ( self asMatchingCriteria: aCriteriaOrBlock )
]

{ #category : 'private - management' }
GemstoneRepository >> storeAfterCheckingConflicts: aDomainObject [

	contents add: aDomainObject.
	^ aDomainObject
]

{ #category : 'management' }
GemstoneRepository >> transact: aBlock [

	^ aBlock value
]

{ #category : 'management' }
GemstoneRepository >> update: aMutableDomainObject executing: aBlock [

	aBlock value: aMutableDomainObject
]

{ #category : 'private - management' }
GemstoneRepository >> updateAfterCheckingConflicts: aDomainObject with: anUpdatedDomainObject [

	self purgeAfterCheckingInclusion: aDomainObject.
	[ aDomainObject synchronizeWith: anUpdatedDomainObject ] ensure: [
		self storeAfterCheckingConflicts: aDomainObject ].
	^ aDomainObject
]

{ #category : 'querying' }
GemstoneRepository >> withOneMatching: aCriteriaOrBlock do: foundBlock else: noneBlock [

	^ contents
		  detect: ( self asMatchingCriteria: aCriteriaOrBlock )
		  ifFound: foundBlock
		  ifNone: noneBlock
]

{ #category : 'querying' }
GemstoneRepository >> withOneMatching: aCriteriaOrBlock sortedBy: aSortFunction do: foundBlock else: noneBlock [

	^ ( contents sorted: aSortFunction )
		  detect: ( self asMatchingCriteria: aCriteriaOrBlock )
		  ifFound: foundBlock
		  ifNone: noneBlock
]
