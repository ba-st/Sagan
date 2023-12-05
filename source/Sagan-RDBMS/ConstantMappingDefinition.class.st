Class {
	#name : 'ConstantMappingDefinition',
	#superclass : 'MappingDefinition',
	#instVars : [
		'attributeName',
		'constant',
		'postDefinitionAction'
	],
	#category : 'Sagan-RDBMS-Mappings',
	#package : 'Sagan-RDBMS',
	#tag : 'Mappings'
}

{ #category : 'Instance Creation' }
ConstantMappingDefinition class >> fromAttributeNamed: anAttributeName mappingTo: anObject [

	^ self fromAttributeNamed: anAttributeName mappingTo: anObject applyingAfterDefinition: self nullAction
]

{ #category : 'Instance Creation' }
ConstantMappingDefinition class >> fromAttributeNamed: anAttributeName mappingTo: anObject applyingAfterDefinition: aOneArgBlock [

	^ self new
		initializeFromAttributeNamed: anAttributeName
		mappingTo: anObject
		applyingAfterDefinition: aOneArgBlock
]

{ #category : 'Defining' }
ConstantMappingDefinition >> defineMappingOn: aDescriptor using: aDescriptorSystem [

	| mapping |

	mapping := aDescriptorSystem
		defineConstantMappingOn: aDescriptor
		fromAttributeNamed: attributeName
		mappedTo: constant.
	postDefinitionAction value: mapping value: aDescriptorSystem.
	^ mapping
]

{ #category : 'Initialization' }
ConstantMappingDefinition >> initializeFromAttributeNamed: anAttributeName mappingTo: anObject applyingAfterDefinition: aOneArgBlock [

	attributeName := anAttributeName.
	constant := anObject.
	postDefinitionAction := aOneArgBlock
]

{ #category : 'Printing' }
ConstantMappingDefinition >> printOn: aStream [

	aStream
		print: attributeName;
		nextPutAll: ' -> ';
		print: constant;
		space;
		nextPutAll: '(constant mapping)';
		yourself
]
