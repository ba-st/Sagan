Class {
	#name : #ImaginaryTableDefinitionTest,
	#superclass : #TestCase,
	#category : #'Sagan-RDBMS-Tests'
}

{ #category : #Test }
ImaginaryTableDefinitionTest >> testImaginaryTableDefinitionWithForeignKeyFieldShouldNotBeAllowed [

	self
		should: [ ImaginaryTableDefinition
				named: 'PEOPLE'
				fieldsDefinedBy: {( ForeignKeyFieldDefinition named: 'address' toFieldNamed: 'id' onTableNamed: 'ADDRESS' )}
			]
		raise: Error
]
