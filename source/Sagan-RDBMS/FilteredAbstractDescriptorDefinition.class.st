Class {
	#name : 'FilteredAbstractDescriptorDefinition',
	#superclass : 'AbstractDescriptorDefinition',
	#instVars : [
		'abstractClass',
		'tableName',
		'mappingDefinitions',
		'postDefinitionAction'
	],
	#category : 'Sagan-RDBMS-Descriptors',
	#package : 'Sagan-RDBMS',
	#tag : 'Descriptors'
}

{ #category : 'Instance Creation' }
FilteredAbstractDescriptorDefinition class >> for: anAbstractClass onTableNamed: aTableName mappingsDefinedBy: aMappingDefinitions [

	^ self
		for: anAbstractClass
		onTableNamed: aTableName
		mappingsDefinedBy: aMappingDefinitions
		applyingAfterDefinition: [ :descriptor :system | ( system typeResolverFor: anAbstractClass ) register: descriptor abstract: true ]
]

{ #category : 'Instance Creation' }
FilteredAbstractDescriptorDefinition class >> for: anAbstractClass onTableNamed: aTableName mappingsDefinedBy: aMappingDefinitions applyingAfterDefinition: aTwoArgBlock [

	^ self new
		initializeFor: anAbstractClass
		onTableNamed: aTableName asString
		mappingsDefinedBy: aMappingDefinitions
		applyingAfterDefinition: aTwoArgBlock
]

{ #category : 'Accessing' }
FilteredAbstractDescriptorDefinition >> abstractClass [

	^ abstractClass
]

{ #category : 'Defining' }
FilteredAbstractDescriptorDefinition >> defineAbstractDescriptorFor: aDescriptor using: aDescriptorSystem [

	| descriptor |

	descriptor := aDescriptorSystem defineAbstractDescriptorUsingFilteredTypeResolverBasedOn: aDescriptor onTableNamed: tableName mappingsDefinedBy: mappingDefinitions.
	postDefinitionAction value: descriptor value: aDescriptorSystem.
	^ descriptor
]

{ #category : 'Initialization' }
FilteredAbstractDescriptorDefinition >> initializeFor: anAbstractClass onTableNamed: aTableName mappingsDefinedBy: aMappingDefinitions applyingAfterDefinition: aTwoArgBlock [

	abstractClass := anAbstractClass.
	tableName := aTableName.
	mappingDefinitions := aMappingDefinitions.
	postDefinitionAction := aTwoArgBlock
]
