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
	ships := GemStoneRepositoryProvider new
		         createRepositoryStoringObjectsOfType: Spaceship
		         checkingConflictsAccordingTo: aConflictCheckingStrategy
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

{ #category : 'private - accessing' }
GemStoneRepositoryProviderTest >> timeLimitInMillisecondsWhenAdding [

	^ 2000
]

{ #category : 'private - accessing' }
GemStoneRepositoryProviderTest >> timeLimitInMillisecondsWhenQuerying [

	^ 100
]

{ #category : 'utility' }
GemStoneRepositoryProviderTest >> withAllSpaceshipsMatching: aMatchingCriteria do: aOneArgBlock [

	aOneArgBlock value: ( ships findAllMatching: aMatchingCriteria )
]
