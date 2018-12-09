"
I'm an abstract Test Case for testing the Repository implementations.

My subclasses must provide a way to setup a functioning repository.
"
Class {
	#name : #RepositoryBasedTest,
	#superclass : #TestCase,
	#instVars : [
		'repository'
	],
	#category : #'Sagan-Core-Tests'
}

{ #category : #testing }
RepositoryBasedTest class >> isAbstract [ 

	^self name = #RepositoryBasedTest
]

{ #category : #'private - assertions' }
RepositoryBasedTest >> assertRepositoryIncludesSilvesterStallone [

	self repository
		withOneMatching: [ :extraterrestrial | extraterrestrial firstName = 'Silvester' ]
		do: [ :extraterrestrial | self assert: extraterrestrial lastName equals: 'Stallone' ]
		else: [ self fail ]
]

{ #category : #'private - assertions' }
RepositoryBasedTest >> assertTheOnlyOneInTheRepositoryIsSilvesterStallone [

	self
		withTheOnlyOneIn: self repository findAll
		do: [ :extraterrestrial | 
			self
				assert: extraterrestrial firstName equals: 'Silvester';
				assert: extraterrestrial lastName equals: 'Stallone'
			]
]

{ #category : #'private - extraterrestrials' }
RepositoryBasedTest >> ellaTravolta [

	^ self extraterrestrialNamedFirst: 'Ella' last: 'Travolta'
]

{ #category : #'private - extraterrestrials' }
RepositoryBasedTest >> extraterrestrialNamedFirst: aFirstName last: aLastName [

	^ Extraterrestrial namedFirst: aFirstName last: aLastName
]

{ #category : #'private - extraterrestrials' }
RepositoryBasedTest >> johnLock [

	^ self extraterrestrialNamedFirst: 'John' last: 'Lock'
]

{ #category : #'private - extraterrestrials' }
RepositoryBasedTest >> johnTravolta [

	^ self extraterrestrialNamedFirst: 'John' last: 'Travolta'
]

{ #category : #'private - accessing' }
RepositoryBasedTest >> repository [ 

	repository ifNil: [ self setUpRepositoryWithNoConflictChecking  ].
	^ repository 
]

{ #category : #initialization }
RepositoryBasedTest >> setUpRepositoryForConjunctiveConflictChecking [

	self
		setUpRepositoryWith:
			( CriteriaBasedConflictCheckingStrategy
				forAllIn:
					{[ :person | person firstName ].
					[ :person | person lastName ]} )
]

{ #category : #initialization }
RepositoryBasedTest >> setUpRepositoryForDisjunctiveConflictChecking [

	self
		setUpRepositoryWith:
			( CriteriaBasedConflictCheckingStrategy
				forAnyIn:
					{[ :person | person firstName ].
					[ :person | person lastName ]} )
]

{ #category : #initialization }
RepositoryBasedTest >> setUpRepositoryForSimpleConflictChecking [

	self setUpRepositoryWith: ( CriteriaBasedConflictCheckingStrategy forSingleAspectMatching: [ :person | person firstName ] )
]

{ #category : #initialization }
RepositoryBasedTest >> setUpRepositoryWith: aConflictCheckingStrategy [

	self subclassResponsibility  
	
	
]

{ #category : #initialization }
RepositoryBasedTest >> setUpRepositoryWithNoConflictChecking [

	self setUpRepositoryWith: DoNotCheckForConflictsStrategy new
]

{ #category : #'private - extraterrestrials' }
RepositoryBasedTest >> silvesterMcCoy [

	^ self extraterrestrialNamedFirst: 'Silvester' last: 'McCoy'
]

{ #category : #'private - extraterrestrials' }
RepositoryBasedTest >> silvesterStallone [

	^ self extraterrestrialNamedFirst: 'Silvester' last: 'Stallone'
]

{ #category : #'private - extraterrestrials' }
RepositoryBasedTest >> sistineStallone [

	^ self extraterrestrialNamedFirst: 'Sistine' last: 'Stallone'
]

{ #category : #'tests - querying' }
RepositoryBasedTest >> testCountMatching [

	self repository
		store: self silvesterStallone;
		store: self sistineStallone.

	self
		assert: ( self repository countMatching: [ :person | person lastName = 'Stallone' ] ) equals: 2;
		assert: ( self repository countMatching: [ :person | person firstName = 'Silvester' ] ) equals: 1
]

{ #category : #'tests - querying' }
RepositoryBasedTest >> testFindAllMatching [

	self repository
		store: self johnTravolta;
		store: self johnLock;
		store: self silvesterStallone.

	self
		assert: ( self repository findAllMatching: [ :extraterrestrial | extraterrestrial firstName = 'Silvester' ] ) size equals: 1;
		assert: ( self repository findAllMatching: [ :extraterrestrial | extraterrestrial firstName = 'Yoko' ] ) isEmpty;
		assert:
			( self repository findAllMatching: [ :extraterrestrial :criteria | criteria does: extraterrestrial firstName includeSubstring: 'J' ] ) size
			equals: 2
]

{ #category : #'tests - querying' }
RepositoryBasedTest >> testFindAllMatchingSortedBy [

	| sorted |

	self repository
		store: self silvesterStallone;
		store: self silvesterMcCoy;
		store: self johnTravolta;
		store: self johnLock.

	sorted := self repository
		findAllMatching: [ :extraterrestrial :criteria | criteria does: extraterrestrial lastName asUppercase includeSubstring: 'L' ]
		sortedBy: #firstName ascending , #lastName descending.

	self
		assert: sorted size equals: 3;
		assert: sorted first lastName equals: 'Travolta';
		assert: sorted first firstName equals: 'John';
		assert: sorted second lastName equals: 'Lock';
		assert: sorted second firstName equals: 'John';
		assert: sorted last lastName equals: 'Stallone';
		assert: sorted last firstName equals: 'Silvester'
]

{ #category : #'tests - management' }
RepositoryBasedTest >> testPurge [

	| stallone |

	stallone := self silvesterStallone.
	self repository store: stallone.
	self assertTheOnlyOneInTheRepositoryIsSilvesterStallone.

	self repository purge: stallone.
	self assert: self repository findAll isEmpty
]

{ #category : #'tests - management' }
RepositoryBasedTest >> testPurgeAllMatching [

	self repository
		store: self johnTravolta;
		store: self ellaTravolta;
		store: self silvesterStallone.

	self assert: self repository findAll size equals: 3.

	self repository purgeAllMatching: [ :extraterrestrial | extraterrestrial lastName = 'Travolta' ].

	self assertTheOnlyOneInTheRepositoryIsSilvesterStallone
]

{ #category : #'tests - management' }
RepositoryBasedTest >> testPurgeAllMatchingWhenNoneMatches [

	self assert: self repository findAll isEmpty.

	self repository purgeAllMatching: [ :extraterrestrial | extraterrestrial lastName = 'Travolta' ].

	self assert: self repository findAll isEmpty.

	self repository store: self silvesterStallone.

	self repository purgeAllMatching: [ :extraterrestrial | extraterrestrial lastName = 'Travolta' ].

	self assertTheOnlyOneInTheRepositoryIsSilvesterStallone
]

{ #category : #'tests - management' }
RepositoryBasedTest >> testPurgeAllMatchingWhenOnlySomeMatch [

	self repository
		store: self silvesterStallone;
		store: self silvesterMcCoy;
		store: self johnTravolta;
		store: self ellaTravolta.

	self assert: self repository findAll size equals: 4.

	self repository purgeAllMatching: [ :extraterrestrial | extraterrestrial firstName = 'Silvester' ].

	self assert: self repository findAll size equals: 2.
	self repository
		withOneMatching: [ :extraterrestrial | extraterrestrial firstName = 'John' ]
			do: [ :person | self assert: person lastName equals: 'Travolta' ]
			else: [ self fail ];
		withOneMatching: [ :extraterrestrial | extraterrestrial firstName = 'Ella' ]
			do: [ :person | self assert: person lastName equals: 'Travolta' ]
			else: [ self fail ]
]

{ #category : #'tests - management' }
RepositoryBasedTest >> testStore [

	self repository
		store: self johnTravolta;
		store: self silvesterStallone.

	self assert: self repository findAll size equals: 2.
	self assertRepositoryIncludesSilvesterStallone.
	self repository
		withOneMatching: [ :extraterrestrial | extraterrestrial firstName = 'John' ]
		do: [ :extraterrestrial | self assert: extraterrestrial lastName equals: 'Travolta' ]
		else: [ self fail ]
]

{ #category : #'tests - conflict checking' }
RepositoryBasedTest >> testStoreWithConflict [

	self setUpRepositoryForSimpleConflictChecking.

	self repository store: self silvesterStallone.

	self
		should: [ self repository store: self silvesterMcCoy ] raise: ConflictingObjectFound;
		assertTheOnlyOneInTheRepositoryIsSilvesterStallone
]

{ #category : #'tests - conflict checking' }
RepositoryBasedTest >> testStoreWithConjunctiveConflictChecking [

	self setUpRepositoryForConjunctiveConflictChecking.

	self repository store: self silvesterStallone.

	self
		shouldnt: [ self repository store: self silvesterMcCoy ] raise: ConflictingObjectFound;
		shouldnt: [ self repository store: self sistineStallone ] raise: ConflictingObjectFound;
		should: [ self repository store: self silvesterStallone ] raise: ConflictingObjectFound.

	self
		assert: self repository findAll size equals: 3;
		assertRepositoryIncludesSilvesterStallone
]

{ #category : #'tests - conflict checking' }
RepositoryBasedTest >> testStoreWithDisjunctiveConflictChecking [

	self setUpRepositoryForDisjunctiveConflictChecking.

	self repository store: self silvesterStallone.

	self
		should: [ self repository store: self silvesterMcCoy ] raise: ConflictingObjectFound;
		should: [ self repository store: self sistineStallone ] raise: ConflictingObjectFound;
		should: [ self repository store: self silvesterStallone ] raise: ConflictingObjectFound.

	self assertTheOnlyOneInTheRepositoryIsSilvesterStallone
]

{ #category : #'tests - management' }
RepositoryBasedTest >> testUpdateWith [

	| stallone |

	stallone := self silvesterStallone.
	self repository store: stallone.
	self
		assert: self repository findAll size equals: 1;
		assert: ( self repository findAll includes: stallone ).

	self repository update: stallone with: self johnLock.

	self assert: self repository findAll size equals: 1.

	self repository
		withOneMatching: [ :extraterrestrial | extraterrestrial firstName = 'John' ]
		do: [ :john | self assert: john lastName equals: 'Lock' ]
		else: [ self fail ].

	self assert: ( self repository findAllMatching: [ :extraterrestrial | extraterrestrial lastName = 'Stallone' ] ) isEmpty
]

{ #category : #'tests - conflict checking' }
RepositoryBasedTest >> testUpdateWithConflict [

	| stallone |

	self setUpRepositoryForSimpleConflictChecking.

	stallone := self silvesterStallone.
	self repository
		store: stallone;
		store: self johnTravolta.

	self
		should: [ self repository update: stallone with: self johnLock ] raise: ConflictingObjectFound;
		assertRepositoryIncludesSilvesterStallone
]

{ #category : #'tests - conflict checking' }
RepositoryBasedTest >> testUpdateWithConflictUsingConjunctiveConflictChecking [

	| stallone |

	self setUpRepositoryForConjunctiveConflictChecking.

	stallone := self silvesterStallone.
	self repository
		store: stallone;
		store: self johnTravolta.

	self
		should: [ self repository update: stallone with: self johnTravolta ] raise: ConflictingObjectFound;
		shouldnt: [ self repository update: stallone with: self johnLock ] raise: ConflictingObjectFound;
		shouldnt: [ self repository update: stallone with: self ellaTravolta ] raise: ConflictingObjectFound
]

{ #category : #'tests - conflict checking' }
RepositoryBasedTest >> testUpdateWithConflictUsingDisjunctiveConflictChecking [

	| stallone |

	self setUpRepositoryForDisjunctiveConflictChecking.

	stallone := self silvesterStallone.
	self repository
		store: stallone;
		store: self johnTravolta.

	self
		should: [ self repository update: stallone with: self johnTravolta ] raise: ConflictingObjectFound;
		should: [ self repository update: stallone with: self johnLock ] raise: ConflictingObjectFound;
		should: [ self repository update: stallone with: self ellaTravolta ] raise: ConflictingObjectFound;
		assertRepositoryIncludesSilvesterStallone
]

{ #category : #'tests - conflict checking' }
RepositoryBasedTest >> testUpdateWithoutConflict [

	| stallone |

	self setUpRepositoryForSimpleConflictChecking.

	stallone := self silvesterStallone.
	self repository
		store: stallone;
		store: self johnTravolta.

	self shouldnt: [ self repository update: stallone with: self ellaTravolta ] raise: ConflictingObjectFound
]

{ #category : #'tests - querying' }
RepositoryBasedTest >> testWithOneMatchingSortedByDoElse [

	self repository
		store: self silvesterStallone;
		store: self silvesterMcCoy;
		store: self johnTravolta;
		store: self johnLock.

	self repository
		withOneMatching: [ :extraterrestrial :criteria | criteria does: extraterrestrial lastName asUppercase includeSubstring: 'L' ]
		sortedBy: #firstName ascending , #lastName descending
		do: [ :extraterrestrial | 
			self
				assert: extraterrestrial lastName equals: 'Travolta';
				assert: extraterrestrial firstName equals: 'John'
			]
		else: [ self fail ]
]
