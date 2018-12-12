Class {
	#name : #RealTableDefinition,
	#superclass : #TableDefinition,
	#instVars : [
		'tableName',
		'fieldDefinitions',
		'indexDefinitions'
	],
	#category : #'Sagan-RDBMS-Core'
}

{ #category : #'Instance Creation' }
RealTableDefinition class >> named: aString fieldsDefinedBy: aFieldDefinitionCollection [

	^ self named: aString fieldsDefinedBy: aFieldDefinitionCollection indexesDefinedBy: #()
]

{ #category : #'Instance Creation' }
RealTableDefinition class >> named: aString
	fieldsDefinedBy: aFieldDefinitionCollection
	indexesDefinedBy: anIndexDefinitionCollection [


	^ self new initializeNamed: aString fieldsDefinedBy: aFieldDefinitionCollection indexesDefinedBy: anIndexDefinitionCollection
]

{ #category : #Defining }
RealTableDefinition >> defineTableFor: aDatabaseTable using: aDescriptorSystem [

	aDescriptorSystem defineRealTableBasedOn: aDatabaseTable fieldsDefinedBy: fieldDefinitions indexesDefinedBy: indexDefinitions
]

{ #category : #Accessing }
RealTableDefinition >> fieldDefinitions [

	^ fieldDefinitions copy
]

{ #category : #Initialization }
RealTableDefinition >> initializeNamed: aString
	fieldsDefinedBy: aFieldDefinitionCollection
	indexesDefinedBy: anIndexDefinitionCollection [

	tableName := aString.
	fieldDefinitions := aFieldDefinitionCollection.
	indexDefinitions := anIndexDefinitionCollection
]

{ #category : #Printing }
RealTableDefinition >> printOn: aStream [

	aStream
		nextPutAll: 'Table ';
		print: tableName;
		nextPut: $:;
		cr.
	fieldDefinitions do: [ :fieldDefinition | aStream print: fieldDefinition ] separatedBy: [ aStream cr ]
]

{ #category : #Accessing }
RealTableDefinition >> tableName [

	^ tableName
]
