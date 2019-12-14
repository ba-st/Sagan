Class {
	#name : #PooledRDBMSRepositoryProviderTest,
	#superclass : #RepositoryBasedTest,
	#category : #'Sagan-RDBMS-Tests'
}

{ #category : #'private-configuring' }
PooledRDBMSRepositoryProviderTest >> configureExtraterrestrialMappings [

	extraterrestrials
		configureMappingsIn: [ :rdbmsRepository |
			rdbmsRepository
				beAwareOfTableDefinedBy:
					( RealTableDefinition
						named: 'Extraterrestrial'
						fieldsDefinedBy:
							{SequentialNumberFieldDefinition new.
							( CharacterFieldDefinition named: 'first_name' sized: 100 ).
							( CharacterFieldDefinition named: 'last_name' sized: 100 )} );
				beAwareOfClassModelDefinedBy:
					( ClassModelDefinition
						for: Extraterrestrial
						attributesDefinedBy:
							{( BasicAttributeDefinition named: RDBMSConstants sequentialNumberAttribute ).
							( BasicAttributeDefinition named: #firstName ).
							( BasicAttributeDefinition named: #lastName )} );
				beAwareOfDescriptorDefinedBy:
					( ConcreteDescriptorDefinition
						for: Extraterrestrial
						onTableNamed: 'Extraterrestrial'
						mappingsDefinedBy:
							{( SequentialNumberMappingDefinition onTableNamed: 'Extraterrestrial' ).
							( DirectMappingDefinition
								fromAttributeNamed: #firstName
								toFieldNamed: 'first_name'
								onTableNamed: 'Extraterrestrial' ).
							( DirectMappingDefinition
								fromAttributeNamed: #lastName
								toFieldNamed: 'last_name'
								onTableNamed: 'Extraterrestrial' )} )
			]
]

{ #category : #'private-configuring' }
PooledRDBMSRepositoryProviderTest >> configureSpaceshipMappings [

	spaceships
		configureMappingsIn: [ :rdbmsRepository |
			rdbmsRepository
				beAwareOfTableDefinedBy:
					( RealTableDefinition
						named: 'Spaceship'
						fieldsDefinedBy:
							{SequentialNumberFieldDefinition new.
							( CharacterFieldDefinition named: 'name' sized: 100 )} );
				beAwareOfClassModelDefinedBy:
					( ClassModelDefinition
						for: Spaceship
						attributesDefinedBy:
							{( BasicAttributeDefinition named: RDBMSConstants sequentialNumberAttribute ).
							( BasicAttributeDefinition named: #name )} );
				beAwareOfDescriptorDefinedBy:
					( ConcreteDescriptorDefinition
						for: Spaceship
						onTableNamed: 'Spaceship'
						mappingsDefinedBy:
							{( SequentialNumberMappingDefinition onTableNamed: 'Spaceship' ).
							( DirectMappingDefinition
								fromAttributeNamed: #name
								toFieldNamed: 'name'
								onTableNamed: 'Spaceship' )} )
			]
]

{ #category : #initialization }
PooledRDBMSRepositoryProviderTest >> setUpRepositoryWith: aConflictCheckingStrategy [

	| provider |

	provider := PooledRDBMSRepositoryProvider using: RDMBSRepositoryTest login.
	extraterrestrials := provider
		createRepositoryStoringObjectsOfType: Extraterrestrial
		checkingConflictsAccordingTo: aConflictCheckingStrategy.
	self configureExtraterrestrialMappings.
	spaceships := provider
		createRepositoryStoringObjectsOfType: Spaceship
		checkingConflictsAccordingTo: aConflictCheckingStrategy.
	self configureSpaceshipMappings.
	provider prepareForInitialPersistence
]

{ #category : #tests }
PooledRDBMSRepositoryProviderTest >> testUpdateWithOutsideTransactWillFail [

	" When using a session pool, the update must be done in the same transaction as the lookup of 
	the object to be updated, otherwise Glorp will try to do an insert instead of an update "

	| stallone |

	stallone := self silvesterStallone.
	self extraterrestrials store: stallone.
	self
		assert: self extraterrestrials findAll size equals: 1;
		assert: ( self extraterrestrials findAll includes: stallone ).

	self should: [ self extraterrestrials update: stallone with: self johnLock ] raise: PersistenceCommandFailed.

	self assert: self extraterrestrials findAll size equals: 1.

	self extraterrestrials
		withOneMatching: [ :extraterrestrial | extraterrestrial firstName = 'Silvester' ]
		do: [ :john | self assert: john lastName equals: 'Stallone' ]
		else: [ self fail ].

	self
		assert:
			( self extraterrestrials findAllMatching: [ :extraterrestrial | extraterrestrial lastName = 'Lock' ] )
				isEmpty
]
