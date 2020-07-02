"
I have the Unit Tests for the In Memory Repository implementation. 
"
Class {
	#name : #InMemoryRepositoryProviderTest,
	#superclass : #RepositoryBasedTest,
	#category : #'Sagan-Core-Tests'
}

{ #category : #initialization }
InMemoryRepositoryProviderTest >> setUpRepositoryWith: aConflictCheckingStrategy [

	extraterrestrials := InMemoryRepositoryProvider new
		createRepositoryStoringObjectsOfType: Extraterrestrial
		checkingConflictsAccordingTo: aConflictCheckingStrategy.
	ships := InMemoryRepositoryProvider new
		createRepositoryStoringObjectsOfType: Spaceship
		checkingConflictsAccordingTo: aConflictCheckingStrategy
]

{ #category : #tests }
InMemoryRepositoryProviderTest >> testSpaceshipQueryingForPositiveFirepower [

	self setUpRepositoryWithNoConflictChecking.

	ships store: ( Spaceship withoutFirepowerNamed: 'Solvalou' ).
	ships store: ( Spaceship named: 'Solgrado' firepower: 7650 ).
	ships store: ( Spaceship withUnlimitedFirepowerNamed: 'Zeodalley' ).

	self
		withAllSpaceshipsMatching:
			[ :spaceship :builder | builder isUndefined: spaceship firepower otherwiseSatisfy: spaceship firepower > 0 ]
		do: [ :spaceships | 
			self assert: spaceships size equals: 2.
			self assert: ( spaceships anySatisfy: [ :spaceship | spaceship name = 'Solgrado' ] ).
			self assert: ( spaceships anySatisfy: [ :spaceship | spaceship name = 'Zeodalley' ] )
			]
]

{ #category : #tests }
InMemoryRepositoryProviderTest >> testSpaceshipQueryingForZeroFirepower [

	self setUpRepositoryWithNoConflictChecking.

	ships store: ( Spaceship withoutFirepowerNamed: 'Solvalou' ).
	ships store: ( Spaceship named: 'Solgrado' firepower: 7650 ).
	ships store: ( Spaceship withUnlimitedFirepowerNamed: 'Zeodalley' ).

	self
		withAllSpaceshipsMatching: [ :spaceship :builder | builder satisfyingAny: {( spaceship firepower = 0 )} ]
		do: [ :spaceships | 
			self assert: spaceships size equals: 1.
			self assert: ( spaceships anySatisfy: [ :spaceship | spaceship name = 'Solvalou' ] )
			]
]

{ #category : #utility }
InMemoryRepositoryProviderTest >> withAllSpaceshipsMatching: aMatchingCriteria do: aOneArgBlock [

	aOneArgBlock value: ( ships findAllMatching: aMatchingCriteria )
]
