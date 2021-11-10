Class {
	#name : #ExtraterrestialRaceRepositoryTest,
	#superclass : #RepositoryProviderSystemBasedTest,
	#instVars : [
		'extraterrestialRaces'
	],
	#category : #'Sagan-RDBMS-Tests'
}

{ #category : #accessing }
ExtraterrestialRaceRepositoryTest >> alderaan [

	^ CelestialBody
		named: 'Alderaan'
		locatedAt: ( GalacticCoordinates x: 70 y: 35 z: 0 )
		in: 'Kuat Sector'
]

{ #category : #running }
ExtraterrestialRaceRepositoryTest >> setUpRepositories [

	celestialBodies := repositoryProviderSystem
		createRepositoryFor: self repositoriesContainerName
		storingObjectsOfType: CelestialBody
		checkingConflictsAccordingTo: DoNotCheckForConflictsStrategy new.

	CelestialBodyMappingConfiguration new cull: celestialBodies.
	GalacticCoordinatesMappingConfiguration new cull: celestialBodies.

	extraterrestialRaces := repositoryProviderSystem
		createRepositoryFor: self repositoriesContainerName
		storingObjectsOfType: ExtraterrestialRace
		checkingConflictsAccordingTo: DoNotCheckForConflictsStrategy new.

	ExtraterrestialRaceMappingConfiguration new cull: extraterrestialRaces
]

{ #category : #accessing }
ExtraterrestialRaceRepositoryTest >> tatooine [

	^ CelestialBody
		named: 'Tatooine'
		locatedAt: ( GalacticCoordinates x: 296 y: -248 z: 0 )
		in: 'Arkanis Sector'
]

{ #category : #tests }
ExtraterrestialRaceRepositoryTest >> testCreateOneRaceFoundInOnePlanet [

	| tatooine hutt racesFound |

	tatooine := celestialBodies store: self tatooine.

	hutt := ExtraterrestialRace named: 'Hutt' foundIn: {tatooine}.

	extraterrestialRaces store: hutt.

	racesFound := extraterrestialRaces
		findAllMatching: [ :race | race knownLocations includes: tatooine ].

	self assertCollection: racesFound hasSameElements: {hutt}.
	self assertCollection: racesFound anyOne knownLocations hasSameElements: {tatooine}
]

{ #category : #tests }
ExtraterrestialRaceRepositoryTest >> testCreateOneRaceFoundInTwoPlanets [

	| humans tatooine alderaan racesInTatooine |

	tatooine := celestialBodies store: self tatooine.
	alderaan := celestialBodies store: self alderaan.

	humans := ExtraterrestialRace
		named: 'Humans'
		foundIn:
			{tatooine.
			alderaan}.

	extraterrestialRaces store: humans.

	racesInTatooine := extraterrestialRaces
		findAllMatching: [ :race | race knownLocations includes: tatooine ].

	self assertCollection: racesInTatooine hasSameElements: {humans}.
	self
		assertCollection: racesInTatooine anyOne knownLocations
		hasSameElements:
			{tatooine.
			alderaan}
]

{ #category : #tests }
ExtraterrestialRaceRepositoryTest >> testCreateTwoRacesFoundInSamePlanet [

	| tatooine hutt tuskenRaiders racesInTatooine |

	tatooine := celestialBodies store: self tatooine.

	hutt := ExtraterrestialRace named: 'Hutt' foundIn: {tatooine}.
	tuskenRaiders := ExtraterrestialRace named: 'Tusken Raiders' foundIn: {tatooine}.

	extraterrestialRaces store: hutt.
	extraterrestialRaces store: tuskenRaiders.

	racesInTatooine := extraterrestialRaces
		findAllMatching: [ :race | race knownLocations includes: tatooine ].

	self
		assertCollection: racesInTatooine
		hasSameElements:
			{hutt.
			tuskenRaiders}.
	self assertCollection: racesInTatooine first knownLocations hasSameElements: {tatooine}.
	self assertCollection: racesInTatooine second knownLocations hasSameElements: {tatooine}
]
