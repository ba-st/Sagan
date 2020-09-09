Class {
	#name : #PooledRDBMSRepositoryProviderTest,
	#superclass : #RepositoryBasedTest,
	#instVars : [
		'provider'
	],
	#category : #'Sagan-RDBMS-Tests'
}

{ #category : #utility }
PooledRDBMSRepositoryProviderTest >> assertFleetOf: aMothership isEquivalentToFleetOf: anotherMothership [

	self assert: aMothership fleet size equals: anotherMothership fleet size.
	aMothership fleet
		do: [ :aMember | 
			self
				assert: ( anotherMothership fleet anySatisfy: [ :anotherMember | aMember name = anotherMember name ] )
			]
]

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
PooledRDBMSRepositoryProviderTest >> configureMothershipMappings [

	ships
		configureMappingsIn: [ :rdbmsRepository | 
			rdbmsRepository
				beAwareOfTableDefinedBy:
					( RealTableDefinition
						named: 'Mothership'
						fieldsDefinedBy:
							{SequentialNumberFieldDefinition new.
							( CharacterFieldDefinition named: 'name' sized: 100 )} );
				beAwareOfTableDefinedBy:
					( RealTableDefinition
						named: 'Spaceship'
						fieldsDefinedBy:
							{SequentialNumberFieldDefinition new.
							( CharacterFieldDefinition named: 'name' sized: 100 ).
							( ForeignKeyFieldDefinition
								named: 'mother'
								toFieldNamed: RDBMSConstants sequentialNumberFieldName
								onTableNamed: 'MotherShip' )} );
				beAwareOfClassModelDefinedBy:
					( ClassModelDefinition
						for: Mothership
						attributesDefinedBy:
							{( BasicAttributeDefinition named: RDBMSConstants sequentialNumberAttribute ).
							( BasicAttributeDefinition named: #name ).
							( TypedCollectionAttributeDefinition named: #fleet typed: Spaceship inCollectionOfType: Array )} );
				beAwareOfClassModelDefinedBy:
					( ClassModelDefinition
						for: Spaceship
						attributesDefinedBy:
							{( BasicAttributeDefinition named: RDBMSConstants sequentialNumberAttribute ).
							( BasicAttributeDefinition named: #name )} );
				beAwareOfDescriptorDefinedBy:
					( ConcreteDescriptorDefinition
						for: Mothership
						onTableNamed: 'Mothership'
						mappingsDefinedBy:
							{( SequentialNumberMappingDefinition onTableNamed: 'Mothership' ).
							( DirectMappingDefinition
								fromAttributeNamed: #name
								toFieldNamed: 'name'
								onTableNamed: 'Mothership' ).
							( OneToManyTypedAttributeMappingDefinition
								exclusiveForNonProxyAttributeNamed: #fleet
								translatingFieldsUsing:
									( TableFieldTranslationDefinition
										translatingFieldNamed: RDBMSConstants sequentialNumberFieldName
										onTableNamed: 'Mothership'
										toFieldNamed: 'mother'
										onTableNamed: 'Spaceship' ) )	"Must disable use of proxies in that last mapping otherwise some cases of update will break. See issue #40."} );
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

{ #category : #running }
PooledRDBMSRepositoryProviderTest >> setUp [

	super setUp.
	self extraterrestrials
]

{ #category : #initialization }
PooledRDBMSRepositoryProviderTest >> setUpRepositoryWith: aConflictCheckingStrategy [

	provider := RDBMSRepositoryProvider using: SingleSessionRDMBSRepositoryTest login.
	extraterrestrials := provider
		createRepositoryStoringObjectsOfType: Extraterrestrial
		checkingConflictsAccordingTo: aConflictCheckingStrategy.
	self configureExtraterrestrialMappings.
	ships := provider
		createRepositoryStoringObjectsOfType: Mothership
		checkingConflictsAccordingTo: aConflictCheckingStrategy.
	self configureMothershipMappings.
	provider prepareForInitialPersistence
]

{ #category : #initialization }
PooledRDBMSRepositoryProviderTest >> tearDown [

	provider reset.
	super tearDown
]

{ #category : #tests }
PooledRDBMSRepositoryProviderTest >> testPurgeMothershipWithEmptyFleet [

	| sdf1 |

	sdf1 := Mothership named: 'SDF-1' withAll: {}.
	ships store: sdf1.
	ships purge: sdf1.
	self assert: ships findAll isEmpty
]

{ #category : #tests }
PooledRDBMSRepositoryProviderTest >> testPurgeMothershipWithMultipleShipFleet [

	| sdf1 |

	sdf1 := Mothership
		named: 'SDF-1'
		withAll:
			{( Spaceship named: 'VF-1A' ).
			( Spaceship named: 'VF-1D' ).
			( Spaceship named: 'VF-1J' ).
			( Spaceship named: 'VF-1S' )}.
	ships store: sdf1.
	ships purge: sdf1.
	self assert: ships findAll isEmpty
]

{ #category : #tests }
PooledRDBMSRepositoryProviderTest >> testPurgeMothershipWithSingleShipFleet [

	| sdf1 |

	sdf1 := Mothership named: 'SDF-1' withAll: {( Spaceship named: 'VF-1A' )}.
	ships store: sdf1.
	ships purge: sdf1.
	self assert: ships findAll isEmpty
]

{ #category : #tests }
PooledRDBMSRepositoryProviderTest >> testResultOfUpdateWithIsTheUpdatedObject [

	| sdf1 updatedSDF1 result |

	sdf1 := Mothership named: 'SDF-1' withAll: {}.
	updatedSDF1 := Mothership named: 'SDF-1*' withAll: {}.
	ships store: sdf1.
	result := ships update: sdf1 with: updatedSDF1.

	self assert: result name equals: updatedSDF1 name
]

{ #category : #tests }
PooledRDBMSRepositoryProviderTest >> testStoreMothershipWithEmptyFleet [

	| sdf1 |

	sdf1 := Mothership named: 'SDF-1' withAll: {}.
	ships store: sdf1.
	self assert: ships findAll size equals: 1.
	self
		withShipNamedAs: sdf1 name
		do: [ :ship | 
			self assert: ship name equals: sdf1 name.
			self assertFleetOf: ship isEquivalentToFleetOf: sdf1
			]
]

{ #category : #tests }
PooledRDBMSRepositoryProviderTest >> testStoreMothershipWithMultipleShipFleet [

	| sdf1 |

	sdf1 := Mothership
		named: 'SDF-1'
		withAll:
			{( Spaceship named: 'VF-1A' ).
			( Spaceship named: 'VF-1D' ).
			( Spaceship named: 'VF-1J' ).
			( Spaceship named: 'VF-1S' )}.
	ships store: sdf1.
	self assert: ships findAll size equals: 1.
	self
		withShipNamedAs: sdf1 name
		do: [ :ship | 
			self assert: ship name equals: sdf1 name.
			self assertFleetOf: ship isEquivalentToFleetOf: sdf1
			]
]

{ #category : #tests }
PooledRDBMSRepositoryProviderTest >> testStoreMothershipWithSingleShipFleet [

	| sdf1 |

	sdf1 := Mothership named: 'SDF-1' withAll: {( Spaceship named: 'VF-1A' )}.
	ships store: sdf1.
	self assert: ships findAll size equals: 1.
	self
		withShipNamedAs: sdf1 name
		do: [ :ship | 
			self assert: ship name equals: sdf1 name.
			self assertFleetOf: ship isEquivalentToFleetOf: sdf1
			]
]

{ #category : #tests }
PooledRDBMSRepositoryProviderTest >> testUpdateMothershipOriginallyWithEmptyFleetToNowHaveMultipleShipFleet [

	| sdf1 updatedSDF1 |

	sdf1 := Mothership named: 'SDF-1' withAll: {}.
	updatedSDF1 := Mothership named: 'SDF-1*' withAll: {( Spaceship named: 'VF-1A' )}.
	ships store: sdf1.
	ships update: sdf1 with: updatedSDF1.
	self assert: ships findAll size equals: 1.
	self
		withShipNamedAs: updatedSDF1 name
		do: [ :ship | self assertFleetOf: ship isEquivalentToFleetOf: updatedSDF1 ]
]

{ #category : #tests }
PooledRDBMSRepositoryProviderTest >> testUpdateMothershipOriginallyWithEmptyFleetToNowHaveSingleShipFleet [

	| sdf1 updatedSDF1 |

	sdf1 := Mothership named: 'SDF-1' withAll: {}.
	updatedSDF1 := Mothership
		named: 'SDF-1*'
		withAll:
			{( Spaceship named: 'VF-1A' ).
			( Spaceship named: 'VF-1D' ).
			( Spaceship named: 'VF-1J' ).
			( Spaceship named: 'VF-1S' )}.
	ships store: sdf1.
	ships update: sdf1 with: updatedSDF1.
	self assert: ships findAll size equals: 1.
	self
		withShipNamedAs: updatedSDF1 name
		do: [ :ship | self assertFleetOf: ship isEquivalentToFleetOf: updatedSDF1 ]
]

{ #category : #tests }
PooledRDBMSRepositoryProviderTest >> testUpdateMothershipOriginallyWithMultipleShipFleetToNowHaveEmptyFleet [

	| sdf1 updatedSDF1 |

	sdf1 := Mothership
		named: 'SDF-1'
		withAll:
			{( Spaceship named: 'VF-1A' ).
			( Spaceship named: 'VF-1D' )}.
	updatedSDF1 := Mothership named: 'SDF-1*' withAll: {}.
	ships store: sdf1.
	ships update: sdf1 with: updatedSDF1.
	self assert: ships findAll size equals: 1.
	self
		withShipNamedAs: updatedSDF1 name
		do: [ :ship | self assertFleetOf: ship isEquivalentToFleetOf: updatedSDF1 ]
]

{ #category : #tests }
PooledRDBMSRepositoryProviderTest >> testUpdateMothershipOriginallyWithMultipleShipFleetToNowHaveMultipleShipFleetWhichNoLongerIncludesTheOriginalShip [

	| sdf1 updatedSDF1 |

	sdf1 := Mothership
		named: 'SDF-1'
		withAll:
			{( Spaceship named: 'VF-1A' ).
			( Spaceship named: 'VF-1D' )}.
	updatedSDF1 := Mothership
		named: 'SDF-1*'
		withAll:
			{( Spaceship named: 'VF-1J' ).
			( Spaceship named: 'VF-1S' )}.
	ships store: sdf1.
	ships update: sdf1 with: updatedSDF1.
	self assert: ships findAll size equals: 1.
	self
		withShipNamedAs: updatedSDF1 name
		do: [ :ship | self assertFleetOf: ship isEquivalentToFleetOf: updatedSDF1 ]
]

{ #category : #tests }
PooledRDBMSRepositoryProviderTest >> testUpdateMothershipOriginallyWithMultipleShipFleetToNowHaveMultipleShipFleetWhichStillIncludesASubsetOfTheOriginalShips [

	| sdf1 updatedSDF1 |

	sdf1 := Mothership
		named: 'SDF-1'
		withAll:
			{( Spaceship named: 'VF-1A' ).
			( Spaceship named: 'VF-1D' )}.
	updatedSDF1 := Mothership
		named: 'SDF-1*'
		withAll:
			{( Spaceship named: 'VF-1A' ).
			( Spaceship named: 'VF-1J' ).
			( Spaceship named: 'VF-1S' )}.
	ships store: sdf1.
	ships update: sdf1 with: updatedSDF1.
	self assert: ships findAll size equals: 1.
	self
		withShipNamedAs: updatedSDF1 name
		do: [ :ship | self assertFleetOf: ship isEquivalentToFleetOf: updatedSDF1 ]
]

{ #category : #tests }
PooledRDBMSRepositoryProviderTest >> testUpdateMothershipOriginallyWithMultipleShipFleetToNowHaveMultipleShipFleetWhichStillIncludesAllOriginalShips [

	| sdf1 updatedSDF1 |

	sdf1 := Mothership
		named: 'SDF-1'
		withAll:
			{( Spaceship named: 'VF-1A' ).
			( Spaceship named: 'VF-1D' )}.
	updatedSDF1 := Mothership
		named: 'SDF-1*'
		withAll:
			{( Spaceship named: 'VF-1A' ).
			( Spaceship named: 'VF-1D' ).
			( Spaceship named: 'VF-1J' ).
			( Spaceship named: 'VF-1S' )}.
	ships store: sdf1.
	ships update: sdf1 with: updatedSDF1.
	self assert: ships findAll size equals: 1.
	self
		withShipNamedAs: updatedSDF1 name
		do: [ :ship | self assertFleetOf: ship isEquivalentToFleetOf: updatedSDF1 ]
]

{ #category : #tests }
PooledRDBMSRepositoryProviderTest >> testUpdateMothershipOriginallyWithSingleShipFleetToNowHaveDifferentSingleShipFleet [

	| sdf1 updatedSDF1 |

	sdf1 := Mothership named: 'SDF-1' withAll: {( Spaceship named: 'VF-1A' )}.
	updatedSDF1 := Mothership named: 'SDF-1*' withAll: {( Spaceship named: 'VF-1D' )}.
	ships store: sdf1.
	ships update: sdf1 with: updatedSDF1.
	self assert: ships findAll size equals: 1.
	self
		withShipNamedAs: updatedSDF1 name
		do: [ :ship | self assertFleetOf: ship isEquivalentToFleetOf: updatedSDF1 ]
]

{ #category : #tests }
PooledRDBMSRepositoryProviderTest >> testUpdateMothershipOriginallyWithSingleShipFleetToNowHaveEmptyFleet [

	| sdf1 updatedSDF1 |

	sdf1 := Mothership named: 'SDF-1' withAll: {( Spaceship named: 'VF-1A' )}.
	updatedSDF1 := Mothership named: 'SDF-1*' withAll: {}.
	ships store: sdf1.
	ships update: sdf1 with: updatedSDF1.
	self assert: ships findAll size equals: 1.
	self
		withShipNamedAs: updatedSDF1 name
		do: [ :ship | self assertFleetOf: ship isEquivalentToFleetOf: updatedSDF1 ]
]

{ #category : #tests }
PooledRDBMSRepositoryProviderTest >> testUpdateMothershipOriginallyWithSingleShipFleetToNowHaveMultipleShipFleetWhichNoLongerIncludesTheOriginalShip [

	| sdf1 updatedSDF1 |

	sdf1 := Mothership named: 'SDF-1' withAll: {( Spaceship named: 'VF-1A' )}.
	updatedSDF1 := Mothership
		named: 'SDF-1*'
		withAll:
			{( Spaceship named: 'VF-1D' ).
			( Spaceship named: 'VF-1J' ).
			( Spaceship named: 'VF-1S' )}.
	ships store: sdf1.
	ships update: sdf1 with: updatedSDF1.
	self assert: ships findAll size equals: 1.
	self
		withShipNamedAs: updatedSDF1 name
		do: [ :ship | self assertFleetOf: ship isEquivalentToFleetOf: updatedSDF1 ]
]

{ #category : #tests }
PooledRDBMSRepositoryProviderTest >> testUpdateMothershipOriginallyWithSingleShipFleetToNowHaveMultipleShipFleetWhichStillIncludesTheOriginalShip [

	| sdf1 updatedSDF1 |

	sdf1 := Mothership named: 'SDF-1' withAll: {( Spaceship named: 'VF-1A' )}.
	updatedSDF1 := Mothership
		named: 'SDF-1*'
		withAll:
			{( Spaceship named: 'VF-1A' ).
			( Spaceship named: 'VF-1D' ).
			( Spaceship named: 'VF-1J' ).
			( Spaceship named: 'VF-1S' )}.
	ships store: sdf1.
	ships update: sdf1 with: updatedSDF1.
	self assert: ships findAll size equals: 1.
	self
		withShipNamedAs: updatedSDF1 name
		do: [ :ship | self assertFleetOf: ship isEquivalentToFleetOf: updatedSDF1 ]
]

{ #category : #tests }
PooledRDBMSRepositoryProviderTest >> testUpdateWithOutsideTransact [

	| stallone |

	stallone := self silvesterStallone.
	self extraterrestrials store: stallone.
	self
		assert: self extraterrestrials findAll size equals: 1;
		assert: ( self extraterrestrials findAll includes: stallone ).

	self extraterrestrials update: stallone with: self johnLock.

	self extraterrestrials
		withOneMatching: [ :extraterrestrial | extraterrestrial firstName = 'John' ]
		do: [ :john | self assert: john lastName equals: 'Lock' ]
		else: [ self fail ].

	self
		assert:
			( self extraterrestrials
				findAllMatching: [ :extraterrestrial | extraterrestrial lastName = 'Stallone' ] ) isEmpty
]

{ #category : #utility }
PooledRDBMSRepositoryProviderTest >> withShipNamedAs: aName do: aOneArgBlock [

	ships withOneMatching: [ :ship | ship name = aName ] do: aOneArgBlock else: [ self fail ]
]
