"
I'm an abstract Test Case for testing the Repository implementations.

My subclasses must provide a way to setup a functioning repository.
"
Class {
	#name : #RepositoryBasedTest,
	#superclass : #TestCase,
	#instVars : [
		'extraterrestrials',
		'ships'
	],
	#category : #'Sagan-Core-Tests'
}

{ #category : #testing }
RepositoryBasedTest class >> isAbstract [ 

	^self name = #RepositoryBasedTest
]

{ #category : #'private - assertions' }
RepositoryBasedTest >> assertRepositoryIncludesSilvesterStallone [

	self extraterrestrials
		withOneMatching: [ :extraterrestrial | extraterrestrial firstName = 'Silvester' ]
		do: [ :extraterrestrial | self assert: extraterrestrial lastName equals: 'Stallone' ]
		else: [ self fail ]
]

{ #category : #'private - assertions' }
RepositoryBasedTest >> assertTheOnlyOneInTheRepositoryIsSilvesterStallone [

	self
		withTheOnlyOneIn: self extraterrestrials findAll
		do: [ :extraterrestrial | 
			self
				assert: extraterrestrial firstName equals: 'Silvester';
				assert: extraterrestrial lastName equals: 'Stallone'
			]
]

{ #category : #'private - extraterrestrials' }
RepositoryBasedTest >> ellaTravolta [

	^ self extraterrestrialNamedFirst: 'Ella' last: 'Travolta' bornOn: '2000-04-03' asDate
]

{ #category : #'private - extraterrestrials' }
RepositoryBasedTest >> extraterrestrialNamedFirst: aFirstName last: aLastName bornOn: aDate [

	^ Extraterrestrial namedFirst: aFirstName last: aLastName bornOn: aDate
]

{ #category : #'private - accessing' }
RepositoryBasedTest >> extraterrestrials [ 

	extraterrestrials ifNil: [ self setUpRepositoryWithNoConflictChecking  ].
	^ extraterrestrials 
]

{ #category : #'private - extraterrestrials' }
RepositoryBasedTest >> johnLock [

	^ self extraterrestrialNamedFirst: 'John' last: 'Lock' bornOn: '1632-08-29' asDate
]

{ #category : #'private - extraterrestrials' }
RepositoryBasedTest >> johnTravolta [

	^ self extraterrestrialNamedFirst: 'John' last: 'Travolta' bornOn: '1954-02-18' asDate
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

	^ self extraterrestrialNamedFirst: 'Silvester' last: 'McCoy' bornOn: '1943-08-20' asDate
]

{ #category : #'private - extraterrestrials' }
RepositoryBasedTest >> silvesterStallone [

	^ self extraterrestrialNamedFirst: 'Silvester' last: 'Stallone' bornOn: '1946-07-06' asDate
]

{ #category : #'private - extraterrestrials' }
RepositoryBasedTest >> sistineStallone [

	^ self extraterrestrialNamedFirst: 'Sistine' last: 'Stallone' bornOn: '1998-06-27' asDate
]

{ #category : #'tests - querying' }
RepositoryBasedTest >> testCountMatching [

	self extraterrestrials
		store: self silvesterStallone;
		store: self sistineStallone.

	self
		assert: ( self extraterrestrials countMatching: [ :person | person lastName = 'Stallone' ] ) equals: 2;
		assert: ( self extraterrestrials countMatching: [ :person | person firstName = 'Silvester' ] ) equals: 1; 
		assert: ( self extraterrestrials countMatching: [ :person | person birthDate = '1998-06-27' asDate ] ) equals: 1
]

{ #category : #'tests - querying' }
RepositoryBasedTest >> testFindAllMatching [

	self extraterrestrials
		store: self johnTravolta;
		store: self johnLock;
		store: self silvesterStallone.

	self
		assert:
			( self extraterrestrials
				findAllMatching: [ :extraterrestrial | extraterrestrial firstName = 'Silvester' ] ) size
			equals: 1;
		assert:
			( self extraterrestrials
				findAllMatching: [ :extraterrestrial | extraterrestrial firstName = 'Yoko' ] ) isEmpty;
		assert:
			( self extraterrestrials
				findAllMatching: [ :extraterrestrial :criteria | criteria does: extraterrestrial firstName includeSubstring: 'J' ] )
				size
			equals: 2;
		assert:
			( self extraterrestrials
				findAllMatching:
					[ :extraterrestrial :criteria | criteria is: extraterrestrial lastName includedIn: {'Travolta' . 'Lock'} ] )
				size
			equals: 2
]

{ #category : #'tests - querying' }
RepositoryBasedTest >> testFindAllMatchingSortedBy [

	| sorted |

	self extraterrestrials
		store: self silvesterStallone;
		store: self silvesterMcCoy;
		store: self johnTravolta;
		store: self johnLock.

	sorted := self extraterrestrials
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

{ #category : #'tests - querying' }
RepositoryBasedTest >> testFindAllMatchingSortedByBirthDate [

	| sorted |

	self extraterrestrials
		store: self silvesterStallone;
		store: self silvesterMcCoy;
		store: self johnTravolta;
		store: self johnLock.

	sorted := self extraterrestrials
		findAllMatching: [ :extraterrestrial :criteria | criteria does: extraterrestrial lastName asUppercase includeSubstring: 'L' ]
		sortedBy: #birthDate ascending.

	self
		assert: sorted size equals: 3;
		assert: sorted first lastName equals: 'Lock';
		assert: sorted first firstName equals: 'John';
		assert: sorted second lastName equals: 'Stallone';
		assert: sorted second firstName equals: 'Silvester';
		assert: sorted last lastName equals: 'Travolta';
		assert: sorted last firstName equals: 'John'
]

{ #category : #'tests - management' }
RepositoryBasedTest >> testPurge [

	| stallone |

	stallone := self silvesterStallone.
	self extraterrestrials store: stallone.
	self assertTheOnlyOneInTheRepositoryIsSilvesterStallone.

	self extraterrestrials purge: stallone.
	self assert: self extraterrestrials findAll isEmpty
]

{ #category : #'tests - management' }
RepositoryBasedTest >> testPurgeAllMatching [

	self extraterrestrials
		store: self johnTravolta;
		store: self ellaTravolta;
		store: self silvesterStallone.

	self assert: self extraterrestrials findAll size equals: 3.

	self extraterrestrials purgeAllMatching: [ :extraterrestrial | extraterrestrial lastName = 'Travolta' ].

	self assertTheOnlyOneInTheRepositoryIsSilvesterStallone
]

{ #category : #'tests - management' }
RepositoryBasedTest >> testPurgeAllMatchingWhenNoneMatches [

	self assert: self extraterrestrials findAll isEmpty.

	self extraterrestrials purgeAllMatching: [ :extraterrestrial | extraterrestrial lastName = 'Travolta' ].

	self assert: self extraterrestrials findAll isEmpty.

	self extraterrestrials store: self silvesterStallone.

	self extraterrestrials purgeAllMatching: [ :extraterrestrial | extraterrestrial lastName = 'Travolta' ].

	self assertTheOnlyOneInTheRepositoryIsSilvesterStallone
]

{ #category : #'tests - management' }
RepositoryBasedTest >> testPurgeAllMatchingWhenOnlySomeMatch [

	self extraterrestrials
		store: self silvesterStallone;
		store: self silvesterMcCoy;
		store: self johnTravolta;
		store: self ellaTravolta.

	self assert: self extraterrestrials findAll size equals: 4.

	self extraterrestrials purgeAllMatching: [ :extraterrestrial | extraterrestrial firstName = 'Silvester' ].

	self assert: self extraterrestrials findAll size equals: 2.
	self extraterrestrials
		withOneMatching: [ :extraterrestrial | extraterrestrial firstName = 'John' ]
			do: [ :person | self assert: person lastName equals: 'Travolta' ]
			else: [ self fail ];
		withOneMatching: [ :extraterrestrial | extraterrestrial firstName = 'Ella' ]
			do: [ :person | self assert: person lastName equals: 'Travolta' ]
			else: [ self fail ]
]

{ #category : #'tests - management' }
RepositoryBasedTest >> testStore [

	self extraterrestrials
		store: self johnTravolta;
		store: self silvesterStallone.

	self assert: self extraterrestrials findAll size equals: 2.
	self assertRepositoryIncludesSilvesterStallone.
	self extraterrestrials
		withOneMatching: [ :extraterrestrial | extraterrestrial firstName = 'John' ]
		do: [ :extraterrestrial | self assert: extraterrestrial lastName equals: 'Travolta' ]
		else: [ self fail ]
]

{ #category : #'tests - conflict checking' }
RepositoryBasedTest >> testStoreWithConflict [

	self setUpRepositoryForSimpleConflictChecking.

	self extraterrestrials store: self silvesterStallone.

	self
		should: [ self extraterrestrials store: self silvesterMcCoy ] raise: ConflictingObjectFound;
		assertTheOnlyOneInTheRepositoryIsSilvesterStallone
]

{ #category : #'tests - conflict checking' }
RepositoryBasedTest >> testStoreWithConjunctiveConflictChecking [

	self setUpRepositoryForConjunctiveConflictChecking.

	self extraterrestrials store: self silvesterStallone.

	self
		shouldnt: [ self extraterrestrials store: self silvesterMcCoy ] raise: ConflictingObjectFound;
		shouldnt: [ self extraterrestrials store: self sistineStallone ] raise: ConflictingObjectFound;
		should: [ self extraterrestrials store: self silvesterStallone ] raise: ConflictingObjectFound.

	self
		assert: self extraterrestrials findAll size equals: 3;
		assertRepositoryIncludesSilvesterStallone
]

{ #category : #'tests - conflict checking' }
RepositoryBasedTest >> testStoreWithDisjunctiveConflictChecking [

	self setUpRepositoryForDisjunctiveConflictChecking.

	self extraterrestrials store: self silvesterStallone.

	self
		should: [ self extraterrestrials store: self silvesterMcCoy ] raise: ConflictingObjectFound;
		should: [ self extraterrestrials store: self sistineStallone ] raise: ConflictingObjectFound;
		should: [ self extraterrestrials store: self silvesterStallone ] raise: ConflictingObjectFound.

	self assertTheOnlyOneInTheRepositoryIsSilvesterStallone
]

{ #category : #'tests - management' }
RepositoryBasedTest >> testUpdateInSameSessionAsFetch [

	| stallone john |

	john := self johnLock.
	self extraterrestrials store: john.
	self
		assert: self extraterrestrials findAll size equals: 1;
		assert: ( self extraterrestrials findAll includes: john ).

	stallone := self silvesterStallone.
	self extraterrestrials
		transact: [ self extraterrestrials
				withOneMatching: [ :extraterrestrial | extraterrestrial firstName = 'John' ]
				do: [ :lock | self extraterrestrials update: lock with: stallone ]
				else: [ self fail ]
			].

	self assertTheOnlyOneInTheRepositoryIsSilvesterStallone
]

{ #category : #'tests - management' }
RepositoryBasedTest >> testUpdateWith [

	| stallone |

	stallone := self silvesterStallone.
	self extraterrestrials store: stallone.
	self
		assert: self extraterrestrials findAll size equals: 1;
		assert: ( self extraterrestrials findAll includes: stallone ).

	self
		updateExtraterrestialMatching: [ :extraterrestrial | extraterrestrial firstName = 'Silvester' ]
		with: self johnLock.

	self assert: self extraterrestrials findAll size equals: 1.

	self extraterrestrials
		withOneMatching: [ :extraterrestrial | extraterrestrial firstName = 'John' ]
		do: [ :john | self assert: john lastName equals: 'Lock' ]
		else: [ self fail ].

	self
		assert:
			( self extraterrestrials
				findAllMatching: [ :extraterrestrial | extraterrestrial lastName = 'Stallone' ] ) isEmpty
]

{ #category : #'tests - conflict checking' }
RepositoryBasedTest >> testUpdateWithConflict [

	| stallone |

	self setUpRepositoryForSimpleConflictChecking.

	stallone := self silvesterStallone.
	self extraterrestrials
		store: stallone;
		store: self johnTravolta.

	self
		should: [ self extraterrestrials update: stallone with: self johnLock ]
			raise: ConflictingObjectFound
			withMessageText: 'Something is in conflict with an Extraterrestrial';
		assertRepositoryIncludesSilvesterStallone
]

{ #category : #'tests - conflict checking' }
RepositoryBasedTest >> testUpdateWithConflictUsingConjunctiveConflictChecking [

	| stallone |

	self setUpRepositoryForConjunctiveConflictChecking.

	stallone := self silvesterStallone.
	self extraterrestrials
		store: stallone;
		store: self johnTravolta.

	self
		should: [ self
				updateExtraterrestialMatching: [ :extraterrestial | extraterrestial lastName = 'Stallone' ]
				with: self johnTravolta
			]
			raise: ConflictingObjectFound
			withMessageText: 'Something is in conflict with an Extraterrestrial';
		shouldnt: [ self
				updateExtraterrestialMatching: [ :extraterrestial | extraterrestial lastName = 'Stallone' ]
				with: self johnLock
			]
			raise: ConflictingObjectFound;
		shouldnt: [ self
				updateExtraterrestialMatching: [ :extraterrestial | extraterrestial lastName = 'Lock' ]
				with: self ellaTravolta
			]
			raise: ConflictingObjectFound
]

{ #category : #'tests - conflict checking' }
RepositoryBasedTest >> testUpdateWithConflictUsingDisjunctiveConflictChecking [

	| stallone |

	self setUpRepositoryForDisjunctiveConflictChecking.

	stallone := self silvesterStallone.
	self extraterrestrials
		store: stallone;
		store: self johnTravolta.

	self
		should: [ self extraterrestrials update: stallone with: self johnTravolta ] raise: ConflictingObjectFound;
		should: [ self extraterrestrials update: stallone with: self johnLock ] raise: ConflictingObjectFound;
		should: [ self extraterrestrials update: stallone with: self ellaTravolta ] raise: ConflictingObjectFound;
		assertRepositoryIncludesSilvesterStallone
]

{ #category : #'tests - conflict checking' }
RepositoryBasedTest >> testUpdateWithoutConflict [

	| stallone |

	self setUpRepositoryForSimpleConflictChecking.

	stallone := self silvesterStallone.
	self extraterrestrials
		store: stallone;
		store: self johnTravolta.

	self
		shouldnt: [ self
				updateExtraterrestialMatching: [ :extraterrestial | extraterrestial lastName = 'Stallone' ]
				with: self ellaTravolta
			]
		raise: ConflictingObjectFound
]

{ #category : #'tests - querying' }
RepositoryBasedTest >> testWithOneMatchingSortedByDoElse [

	self extraterrestrials
		store: self silvesterStallone;
		store: self silvesterMcCoy;
		store: self johnTravolta;
		store: self johnLock.

	self extraterrestrials
		withOneMatching: [ :extraterrestrial :criteria | criteria does: extraterrestrial lastName asUppercase includeSubstring: 'L' ]
		sortedBy: #firstName ascending , #lastName descending
		do: [ :extraterrestrial | 
			self
				assert: extraterrestrial lastName equals: 'Travolta';
				assert: extraterrestrial firstName equals: 'John'
			]
		else: [ self fail ]
]

{ #category : #'tests - management' }
RepositoryBasedTest >> updateExtraterrestialMatching: aBlock with: aNewExtraterrestial [

	self extraterrestrials
		transact: [ self extraterrestrials
				withOneMatching: aBlock
				do: [ :extraterrestial | self extraterrestrials update: extraterrestial with: aNewExtraterrestial ]
				else: [ self fail ]
			]
]
