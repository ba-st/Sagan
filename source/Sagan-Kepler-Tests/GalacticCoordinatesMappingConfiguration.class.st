Class {
	#name : #GalacticCoordinatesMappingConfiguration,
	#superclass : #RDBMSMappingConfiguration,
	#category : #'Sagan-Kepler-Tests'
}

{ #category : #accessing }
GalacticCoordinatesMappingConfiguration class >> galacticCoordinatesTableName [

	^ 'GALACTIC_COORDINATES'
]

{ #category : #accessing }
GalacticCoordinatesMappingConfiguration class >> xCoordinateFieldName [

	^ 'x'
]

{ #category : #accessing }
GalacticCoordinatesMappingConfiguration class >> yCoordinateFieldName [

	^ 'y'
]

{ #category : #accessing }
GalacticCoordinatesMappingConfiguration class >> zCoordinateFieldName [

	^ 'z'
]

{ #category : #applying }
GalacticCoordinatesMappingConfiguration >> applyTo: aRepository [

	aRepository
		configureMappingsIn: [ :repository | 
			repository
				beAwareOfClassModelDefinedBy: self galacticCoordinatesClassDefinition;
				beAwareOfTableDefinedBy: self galacticCoordinatesTableDefinition;
				beAwareOfDescriptorDefinedBy: self galacticCoordinatesDescriptorDefinition
			]
]

{ #category : #'private - accessing' }
GalacticCoordinatesMappingConfiguration >> galacticCoordinatesClassDefinition [

	^ ClassModelDefinition
		for: GalacticCoordinates
		attributesDefinedBy:
			{( BasicAttributeDefinition named: #x ).
			( BasicAttributeDefinition named: #y ).
			( BasicAttributeDefinition named: #z )}
]

{ #category : #'private - accessing' }
GalacticCoordinatesMappingConfiguration >> galacticCoordinatesDescriptorDefinition [

	^ ConcreteDescriptorDefinition
		for: GalacticCoordinates
		onTableNamed: self class galacticCoordinatesTableName
		mappingsDefinedBy:
			{( DirectMappingDefinition
				fromAttributeNamed: #x
				toFieldNamed: self class xCoordinateFieldName 
				onTableNamed: self class galacticCoordinatesTableName ).
			( DirectMappingDefinition
				fromAttributeNamed: #y
				toFieldNamed: self class yCoordinateFieldName 
				onTableNamed: self class galacticCoordinatesTableName ).
			( DirectMappingDefinition
				fromAttributeNamed: #z
				toFieldNamed: self class zCoordinateFieldName 
				onTableNamed: self class galacticCoordinatesTableName )}
]

{ #category : #'private - accessing' }
GalacticCoordinatesMappingConfiguration >> galacticCoordinatesTableDefinition [

	^ ImaginaryTableDefinition
		named: self class galacticCoordinatesTableName
		fieldsDefinedBy:
			{( DecimalFieldDefinition named: self class xCoordinateFieldName ).
			( DecimalFieldDefinition named: self class yCoordinateFieldName ).
			( DecimalFieldDefinition named: self class zCoordinateFieldName )}
]
