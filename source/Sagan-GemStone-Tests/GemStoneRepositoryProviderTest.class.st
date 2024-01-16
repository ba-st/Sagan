Class {
	#name : 'GemStoneRepositoryProviderTest',
	#superclass : 'RepositoryBasedTest',
	#category : 'Sagan-GemStone-Tests',
	#package : 'Sagan-GemStone-Tests'
}

{ #category : 'utility' }
GemStoneRepositoryProviderTest >> pickTwoElementsFrom: aQuery [

	| chosen |

	chosen := Set new.
	aQuery do: [ :each |
		chosen size >= 2 ifTrue: [ ^ chosen ].
		chosen add: each
		].
	^ chosen
]

{ #category : 'initialization' }
GemStoneRepositoryProviderTest >> setUpRepositoryWith: aConflictCheckingStrategy [

	extraterrestrials := GemStoneRepositoryProvider new
		                     createRepositoryStoringObjectsOfType: Extraterrestrial
		                     checkingConflictsAccordingTo: aConflictCheckingStrategy.
	extraterrestrials configureWith: [ :repository |
		repository
			indexByEquality: 'firstName' typed: String;
			indexByEquality: 'lastName' typed: String
		].
	ships := GemStoneRepositoryProvider new
		         createRepositoryStoringObjectsOfType: Spaceship
		         checkingConflictsAccordingTo: aConflictCheckingStrategy
]

{ #category : 'tests' }
GemStoneRepositoryProviderTest >> testQueryReturningBeforeAllIndexedResultsAreRead [

	| one two three four five six seven |

	self setUpRepositoryWithNoConflictChecking.
	ships configureWith: [ :repository | repository indexByEquality: 'firepower' typed: Integer ].

	one := Spaceship named: 'one' firepower: 1001.
	two := Spaceship named: 'two' firepower: 2002.
	three := Spaceship named: 'three' firepower: 3003.
	four := Spaceship named: 'four' firepower: 4004.
	five := Spaceship named: 'five' firepower: 5005.
	six := Spaceship named: 'six' firepower: 6006.
	seven := Spaceship named: 'seven' firepower: 7007.

	ships
		store: one;
		store: two;
		store: three;
		store: four;
		store: five;
		store: six;
		store: seven.

	ships withQueryFrom: '2001 <= each.firepower < 6000' do: [ :query |
		| chosen |

		chosen := self pickTwoElementsFrom: query.
		self assert: chosen size equals: 2.
		self assert: ( chosen allSatisfy: [ :each | each firepower between: 2000 and: 6000 - 1 ] )
		]
]

{ #category : 'tests' }
GemStoneRepositoryProviderTest >> testQueryingWhenCollectionIsLargeAndIndexed [

	4 timesRepeat: [
		1000 timesRepeat: [
			self extraterrestrials
				store: self johnTravolta;
				store: self johnLock;
				store: self ellaTravolta
			].

		self extraterrestrials store: self silvesterStallone.

		1000 timesRepeat: [
			self extraterrestrials
				store: self johnTravolta;
				store: self johnLock;
				store: self ellaTravolta
			]
		].
	self
		should: [
			self extraterrestrials withQueryFrom: 'each.firstName = ''Silvester''' do: [ :query |
				self assert: query size equals: 4.
				query do: [ :extraterrestrial |
					self
						assert: extraterrestrial firstName equals: 'Silvester';
						assert: extraterrestrial lastName equals: 'Stallone'
					]
				]
			]
		notTakeMoreThanMilliseconds: 2
]

{ #category : 'tests' }
GemStoneRepositoryProviderTest >> testQueryingWhenCollectionIsLargeButNotIndexed [

	| notIndexed |

	notIndexed := GemStoneRepositoryProvider new
		              createRepositoryStoringObjectsOfType: Extraterrestrial
		              checkingConflictsAccordingTo: DoNotCheckForConflictsStrategy new.

	4 timesRepeat: [
		1000 timesRepeat: [
			notIndexed
				store: self johnTravolta;
				store: self johnLock;
				store: self ellaTravolta
			].

		notIndexed store: self silvesterStallone.

		1000 timesRepeat: [
			notIndexed
				store: self johnTravolta;
				store: self johnLock;
				store: self ellaTravolta
			]
		].

	self
		should: [
			notIndexed withQueryFrom: 'each.firstName = ''Silvester''' do: [ :query |
				self assert: query size equals: 4.
				query do: [ :extraterrestrial |
					self
						assert: extraterrestrial firstName equals: 'Silvester';
						assert: extraterrestrial lastName equals: 'Stallone'
					]
				]
			]
		notTakeMoreThanMilliseconds: 17
]

{ #category : 'tests' }
GemStoneRepositoryProviderTest >> testSetValueQueryUsingSetValueIndex [

	| fleets mothers motherships |

	"Index paths that include collections, and the queries that use these indexes, are generally referred to as Set-valued indexes and queries for historical reasons, although any kind of indexable collection, not just Sets, may be used."

	fleets := {
		          {
			          ( Spaceship named: 'VF-1A' ).
			          ( Spaceship named: 'VF-1D' ).
			          ( Spaceship named: 'VF-1J' ).
			          ( Spaceship named: 'VF-1S' ) } asSet.
		          {
			          ( Spaceship named: 'VF-2A' ).
			          ( Spaceship named: 'VF-2D' ).
			          ( Spaceship named: 'VF-2J' ).
			          ( Spaceship named: 'VF-2S' ) } asSet }.

	mothers := {
		           ( Mothership named: 'SDF-1' withAll: fleets first ).
		           ( Mothership named: 'SDF-2' withAll: fleets last ).
		           ( Mothership named: 'SDF-1' withAll: fleets last ) }.

	motherships := GemStoneRepositoryProvider new
		               createRepositoryStoringObjectsOfType: Mothership
		               checkingConflictsAccordingTo: DoNotCheckForConflictsStrategy new.
	motherships configureWith: [ :repository |
		repository
			indexByEquality: 'name' typed: String;
			indexByEquality: 'fleet.*.name' typed: String
		].

	mothers do: [ :mother | motherships store: mother ].

	motherships
		withQueryFrom: '(each.fleet.*.name = ''VF-1D'') & (each.name = ''SDF-1'')'
		do: [ :query | self assertCollection: query asArray hasSameElements: { mothers first } ]
]

{ #category : 'tests' }
GemStoneRepositoryProviderTest >> testSpaceshipFirepowerRangeQuery [

	| solvalou solgrado zeodalley |

	self setUpRepositoryWithNoConflictChecking.
	ships configureWith: [ :repository | repository indexByEquality: 'firepower' typed: Integer ].

	solvalou := Spaceship withoutFirepowerNamed: 'Solvalou'.
	solgrado := Spaceship named: 'Solgrado' firepower: 7650.
	zeodalley := Spaceship named: 'Zeodalley' firepower: 2117.

	ships store: solvalou.
	ships store: solgrado.
	ships store: zeodalley.

	ships
		withQueryFrom: '2117 < each.firepower <= 8000'
		do: [ :query | self assertCollection: query queryResult asSet hasSameElements: { solgrado } ]
]

{ #category : 'tests' }
GemStoneRepositoryProviderTest >> testSpaceshipQueryingForPositiveFirepower [

	| solvalou solgrado zeodalley |

	self setUpRepositoryWithNoConflictChecking.

	solvalou := Spaceship withoutFirepowerNamed: 'Solvalou'.
	solgrado := Spaceship named: 'Solgrado' firepower: 7650.
	zeodalley := Spaceship withUnlimitedFirepowerNamed: 'Zeodalley'.

	ships store: solvalou.
	ships store: solgrado.
	ships store: zeodalley.

	self
		withAllSpaceshipsMatching: [ :spaceship :builder |
			builder isUndefined: spaceship firepower otherwiseSatisfy: spaceship firepower > 0 ]
		do: [ :spaceships |
			self assertCollection: spaceships hasSameElements: {
					solgrado.
					zeodalley }
			]
]

{ #category : 'tests' }
GemStoneRepositoryProviderTest >> testSpaceshipQueryingForZeroFirepower [

	| solvalou solgrado zeodalley |

	self setUpRepositoryWithNoConflictChecking.

	solvalou := Spaceship withoutFirepowerNamed: 'Solvalou'.
	solgrado := Spaceship named: 'Solgrado' firepower: 7650.
	zeodalley := Spaceship withUnlimitedFirepowerNamed: 'Zeodalley'.

	ships store: solvalou.
	ships store: solgrado.
	ships store: zeodalley.

	self
		withAllSpaceshipsMatching: [ :spaceship :builder |
		builder satisfyingAny: { ( spaceship firepower = 0 ) } ]
		do: [ :spaceships | self assertCollection: spaceships hasSameElements: { solvalou } ]
]

{ #category : 'tests' }
GemStoneRepositoryProviderTest >> testSpaceshipWhenUsingIdentityIndex [

	| solvalou anotherSolvalou zeodalley |

	self setUpRepositoryWithNoConflictChecking.
	ships configureWith: [ :repository | repository indexByIdentity: 'name' ].

	solvalou := Spaceship withoutFirepowerNamed: 'Solvalou'.
	anotherSolvalou := Spaceship withoutFirepowerNamed: 'Solvalou'.
	zeodalley := Spaceship withoutFirepowerNamed: 'Zeodalley'.

	ships store: solvalou.
	ships store: anotherSolvalou.
	ships store: zeodalley.

	self withAllSpaceshipsMatching: [ :spaceship | spaceship name = 'Solvalou' ] do: [ :spaceships |
		self assertCollection: spaceships hasSameElements: {
				solvalou.
				anotherSolvalou }
		]
]

{ #category : 'tests' }
GemStoneRepositoryProviderTest >> testStreamQueryResults [

	self extraterrestrials
		store: self johnTravolta;
		store: self johnLock;
		store: self ellaTravolta;
		store: self silvesterStallone.

	self extraterrestrials withQueryFrom: 'each.firstName = ''Silvester''' do: [ :query |
		| stream extraterrestrial |

		stream := query readStream.
		extraterrestrial := stream next.
		self
			assert: extraterrestrial firstName equals: 'Silvester';
			assert: extraterrestrial lastName equals: 'Stallone'.
		self assert: stream atEnd
		]
]

{ #category : 'utility' }
GemStoneRepositoryProviderTest >> withAllSpaceshipsMatching: aMatchingCriteria do: aOneArgBlock [

	aOneArgBlock value: ( ships findAllMatching: aMatchingCriteria )
]
