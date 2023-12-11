Class {
	#name : 'ExtraterrestialRaceMappingConfiguration',
	#superclass : 'RDBMSMappingConfiguration',
	#category : 'Sagan-RDBMS-Tests',
	#package : 'Sagan-RDBMS-Tests'
}

{ #category : 'applying' }
ExtraterrestialRaceMappingConfiguration >> cull: aRepository [

	aRepository
		configureMappingsIn: [ :repository | 
			repository
				beAwareOfClassModelDefinedBy: self extraterrestialRaceClassModelDefinition;
				beAwareOfDescriptorDefinedBy: self extraterrestialRaceDescriptorDefinition;
				beAwareOfTableDefinedBy: self extraterrestialRaceTableDefinition;
				beAwareOfTableDefinedBy: self extraterrestialRaceCelestialBodyRelationTable
			]
]

{ #category : 'private - accessing' }
ExtraterrestialRaceMappingConfiguration >> extraterrestialRaceCelestialBodyRelationTable [

	^ RealTableDefinition
		named: 'ExtraterrestialRaceCelestialBodyRelation'
		fieldsDefinedBy:
			( OrderedCollection new
				add:
					( ForeignKeyFieldDefinition
						toBePrimaryKeyNamed: 'extraterrestial_race_id'
						toFieldNamed: RDBMSConstants sequentialNumberFieldName
						onTableNamed: self extraterrestialRaceTableName );
				add:
					( ForeignKeyFieldDefinition
						toBePrimaryKeyNamed: 'celestial_body_id'
						toFieldNamed: RDBMSConstants sequentialNumberFieldName
						onTableNamed: CelestialBodyMappingConfiguration celestialBodyTableName );
				yourself )
]

{ #category : 'private - accessing' }
ExtraterrestialRaceMappingConfiguration >> extraterrestialRaceClassModelDefinition [

	^ ClassModelDefinition
		for: ExtraterrestialRace
		attributesDefinedBy:
			{( BasicAttributeDefinition named: RDBMSConstants sequentialNumberAttribute ).
			( BasicAttributeDefinition named: #name ).
			( TypedCollectionAttributeDefinition
				named: #knownLocations
				typed: CelestialBody
				inCollectionOfType: OrderedCollection )}
]

{ #category : 'private - accessing' }
ExtraterrestialRaceMappingConfiguration >> extraterrestialRaceDescriptorDefinition [

	^ ConcreteDescriptorDefinition
		for: ExtraterrestialRace
		onTableNamed: self extraterrestialRaceTableName
		mappingsDefinedBy:
			{( SequentialNumberMappingDefinition onTableNamed: self extraterrestialRaceTableName ).
			( DirectMappingDefinition
				fromAttributeNamed: #name
				toFieldNamed: 'name'
				onTableNamed: self extraterrestialRaceTableName ).
			( ManyToManyAttributeMappingDefinition
				forAttributeNamed: #knownLocations
				translatingFieldsUsing:
					( TableFieldTranslationDefinition
						translatingFieldNamed: RDBMSConstants sequentialNumberFieldName
						onTableNamed: self extraterrestialRaceTableName
						toFieldNamed: 'extraterrestial_race_id'
						onTableNamed: 'ExtraterrestialRaceCelestialBodyRelation' ) )}
]

{ #category : 'private - accessing' }
ExtraterrestialRaceMappingConfiguration >> extraterrestialRaceTableDefinition [

	^ RealTableDefinition
		named: self extraterrestialRaceTableName
		fieldsDefinedBy:
			{SequentialNumberFieldDefinition new.
			( CharacterFieldDefinition named: 'name' sized: 100 )}
]

{ #category : 'private - accessing' }
ExtraterrestialRaceMappingConfiguration >> extraterrestialRaceTableName [

	^ 'ExtraterrestialRace'
]
