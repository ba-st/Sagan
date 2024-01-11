Class {
	#name : 'GemStoneRepositoryProviderTest',
	#superclass : 'RepositoryBasedTest',
	#category : 'Sagan-GemStone-Tests',
	#package : 'Sagan-GemStone-Tests'
}

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
GemStoneRepositoryProviderTest >> testFindApplyingWhenCollectionIsLarge [

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
			self
				assert: ( self extraterrestrials findApplying: 'each.firstName = ''Silvester''' ) size
				equals: 4
			]
		notTakeMoreThanMilliseconds: 1
]

{ #category : 'tests' }
GemStoneRepositoryProviderTest >> testFindApplyingWhenCollectionIsLargeAndNotIndexed [

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
		self assert: ( notIndexed findApplying: 'each.firstName = ''Silvester''' ) size equals: 4 ]
		notTakeMoreThanMilliseconds: 17
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

{ #category : 'private - accessing' }
GemStoneRepositoryProviderTest >> timeLimitInMillisecondsWhenAdding [

	^ 200
]

{ #category : 'private - accessing' }
GemStoneRepositoryProviderTest >> timeLimitInMillisecondsWhenQuerying [

	^ 3
]

{ #category : 'utility' }
GemStoneRepositoryProviderTest >> withAllSpaceshipsMatching: aMatchingCriteria do: aOneArgBlock [

	aOneArgBlock value: ( ships findAllMatching: aMatchingCriteria )
]
