Class {
	#name : #ClassModelDefinition,
	#superclass : #PersistenceConceptDefinition,
	#instVars : [
		'modelClass',
		'attributeDefinitions'
	],
	#category : #'Sagan-RDBMS-Core'
}

{ #category : #'Instance Creation' }
ClassModelDefinition class >> for: aClass attributesDefinedBy: anAttributeDefinitionCollection [

	^ self new initializeFor: aClass attributesDefinedBy: anAttributeDefinitionCollection
]

{ #category : #'Instance Creation' }
ClassModelDefinition class >> withoutAttributesFor: aClass [

	^ self for: aClass attributesDefinedBy: #()
]

{ #category : #Defining }
ClassModelDefinition >> defineFor: aGlorpClassModel using: aDescriptorSystem [

	aDescriptorSystem defineClassModelBasedOn: aGlorpClassModel withAttributesDefinedBy: attributeDefinitions
]

{ #category : #Initialization }
ClassModelDefinition >> initializeFor: aClass attributesDefinedBy: anAttributeDefinitionCollection [

	modelClass := aClass.
	attributeDefinitions := anAttributeDefinitionCollection
]

{ #category : #Testing }
ClassModelDefinition >> isFor: aGlorpClassModel [

	^ aGlorpClassModel describedClass = modelClass
]

{ #category : #Accessing }
ClassModelDefinition >> modelClass [

	^ modelClass
]

{ #category : #Printing }
ClassModelDefinition >> printOn: aStream [

	aStream
		nextPutAll: 'Class Model ';
		print: modelClass;
		nextPut: $:;
		cr.
	attributeDefinitions do: [ :attributeDefinition | aStream print: attributeDefinition ] separatedBy: [ aStream cr ]
]
