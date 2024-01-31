Class {
	#name : 'InMemoryRepositoryProviderModuleTest',
	#superclass : 'TestCase',
	#category : 'Sagan-Kepler-Tests',
	#package : 'Sagan-Kepler-Tests'
}

{ #category : 'private - accessing' }
InMemoryRepositoryProviderModuleTest >> repositoryIn: aUserStory [

	^ aUserStory rootSystem >> #RepositoryProviderSystem
		  createRepositoryFor: #mainDB
		  storingObjectsOfType: CelestialBody
		  checkingConflictsAccordingTo: DoNotCheckForConflictsStrategy new
]

{ #category : 'tests' }
InMemoryRepositoryProviderModuleTest >> testAccessing [

	| module |

	module := InMemoryRepositoryProviderModule toInstallOn: 'a system'.
	self
		assert: module name equals: 'In Memory Repository Provider';
		assert: module rootSystem equals: 'a system';
		assertCollection: module systemInterfacesToInstall equals: #( #RepositoryProviderSystem )
]

{ #category : 'tests' }
InMemoryRepositoryProviderModuleTest >> testInstallation [

	| userStory celestialBodies |

	userStory := self userStoryTest.
	userStory setUp.
	celestialBodies := self repositoryIn: userStory.

	self assert: celestialBodies findAll isEmpty
]

{ #category : 'private - accessing' }
InMemoryRepositoryProviderModuleTest >> userStoryTest [

	^ PluggableUserStoryTest requiring: [ :test |
		  test registerSubsystem: ( RepositoryProviderSystem new
				    register: InMemoryRepositoryProvider new as: #mainDB;
				    yourself )
		  ]
]
