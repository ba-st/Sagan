Class {
	#name : #ImaginaryTableDefinition,
	#superclass : #TableDefinition,
	#instVars : [
		'tableDefinition'
	],
	#category : #'Sagan-RDBMS-Core'
}

{ #category : #Preconditions }
ImaginaryTableDefinition class >> assertNoForeignKeyFieldDefinitionsOn: aFieldDefinitionCollection [

	( aFieldDefinitionCollection
		anySatisfy: [ :fieldDefinition | fieldDefinition isForForeignKeys ] )
		ifTrue: [ self error signal: 'Foreign keys can''t be defined against imaginary tables.' ]
]

{ #category : #'Instance Creation' }
ImaginaryTableDefinition class >> named: aString fieldsDefinedBy: aFieldDefinitionCollection [

	self assertNoForeignKeyFieldDefinitionsOn: aFieldDefinitionCollection.
	^ self new initializeNamed: aString fieldsDefinedBy: aFieldDefinitionCollection
]

{ #category : #Defining }
ImaginaryTableDefinition >> defineTableFor: aDatabaseTable using: aDescriptorSystem [

	aDescriptorSystem defineImaginaryTableBasedOn: aDatabaseTable using: tableDefinition
]

{ #category : #Accessing }
ImaginaryTableDefinition >> fieldDefinitions [

	^ tableDefinition fieldDefinitions
]

{ #category : #Initialization }
ImaginaryTableDefinition >> initializeNamed: aString fieldsDefinedBy: aFieldDefinitionCollection [

	tableDefinition := RealTableDefinition named: aString fieldsDefinedBy: aFieldDefinitionCollection
]

{ #category : #Printing }
ImaginaryTableDefinition >> printOn: aStream [

	aStream
		nextPutAll: 'Imaginary Table ';
		print: self tableName;
		nextPut: $:;
		cr.
	self fieldDefinitions do: [ :fieldDefinition | aStream print: fieldDefinition ] separatedBy: [ aStream cr ]
]

{ #category : #Accessing }
ImaginaryTableDefinition >> tableName [

	^ tableDefinition tableName
]
