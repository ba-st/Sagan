Class {
	#name : #CharacterLargeObjectFieldDefinition,
	#superclass : #TableFieldDefinition,
	#instVars : [
		'fieldName',
		'postDefinitionAction'
	],
	#category : #'Sagan-RDBMS-Fields'
}

{ #category : #'Instance Creation' }
CharacterLargeObjectFieldDefinition class >> named: aString [

	^ self named: aString applyingAfterDefinition: self makeFieldNotNullable
]

{ #category : #'Instance Creation' }
CharacterLargeObjectFieldDefinition class >> named: aString applyingAfterDefinition: aTwoArgBlock [

	^ self new initializeNamed: aString applyingAfterDefinition: aTwoArgBlock
]

{ #category : #'Instance Creation' }
CharacterLargeObjectFieldDefinition class >> nullableNamed: aString [

	^ self named: aString applyingAfterDefinition: self makeFieldNullable
]

{ #category : #Defining }
CharacterLargeObjectFieldDefinition >> defineFieldOn: aDatabaseTable using: aDescriptorSystem [

	| field |

	field := aDescriptorSystem defineCharacterLargeObjectFieldOn: aDatabaseTable named: fieldName.
	postDefinitionAction value: field value: aDescriptorSystem.
	^ field
]

{ #category : #Initialization }
CharacterLargeObjectFieldDefinition >> initializeNamed: aString applyingAfterDefinition: aTwoArgBlock [

	fieldName := aString.
	postDefinitionAction := aTwoArgBlock
]

{ #category : #Printing }
CharacterLargeObjectFieldDefinition >> printOn: aStream [

	aStream
		print: fieldName;
		space;
		nextPutAll: '(varchar(8000))';
		yourself
]
