Class {
	#name : 'IndexDefinition',
	#superclass : 'PersistenceConceptDefinition',
	#instVars : [
		'fieldNames'
	],
	#category : 'Sagan-RDBMS-Core',
	#package : 'Sagan-RDBMS',
	#tag : 'Core'
}

{ #category : 'Instance Creation' }
IndexDefinition class >> forFieldNamed: aFieldName [

	^ self forFieldsNamed: ( Array with: aFieldName )
]

{ #category : 'Instance Creation' }
IndexDefinition class >> forFieldsNamed: aFieldNameCollection [

	^ self new initializeForFieldsNamed: aFieldNameCollection
]

{ #category : 'Defining' }
IndexDefinition >> defineFor: aDatabaseTable using: aDescriptorSystem [ 
	^aDescriptorSystem
	defineIndexOn: aDatabaseTable
	forFieldsNamed: fieldNames
]

{ #category : 'Initialization' }
IndexDefinition >> initializeForFieldsNamed: aFieldNameCollection [ 
	fieldNames := aFieldNameCollection
]

{ #category : 'Printing' }
IndexDefinition >> printOn: aStream [

	aStream
		nextPutAll: 'Index';
		space;
		nextPut: $:;
		space.
	( CollectionFormatter separatingWith: ', ' ) format: fieldNames on: aStream
]
