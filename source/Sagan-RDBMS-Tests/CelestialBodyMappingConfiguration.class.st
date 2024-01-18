Class {
	#name : 'CelestialBodyMappingConfiguration',
	#superclass : 'RDBMSMappingConfiguration',
	#category : 'Sagan-RDBMS-Tests',
	#package : 'Sagan-RDBMS-Tests'
}

{ #category : 'accessing' }
CelestialBodyMappingConfiguration class >> celestialBodyTableName [

	^ 'CELESTIAL_BODY'
]

{ #category : 'private - accessing' }
CelestialBodyMappingConfiguration >> celestialBodyClassDefinition [

	^ ClassModelDefinition
		for: CelestialBody
		attributesDefinedBy:
			{( BasicAttributeDefinition named: RDBMSConstants sequentialNumberAttribute ).
			( BasicAttributeDefinition named: #name ).
			( BasicAttributeDefinition named: #planetarySystem ).
			( TypedAttributeDefinition named: #galacticCoordinates typed: GalacticCoordinates )}
]

{ #category : 'private - accessing' }
CelestialBodyMappingConfiguration >> celestialBodyDescriptorDefinition [

	^ ConcreteDescriptorDefinition
		for: CelestialBody
		onTableNamed: self celestialBodyTableName
		mappingsDefinedBy:
			{( SequentialNumberMappingDefinition onTableNamed: self celestialBodyTableName ).
			( DirectMappingDefinition
				fromAttributeNamed: #name
				toFieldNamed: 'name'
				onTableNamed: self celestialBodyTableName ).
			( DirectMappingDefinition
				fromAttributeNamed: #planetarySystem
				toFieldNamed: 'planetary_system'
				onTableNamed: self celestialBodyTableName ).
			( EmbeddedValueOneToOneMappingWithTranslationDefinition
				forAttributeNamed: #galacticCoordinates
				translatingFieldsUsingAll:
					( Array
						with:
							( TableFieldTranslationDefinition
								translatingFieldNamed: 'x'
								onTableNamed: self celestialBodyTableName
								toFieldNamed: GalacticCoordinatesMappingConfiguration xCoordinateFieldName
								onTableNamed: GalacticCoordinatesMappingConfiguration galacticCoordinatesTableName )
						with:
							( TableFieldTranslationDefinition
								translatingFieldNamed: 'y'
								onTableNamed: self celestialBodyTableName
								toFieldNamed: GalacticCoordinatesMappingConfiguration yCoordinateFieldName
								onTableNamed: GalacticCoordinatesMappingConfiguration galacticCoordinatesTableName )
						with:
							( TableFieldTranslationDefinition
								translatingFieldNamed: 'z'
								onTableNamed: self celestialBodyTableName
								toFieldNamed: GalacticCoordinatesMappingConfiguration zCoordinateFieldName
								onTableNamed: GalacticCoordinatesMappingConfiguration galacticCoordinatesTableName ) ) )}
]

{ #category : 'private - accessing' }
CelestialBodyMappingConfiguration >> celestialBodyTableDefinition [

	^ RealTableDefinition
		  named: self celestialBodyTableName
		  fieldsDefinedBy: {
				  SequentialNumberFieldDefinition new.
				  ( CharacterFieldDefinition named: 'name' sized: 100 ).
				  ( CharacterFieldDefinition named: 'planetary_system' sized: 100 ).
				  ( DecimalFieldDefinition named: 'x' ).
				  ( DecimalFieldDefinition named: 'y' ).
				  ( DecimalFieldDefinition named: 'z' ) }
		  indexesDefinedBy: { ( IndexDefinition forFieldNamed: 'name' ) }
]

{ #category : 'private - accessing' }
CelestialBodyMappingConfiguration >> celestialBodyTableName [

	^ self class celestialBodyTableName
]

{ #category : 'applying' }
CelestialBodyMappingConfiguration >> cull: aRepository [

	aRepository
		configureWith: [ :repository | 
			repository
				beAwareOfClassModelDefinedBy: self celestialBodyClassDefinition;
				beAwareOfDescriptorDefinedBy: self celestialBodyDescriptorDefinition;
				beAwareOfTableDefinedBy: self celestialBodyTableDefinition
			]
]
