Class {
	#name : #BasicAttributeDefinition,
	#superclass : #AttributeDefinition,
	#instVars : [
		'attributeName'
	],
	#category : #'Sagan-RDBMS-Attributes'
}

{ #category : #'Instance Creation' }
BasicAttributeDefinition class >> named: aSymbol [

	^ self new initializeNamed: aSymbol
]

{ #category : #Defining }
BasicAttributeDefinition >> defineAttributesOn: aGlorpClassModel using: aDescriptorSystem [

	aDescriptorSystem defineBasicAttributeOn: aGlorpClassModel named: attributeName
]

{ #category : #Initialization }
BasicAttributeDefinition >> initializeNamed: aSymbol [

	attributeName := aSymbol
]

{ #category : #Printing }
BasicAttributeDefinition >> printOn: aStream [

	aStream
		print: attributeName;
		space;
		nextPutAll: '(basic)';
		yourself
]
