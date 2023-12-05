Class {
	#name : 'HorizontalAbstractDescriptorDefinition',
	#superclass : 'AbstractDescriptorDefinition',
	#instVars : [
		'abstractClass',
		'postDefinitionAction'
	],
	#category : 'Sagan-RDBMS-Descriptors',
	#package : 'Sagan-RDBMS',
	#tag : 'Descriptors'
}

{ #category : 'Instance Creation' }
HorizontalAbstractDescriptorDefinition class >> for: anAbstractClass [

	^ self for: anAbstractClass applyingAfterDefinition: [ :descriptor :system | ( system typeResolverFor: anAbstractClass ) register: descriptor abstract: true ]
]

{ #category : 'Instance Creation' }
HorizontalAbstractDescriptorDefinition class >> for: anAbstractClass applyingAfterDefinition: aTwoArgBlock [

	^ self new initializeFor: anAbstractClass applyingAfterDefinition: aTwoArgBlock
]

{ #category : 'Accessing' }
HorizontalAbstractDescriptorDefinition >> abstractClass [

	^ abstractClass
]

{ #category : 'Defining' }
HorizontalAbstractDescriptorDefinition >> defineAbstractDescriptorFor: aDescriptor using: aDescriptorSystem [

	| descriptor |

	descriptor := aDescriptorSystem defineAbstractDescriptorUsingHorizontalTypeResolverBasedOn: aDescriptor.
	postDefinitionAction value: descriptor value: aDescriptorSystem.
	^ descriptor
]

{ #category : 'Initialization' }
HorizontalAbstractDescriptorDefinition >> initializeFor: anAbstractClass applyingAfterDefinition: aTwoArgBlock [

	abstractClass := anAbstractClass.
	postDefinitionAction := aTwoArgBlock
]
