Class {
	#name : #TypedAttributeDefinition,
	#superclass : #AttributeDefinition,
	#instVars : [
		'attributeName',
		'attributeType'
	],
	#category : #'Sagan-RDBMS-Attributes'
}

{ #category : #'Instance Creation' }
TypedAttributeDefinition class >> named: aSymbol typed: aType [

	^ self new initializeNamed: aSymbol typed: aType
]

{ #category : #Defining }
TypedAttributeDefinition >> defineAttributesOn: aGlorpClassModel using: aDescriptorSystem [

	aDescriptorSystem defineTypedAttributeOn: aGlorpClassModel named: attributeName typed: attributeType
]

{ #category : #Initialization }
TypedAttributeDefinition >> initializeNamed: aSymbol typed: aType [

	attributeName := aSymbol.
	attributeType := aType
]

{ #category : #Printing }
TypedAttributeDefinition >> printOn: aStream [

	aStream
		print: attributeName;
		space;
		nextPut: $(;
		print: attributeType;
		nextPut: $);
		yourself
]
