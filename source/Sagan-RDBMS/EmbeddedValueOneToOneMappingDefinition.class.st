Class {
	#name : 'EmbeddedValueOneToOneMappingDefinition',
	#superclass : 'MappingDefinition',
	#instVars : [
		'attributeName'
	],
	#category : 'Sagan-RDBMS-Mappings',
	#package : 'Sagan-RDBMS',
	#tag : 'Mappings'
}

{ #category : 'Instance Creation' }
EmbeddedValueOneToOneMappingDefinition class >> forAttributeNamed: anAttributeName [

	^ self new initializeForAttributeNamed: anAttributeName
]

{ #category : 'Defining' }
EmbeddedValueOneToOneMappingDefinition >> defineMappingOn: aDescriptor using: aDescriptorSystem [

	^ aDescriptorSystem defineEmbeddedValueOneToOneMappingOn: aDescriptor forAttributeNamed: attributeName
]

{ #category : 'Initialization' }
EmbeddedValueOneToOneMappingDefinition >> initializeForAttributeNamed: anAttributeName [

	attributeName := anAttributeName
]

{ #category : 'Printing' }
EmbeddedValueOneToOneMappingDefinition >> printOn: aStream [

	aStream
		print: attributeName;
		space;
		nextPutAll: '(embedded mapping)';
		yourself
]
