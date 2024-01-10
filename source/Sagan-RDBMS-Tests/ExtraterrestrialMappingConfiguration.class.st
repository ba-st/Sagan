Class {
	#name : 'ExtraterrestrialMappingConfiguration',
	#superclass : 'RDBMSMappingConfiguration',
	#category : 'Sagan-RDBMS-Tests',
	#package : 'Sagan-RDBMS-Tests'
}

{ #category : 'applying' }
ExtraterrestrialMappingConfiguration >> cull: aRepository [

	aRepository configureWith: [ :rdbmsRepository |
		rdbmsRepository
			beAwareOfTableDefinedBy: ( RealTableDefinition
					  named: 'Extraterrestrial'
					  fieldsDefinedBy: {
							  SequentialNumberFieldDefinition new.
							  ( CharacterFieldDefinition named: 'first_name' sized: 100 ).
							  ( CharacterFieldDefinition named: 'last_name' sized: 100 ).
							  ( DateFieldDefinition named: 'birth_date' ).
							  ( CharacterFieldDefinition named: 'race_name' sized: 100 ) }
					  indexesDefinedBy: {
							  ( IndexDefinition forFieldNamed: 'first_name' ).
							  ( IndexDefinition forFieldNamed: 'last_name' ).
							  ( IndexDefinition forFieldsNamed: { 'first_name'. 'last_name' } ) } );
			beAwareOfClassModelDefinedBy:
				( ClassModelDefinition for: Extraterrestrial attributesDefinedBy: {
							  ( BasicAttributeDefinition named: RDBMSConstants sequentialNumberAttribute ).
							  ( BasicAttributeDefinition named: #firstName ).
							  ( BasicAttributeDefinition named: #lastName ).
							  ( BasicAttributeDefinition named: #birthDate ).
							  ( BasicAttributeDefinition named: #raceName ) } );
			beAwareOfDescriptorDefinedBy: ( ConcreteDescriptorDefinition
					  for: Extraterrestrial
					  onTableNamed: 'Extraterrestrial'
					  mappingsDefinedBy: {
							  ( SequentialNumberMappingDefinition onTableNamed: 'Extraterrestrial' ).
							  ( DirectMappingDefinition
								    fromAttributeNamed: #firstName
								    toFieldNamed: 'first_name'
								    onTableNamed: 'Extraterrestrial' ).
							  ( DirectMappingDefinition
								    fromAttributeNamed: #lastName
								    toFieldNamed: 'last_name'
								    onTableNamed: 'Extraterrestrial' ).
							  ( DirectMappingDefinition
								    fromAttributeNamed: #birthDate
								    toFieldNamed: 'birth_date'
								    onTableNamed: 'Extraterrestrial' ).
							  ( DirectMappingDefinition
								    fromAttributeNamed: #raceName
								    toFieldNamed: 'race_name'
								    onTableNamed: 'Extraterrestrial' ) } )
		]
]
