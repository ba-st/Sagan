Class {
	#name : 'GemstoneRepositoryProviderTest',
	#superclass : 'RepositoryBasedTest',
	#category : 'Sagan-Gemstone-Tests',
	#package : 'Sagan-Gemstone-Tests'
}

{ #category : 'initialization' }
GemstoneRepositoryProviderTest >> setUpRepositoryWith: aConflictCheckingStrategy [

	extraterrestrials := GemstoneRepositoryProvider new
		                     createRepositoryStoringObjectsOfType: Extraterrestrial
		                     checkingConflictsAccordingTo: aConflictCheckingStrategy.
	ships := GemstoneRepositoryProvider new
		         createRepositoryStoringObjectsOfType: Spaceship
		         checkingConflictsAccordingTo: aConflictCheckingStrategy
]

{ #category : 'tests' }
GemstoneRepositoryProviderTest >> testSpaceshipQueryingForPositiveFirepower [

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
GemstoneRepositoryProviderTest >> testSpaceshipQueryingForZeroFirepower [

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

{ #category : 'utility' }
GemstoneRepositoryProviderTest >> withAllSpaceshipsMatching: aMatchingCriteria do: aOneArgBlock [

	aOneArgBlock value: ( ships findAllMatching: aMatchingCriteria )
]
