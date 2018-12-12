Class {
	#name : #EmbeddedValueOneToOneMappingWithTranslationDefinition,
	#superclass : #MappingDefinition,
	#instVars : [
		'basicDefinition',
		'fieldTranslationDefinitions'
	],
	#category : #'Sagan-RDBMS-Mappings'
}

{ #category : #'Instance Creation' }
EmbeddedValueOneToOneMappingWithTranslationDefinition class >> forAttributeNamed: anAttributeName translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection [

	^ self new
		initializeForAttributeNamed: anAttributeName
		translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection
]

{ #category : #Defining }
EmbeddedValueOneToOneMappingWithTranslationDefinition >> defineMappingOn: aDescriptor using: aDescriptorSystem [

	^ aDescriptorSystem
		defineEmbeddedValueOneToOneMappingWithTranslationOn: aDescriptor
		translatingFieldsUsingAll: fieldTranslationDefinitions
		basedOn: basicDefinition
]

{ #category : #Initialization }
EmbeddedValueOneToOneMappingWithTranslationDefinition >> initializeForAttributeNamed: anAttributeName
	translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection [


	basicDefinition := EmbeddedValueOneToOneMappingDefinition forAttributeNamed: anAttributeName.
	fieldTranslationDefinitions := aTableFieldTranslationDefinitionCollection
]

{ #category : #Printing }
EmbeddedValueOneToOneMappingWithTranslationDefinition >> printOn: aStream [

	aStream
		print: basicDefinition;
		space;
		nextPutAll: '(with translation)';
		yourself
]
