"
I will perform conflict checking on store: and update:with: for the 
repository including me.

I can be easily created to check conflicts in:
- a single aspect of the stored object
- several aspects signaling conflict when all match the same time
- several aspects signaling conflict when any of this match

The users can also provide a more complex behavior.
"
Class {
	#name : 'CriteriaBasedConflictCheckingStrategy',
	#superclass : 'ConflictCheckingStrategy',
	#instVars : [
		'conflictCriteriaBlock',
		'explanationBlock'
	],
	#category : 'Sagan-Core',
	#package : 'Sagan-Core'
}

{ #category : 'instance creation' }
CriteriaBasedConflictCheckingStrategy class >> accordingTo: aBlockOrMatchingCriteria [

	^ self
		  accordingTo: aBlockOrMatchingCriteria
		  explainingConflictWith: [ :objectInMemory | 
			  'Something is in conflict with <1p>' expandMacrosWith:
				  objectInMemory ]
]

{ #category : 'instance creation' }
CriteriaBasedConflictCheckingStrategy class >> accordingTo: aBlockOrMatchingCriteria explainingConflictWith: aBlock [

	^ self new
		  initializeAccordingTo: aBlockOrMatchingCriteria
		  explainingConflictWith: aBlock
]

{ #category : 'private' }
CriteriaBasedConflictCheckingStrategy class >> compare: objectInRepository to: objectInMemory with: aMonadycBlock [

	^ ( aMonadycBlock value: objectInRepository ) = ( aMonadycBlock value: objectInMemory )
]

{ #category : 'private' }
CriteriaBasedConflictCheckingStrategy class >> compare: objectInRepository to: objectInMemory withAll: aMonadycBlockCollection [

	^ aMonadycBlockCollection
		collect: [ :aMonadycBlock | self compare: objectInRepository to: objectInMemory with: aMonadycBlock ]
]

{ #category : 'instance creation' }
CriteriaBasedConflictCheckingStrategy class >> forAllIn: aMonadycBlockCollection [

	^ self
		accordingTo: [ :objectInRepository :criteria :objectInMemory | 
			criteria
				satisfyingAll: ( self compare: objectInRepository to: objectInMemory withAll: aMonadycBlockCollection )
			]
]

{ #category : 'instance creation' }
CriteriaBasedConflictCheckingStrategy class >> forAllIn: aMonadycBlockCollection explainingConflictWith: aBlock [

	^ self
		  accordingTo: [ :objectInRepository :criteria :objectInMemory | 
			  criteria satisfyingAll: (self
					   compare: objectInRepository
					   to: objectInMemory
					   withAll: aMonadycBlockCollection) ]
		  explainingConflictWith: aBlock
]

{ #category : 'instance creation' }
CriteriaBasedConflictCheckingStrategy class >> forAnyIn: aMonadycBlockCollection [

	^ self
		accordingTo: [ :objectInRepository :criteria :objectInMemory | 
			criteria
				satisfyingAny: ( self compare: objectInRepository to: objectInMemory withAll: aMonadycBlockCollection )
			]
]

{ #category : 'instance creation' }
CriteriaBasedConflictCheckingStrategy class >> forAnyIn: aMonadycBlockCollection explainingConflictWith: aBlock [

	^ self
		  accordingTo: [ :objectInRepository :criteria :objectInMemory | 
			  criteria satisfyingAny: (self
					   compare: objectInRepository
					   to: objectInMemory
					   withAll: aMonadycBlockCollection) ]
		  explainingConflictWith: aBlock
]

{ #category : 'instance creation' }
CriteriaBasedConflictCheckingStrategy class >> forSingleAspectMatching: aMonadycBlock [

	^ self
		accordingTo:
			[ :objectInRepository :criteria :objectInMemory | self compare: objectInRepository to: objectInMemory with: aMonadycBlock ]
]

{ #category : 'instance creation' }
CriteriaBasedConflictCheckingStrategy class >> forSingleAspectMatching: aMonadycBlock explainingConflictWith: aBlock [

	^ self
		  accordingTo: [ :objectInRepository :criteria :objectInMemory | 
			  self
				  compare: objectInRepository
				  to: objectInMemory
				  with: aMonadycBlock ]
		  explainingConflictWith: aBlock
]

{ #category : 'Evaluating' }
CriteriaBasedConflictCheckingStrategy >> assertNoConflictsFor: objectInMemory in: aRepository [

	self
		assertNoConflictsFor: objectInMemory
		in: aRepository
		when: [ :objectInRepository :criteria | 
			conflictCriteriaBlock
				value: objectInRepository
				value: criteria
				value: objectInMemory
			]
]

{ #category : 'Evaluating' }
CriteriaBasedConflictCheckingStrategy >> assertNoConflictsFor: updatedObjectInMemory in: aRepository excluding: originalObjectInMemory [

	self
		assertNoConflictsFor: updatedObjectInMemory
		in: aRepository
		when:
			[ :objectInRepository :criteria | 
				criteria 
					satisfying: ( criteria does: objectInRepository notEqual: originalObjectInMemory ) 
					and: [ conflictCriteriaBlock value: objectInRepository value: criteria value: updatedObjectInMemory ] ]
]

{ #category : 'private' }
CriteriaBasedConflictCheckingStrategy >> assertNoConflictsFor: objectInMemory in: aRepository when: matchingCriteria [

	AssertionChecker
		refuse: [ 
		(aRepository countMatching: matchingCriteria) strictlyPositive ]
		because: [ explanationBlock cull: objectInMemory ]
		raising: ConflictingObjectFound
]

{ #category : 'initialization' }
CriteriaBasedConflictCheckingStrategy >> initializeAccordingTo: aBlock explainingConflictWith: aExplanationBlock [

	conflictCriteriaBlock := aBlock.
	explanationBlock := aExplanationBlock
]
