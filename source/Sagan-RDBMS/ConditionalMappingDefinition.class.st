Class {
	#name : 'ConditionalMappingDefinition',
	#superclass : 'MappingDefinition',
	#instVars : [
		'attributeName',
		'mappingDefinitions',
		'testingBlocks',
		'conditionalMessage'
	],
	#category : 'Sagan-RDBMS-Mappings',
	#package : 'Sagan-RDBMS',
	#tag : 'Mappings'
}

{ #category : 'Instance Creation' }
ConditionalMappingDefinition class >> fromAttributeNamed: anAttributeName sending: aMessage choosingFrom: aMappingDefinitionCollection accordingTo: aTestingBlockCollection [

	^ self new
		initializeFromAttributeNamed: anAttributeName
		sending: aMessage
		choosingFrom: aMappingDefinitionCollection
		accordingTo: aTestingBlockCollection
]

{ #category : 'Defining' }
ConditionalMappingDefinition >> defineMappingOn: aDescriptor using: aDescriptorSystem [

	^ aDescriptorSystem
		defineConditionalMappingOn: aDescriptor
		fromAttributeNamed: attributeName
		sending: conditionalMessage
		choosingFrom: mappingDefinitions
		accordingTo: testingBlocks
]

{ #category : 'Initialization' }
ConditionalMappingDefinition >> initializeFromAttributeNamed: anAttributeName
	sending: aMessage
	choosingFrom: aMappingDefinitionCollection
	accordingTo: aTestingBlockCollection [


	attributeName := anAttributeName.
	conditionalMessage := aMessage.
	mappingDefinitions := aMappingDefinitionCollection.
	testingBlocks := aTestingBlockCollection
]

{ #category : 'Printing' }
ConditionalMappingDefinition >> printOn: aStream [

	aStream
		print: attributeName;
		space;
		nextPutAll: '(conditional mapping)';
		space;
		nextPut: $:;
		space.
	mappingDefinitions do: [ :definition | definition printOn: aStream ] separatedBy: [ aStream nextPutAll: '; ' ]
]
