Class {
	#name : 'RealTableDefinition',
	#superclass : 'TableDefinition',
	#instVars : [
		'tableName',
		'fieldDefinitions',
		'indexDefinitions'
	],
	#category : 'Sagan-RDBMS-Core',
	#package : 'Sagan-RDBMS',
	#tag : 'Core'
}

{ #category : 'Instance Creation' }
RealTableDefinition class >> named: aName fieldsDefinedBy: aFieldDefinitionCollection [

	^ self named: aName fieldsDefinedBy: aFieldDefinitionCollection indexesDefinedBy: #()
]

{ #category : 'Instance Creation' }
RealTableDefinition class >> named: aName
	fieldsDefinedBy: aFieldDefinitionCollection
	indexesDefinedBy: anIndexDefinitionCollection [


	^ self new
		initializeNamed: aName asString
		fieldsDefinedBy: aFieldDefinitionCollection
		indexesDefinedBy: anIndexDefinitionCollection
]

{ #category : 'Defining' }
RealTableDefinition >> defineTableFor: aDatabaseTable using: aDescriptorSystem [

	aDescriptorSystem defineRealTableBasedOn: aDatabaseTable fieldsDefinedBy: fieldDefinitions indexesDefinedBy: indexDefinitions
]

{ #category : 'Accessing' }
RealTableDefinition >> fieldDefinitions [

	^ fieldDefinitions copy
]

{ #category : 'Initialization' }
RealTableDefinition >> initializeNamed: aString
	fieldsDefinedBy: aFieldDefinitionCollection
	indexesDefinedBy: anIndexDefinitionCollection [

	tableName := aString.
	fieldDefinitions := aFieldDefinitionCollection.
	indexDefinitions := anIndexDefinitionCollection
]

{ #category : 'Printing' }
RealTableDefinition >> printOn: aStream [

	aStream
		nextPutAll: 'Table ';
		print: tableName;
		nextPut: $:;
		cr.
	fieldDefinitions do: [ :fieldDefinition | aStream print: fieldDefinition ] separatedBy: [ aStream cr ]
]

{ #category : 'Accessing' }
RealTableDefinition >> tableName [

	^ tableName
]
