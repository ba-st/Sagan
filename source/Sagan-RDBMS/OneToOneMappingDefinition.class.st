Class {
	#name : 'OneToOneMappingDefinition',
	#superclass : 'MappingDefinition',
	#instVars : [
		'attributeName',
		'postDefinitionAction'
	],
	#category : 'Sagan-RDBMS-Mappings',
	#package : 'Sagan-RDBMS',
	#tag : 'Mappings'
}

{ #category : 'Instance Creation' }
OneToOneMappingDefinition class >> forAttributeNamed: anAttributeName [

	^ self forAttributeNamed: anAttributeName applyingAfterDefinition: self nullAction
]

{ #category : 'Instance Creation' }
OneToOneMappingDefinition class >> forAttributeNamed: anAttributeName applyingAfterDefinition: aPostDefinitionAction [

	^ self new initializeForAttributeNamed: anAttributeName applyingAfterDefinition: aPostDefinitionAction
]

{ #category : 'Instance Creation' }
OneToOneMappingDefinition class >> forReadOnlyAttributeNamed: anAttributeName [

	^ self forAttributeNamed: anAttributeName applyingAfterDefinition: self makeMappingReadOnly
]

{ #category : 'Defining' }
OneToOneMappingDefinition >> defineMappingOn: aDescriptor using: aDescriptorSystem [

	| mapping |

	mapping := aDescriptorSystem defineOneToOneMappingOn: aDescriptor forAttributeNamed: attributeName.
	postDefinitionAction value: mapping value: aDescriptorSystem.
	^ mapping
]

{ #category : 'Initialization' }
OneToOneMappingDefinition >> initializeForAttributeNamed: anAttributeName
	applyingAfterDefinition: aPostDefinitionAction [


	attributeName := anAttributeName.
	postDefinitionAction := aPostDefinitionAction
]

{ #category : 'Printing' }
OneToOneMappingDefinition >> printOn: aStream [

	aStream
		print: attributeName;
		space;
		nextPutAll: '(one to one mapping)';
		yourself
]
