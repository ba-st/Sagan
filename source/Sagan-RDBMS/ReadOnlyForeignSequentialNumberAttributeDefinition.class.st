Class {
	#name : 'ReadOnlyForeignSequentialNumberAttributeDefinition',
	#superclass : 'AttributeDefinition',
	#instVars : [
		'attributeName'
	],
	#category : 'Sagan-RDBMS-Attributes',
	#package : 'Sagan-RDBMS',
	#tag : 'Attributes'
}

{ #category : 'Instance Creation' }
ReadOnlyForeignSequentialNumberAttributeDefinition class >> named: aSymbol [

	^ self new initializeNamed: aSymbol
]

{ #category : 'Defining' }
ReadOnlyForeignSequentialNumberAttributeDefinition >> defineAttributesOn: aGlorpClassModel using: aDescriptorSystem [

	aDescriptorSystem defineBasicAttributeOn: aGlorpClassModel withoutDirectAccessNamed: attributeName
]

{ #category : 'Initialization' }
ReadOnlyForeignSequentialNumberAttributeDefinition >> initializeNamed: aSymbol [

	attributeName := aSymbol
]
