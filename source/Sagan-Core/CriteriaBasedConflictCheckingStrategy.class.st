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
	#name : #CriteriaBasedConflictCheckingStrategy,
	#superclass : #ConflictCheckingStrategy,
	#instVars : [
		'conflictCriteriaBlock',
		'optionalExplanation'
	],
	#category : #'Sagan-Core'
}

{ #category : #'instance creation' }
CriteriaBasedConflictCheckingStrategy class >> accordingTo: aBlockOrMatchingCriteria [

	^ self new
		  initializeAccordingTo: aBlockOrMatchingCriteria
		  explainingConflictWith: Optional unused
]

{ #category : #'instance creation' }
CriteriaBasedConflictCheckingStrategy class >> accordingTo: aBlockOrMatchingCriteria explainingConflictWith: anExplanation [

	^ self new
		  initializeAccordingTo: aBlockOrMatchingCriteria
		  explainingConflictWith: (Optional containing: anExplanation)
]

{ #category : #private }
CriteriaBasedConflictCheckingStrategy class >> compare: objectInRepository to: objectInMemory with: aMonadycBlock [

	^ ( aMonadycBlock value: objectInRepository ) = ( aMonadycBlock value: objectInMemory )
]

{ #category : #private }
CriteriaBasedConflictCheckingStrategy class >> compare: objectInRepository to: objectInMemory withAll: aMonadycBlockCollection [

	^ aMonadycBlockCollection
		collect: [ :aMonadycBlock | self compare: objectInRepository to: objectInMemory with: aMonadycBlock ]
]

{ #category : #'instance creation' }
CriteriaBasedConflictCheckingStrategy class >> forAllIn: aMonadycBlockCollection [

	^ self
		accordingTo: [ :objectInRepository :criteria :objectInMemory | 
			criteria
				satisfyingAll: ( self compare: objectInRepository to: objectInMemory withAll: aMonadycBlockCollection )
			]
]

{ #category : #'instance creation' }
CriteriaBasedConflictCheckingStrategy class >> forAllIn: aMonadycBlockCollection explainingConflictWith: anExplanation [

	^ self
		  accordingTo: [ :objectInRepository :criteria :objectInMemory | 
			  criteria satisfyingAll: (self
					   compare: objectInRepository
					   to: objectInMemory
					   withAll: aMonadycBlockCollection) ]
		  explainingConflictWith: anExplanation
]

{ #category : #'instance creation' }
CriteriaBasedConflictCheckingStrategy class >> forAnyIn: aMonadycBlockCollection [

	^ self
		accordingTo: [ :objectInRepository :criteria :objectInMemory | 
			criteria
				satisfyingAny: ( self compare: objectInRepository to: objectInMemory withAll: aMonadycBlockCollection )
			]
]

{ #category : #'instance creation' }
CriteriaBasedConflictCheckingStrategy class >> forAnyIn: aMonadycBlockCollection explainingConflictWith: anExplanation [

	^ self
		  accordingTo: [ :objectInRepository :criteria :objectInMemory | 
			  criteria satisfyingAny: (self
					   compare: objectInRepository
					   to: objectInMemory
					   withAll: aMonadycBlockCollection) ]
		  explainingConflictWith: anExplanation
]

{ #category : #'instance creation' }
CriteriaBasedConflictCheckingStrategy class >> forSingleAspectMatching: aMonadycBlock [

	^ self
		accordingTo:
			[ :objectInRepository :criteria :objectInMemory | self compare: objectInRepository to: objectInMemory with: aMonadycBlock ]
]

{ #category : #'instance creation' }
CriteriaBasedConflictCheckingStrategy class >> forSingleAspectMatching: aMonadycBlock explainingConflictWith: anExplanation [

	^ self
		  accordingTo: [ :objectInRepository :criteria :objectInMemory | 
			  self
				  compare: objectInRepository
				  to: objectInMemory
				  with: aMonadycBlock ]
		  explainingConflictWith: anExplanation
]

{ #category : #Evaluating }
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

{ #category : #Evaluating }
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

{ #category : #private }
CriteriaBasedConflictCheckingStrategy >> assertNoConflictsFor: objectInMemory in: aRepository when: matchingCriteria [

	AssertionChecker
		refuse: [ 
		(aRepository countMatching: matchingCriteria) strictlyPositive ]
		because: [ 
			optionalExplanation
				withContentDo: [ :explanation | explanation ]
				ifUnused: [ 
					'Something is in conflict with <1p>' expandMacrosWith:
						objectInMemory ] ]
		raising: ConflictingObjectFound
]

{ #category : #initialization }
CriteriaBasedConflictCheckingStrategy >> initializeAccordingTo: aBlock explainingConflictWith: anOptional [

	conflictCriteriaBlock := aBlock.
	optionalExplanation := anOptional
]
