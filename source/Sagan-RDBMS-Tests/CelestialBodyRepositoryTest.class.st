Class {
	#name : 'CelestialBodyRepositoryTest',
	#superclass : 'RepositoryProviderSystemBasedTest',
	#category : 'Sagan-RDBMS-Tests',
	#package : 'Sagan-RDBMS-Tests'
}

{ #category : 'running' }
CelestialBodyRepositoryTest >> alderaan [

	^ CelestialBody
		named: 'Alderaan'
		locatedAt: ( GalacticCoordinates x: 70 y: 35 z: 0 )
		in: 'Kuat Sector'
]

{ #category : 'running' }
CelestialBodyRepositoryTest >> setUpRepositories [

	celestialBodies := repositoryProviderSystem
		createRepositoryFor: self repositoriesContainerName
		storingObjectsOfType: CelestialBody
		checkingConflictsAccordingTo: DoNotCheckForConflictsStrategy new.

	CelestialBodyMappingConfiguration new cull: celestialBodies.
	GalacticCoordinatesMappingConfiguration new cull: celestialBodies
]

{ #category : 'running' }
CelestialBodyRepositoryTest >> tatooine [

	^ CelestialBody
		named: 'Tatooine'
		locatedAt: ( GalacticCoordinates x: 296 y: -248 z: 0 )
		in: 'Arkanis Sector'
]

{ #category : 'running' }
CelestialBodyRepositoryTest >> testFilterByCoordinateX [

	celestialBodies store: self tatooine.
	celestialBodies store: self alderaan.

	self
		withTheOnlyOneIn: ( celestialBodies findAllMatching: [ :body | body galacticCoordinates x < 100 ] )
		do: [ :found | 
			self
				assert: found name equals: 'Alderaan';
				assert: found planetarySystem equals: 'Kuat Sector';
				assert: found galacticCoordinates x closeTo: 70;
				assert: found galacticCoordinates y closeTo: 35;
				assert: found galacticCoordinates z equals: 0
			]
]

{ #category : 'running' }
CelestialBodyRepositoryTest >> testFilterByCoordinateY [

	celestialBodies store: self tatooine.
	celestialBodies store: self alderaan.

	self
		withTheOnlyOneIn:
			( celestialBodies
				findAllMatching:
					[ :body :builder | builder satisfying: body galacticCoordinates y > -500 and: body galacticCoordinates y < 0 ] )
		do: [ :found | 
			self
				assert: found name equals: 'Tatooine';
				assert: found planetarySystem equals: 'Arkanis Sector';
				assert: found galacticCoordinates x closeTo: 296;
				assert: found galacticCoordinates y closeTo: -248;
				assert: found galacticCoordinates z equals: 0
			]
]

{ #category : 'running' }
CelestialBodyRepositoryTest >> testFilterByCoordinateZ [

	celestialBodies store: self tatooine.
	celestialBodies store: self alderaan.

	self
		assert: ( celestialBodies countMatching: [ :body | body galacticCoordinates z = 0 ] )
		equals: 2
]
