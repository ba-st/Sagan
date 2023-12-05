Class {
	#name : 'BinaryLargeObjectFieldDefinition',
	#superclass : 'TableFieldDefinition',
	#instVars : [
		'fieldName',
		'postDefinitionAction'
	],
	#category : 'Sagan-RDBMS-Fields',
	#package : 'Sagan-RDBMS',
	#tag : 'Fields'
}

{ #category : 'Instance Creation' }
BinaryLargeObjectFieldDefinition class >> named: aString [

	^ self named: aString applyingAfterDefinition: self makeFieldNotNullable
]

{ #category : 'Instance Creation' }
BinaryLargeObjectFieldDefinition class >> named: aString applyingAfterDefinition: aTwoArgBlock [

	^ self new initializeNamed: aString applyingAfterDefinition: aTwoArgBlock
]

{ #category : 'Instance Creation' }
BinaryLargeObjectFieldDefinition class >> nullableNamed: aString [

	^ self named: aString applyingAfterDefinition: self makeFieldNullable
]

{ #category : 'Defining' }
BinaryLargeObjectFieldDefinition >> defineFieldOn: aDatabaseTable using: aDescriptorSystem [

	| field |

	field := aDescriptorSystem defineBinaryLargeObjectFieldOn: aDatabaseTable named: fieldName.
	postDefinitionAction value: field value: aDescriptorSystem.
	^ field
]

{ #category : 'Initialization' }
BinaryLargeObjectFieldDefinition >> initializeNamed: aString applyingAfterDefinition: aTwoArgBlock [

	fieldName := aString.
	postDefinitionAction := aTwoArgBlock
]

{ #category : 'Printing' }
BinaryLargeObjectFieldDefinition >> printOn: aStream [

	aStream
		print: fieldName;
		space;
		nextPutAll: '(varbinary(max))';
		yourself
]
