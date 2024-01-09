"
I have the Unit Tests for the In Memory Repository implementation. 
"
Class {
	#name : 'InMemoryRepositoryProviderTest',
	#superclass : 'RepositoryBasedTest',
	#category : 'Sagan-Core-Tests',
	#package : 'Sagan-Core-Tests'
}

{ #category : 'initialization' }
InMemoryRepositoryProviderTest >> setUpRepositoryWith: aConflictCheckingStrategy [

	extraterrestrials := InMemoryRepositoryProvider new
		createRepositoryStoringObjectsOfType: Extraterrestrial
		checkingConflictsAccordingTo: aConflictCheckingStrategy.
	ships := InMemoryRepositoryProvider new
		createRepositoryStoringObjectsOfType: Spaceship
		checkingConflictsAccordingTo: aConflictCheckingStrategy
]

{ #category : 'tests' }
InMemoryRepositoryProviderTest >> testSpaceshipQueryingForPositiveFirepower [

	| solvalou solgrado zeodalley |

	self setUpRepositoryWithNoConflictChecking.

	solvalou := Spaceship withoutFirepowerNamed: 'Solvalou'.
	solgrado := Spaceship named: 'Solgrado' firepower: 7650.
	zeodalley := Spaceship withUnlimitedFirepowerNamed: 'Zeodalley'.

	ships store: solvalou.
	ships store: solgrado.
	ships store: zeodalley.

	self
		withAllSpaceshipsMatching:
			[ :spaceship :builder | builder isUndefined: spaceship firepower otherwiseSatisfy: spaceship firepower > 0 ]
		do: [ :spaceships | 
			self
				assertCollection: spaceships
				hasSameElements:
					{solgrado.
					zeodalley}
			]
]

{ #category : 'tests' }
InMemoryRepositoryProviderTest >> testSpaceshipQueryingForZeroFirepower [

	| solvalou solgrado zeodalley |

	self setUpRepositoryWithNoConflictChecking.

	solvalou := Spaceship withoutFirepowerNamed: 'Solvalou'.
	solgrado := Spaceship named: 'Solgrado' firepower: 7650.
	zeodalley := Spaceship withUnlimitedFirepowerNamed: 'Zeodalley'.

	ships store: solvalou.
	ships store: solgrado.
	ships store: zeodalley.

	self
		withAllSpaceshipsMatching: [ :spaceship :builder | builder satisfyingAny: {( spaceship firepower = 0 )} ]
		do: [ :spaceships | self assertCollection: spaceships hasSameElements: {solvalou} ]
]

{ #category : 'private - accessing' }
InMemoryRepositoryProviderTest >> timeLimitInMillisecondsWhenAdding [

	^ 2000
]

{ #category : 'private - accessing' }
InMemoryRepositoryProviderTest >> timeLimitInMillisecondsWhenQuerying [

	^ 100
]

{ #category : 'utility' }
InMemoryRepositoryProviderTest >> withAllSpaceshipsMatching: aMatchingCriteria do: aOneArgBlock [

	aOneArgBlock value: ( ships findAllMatching: aMatchingCriteria )
]
