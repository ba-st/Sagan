Class {
	#name : 'TypedCollectionAttributeDefinition',
	#superclass : 'AttributeDefinition',
	#instVars : [
		'attributeName',
		'attributeType',
		'collectionType'
	],
	#category : 'Sagan-RDBMS-Attributes',
	#package : 'Sagan-RDBMS',
	#tag : 'Attributes'
}

{ #category : 'Instance Creation' }
TypedCollectionAttributeDefinition class >> named: aSymbol typed: aType inCollectionOfType: aCollectionType [

	^ self new initializeNamed: aSymbol typed: aType inCollectionOfType: aCollectionType
]

{ #category : 'Defining' }
TypedCollectionAttributeDefinition >> defineAttributesOn: aGlorpClassModel using: aDescriptorSystem [

	aDescriptorSystem
		defineTypedAttributeOn: aGlorpClassModel
		named: attributeName
		typed: attributeType
		inCollectionOfType: collectionType
]

{ #category : 'Initialization' }
TypedCollectionAttributeDefinition >> initializeNamed: aSymbol typed: aType inCollectionOfType: aCollectionType [

	attributeName := aSymbol.
	attributeType := aType.
	collectionType := aCollectionType
]

{ #category : 'Printing' }
TypedCollectionAttributeDefinition >> printOn: aStream [

	aStream
		print: attributeName;
		space;
		nextPut: $(;
		print: collectionType;
		nextPutAll: ' of ';
		print: attributeType;
		nextPut: $);
		yourself
]
