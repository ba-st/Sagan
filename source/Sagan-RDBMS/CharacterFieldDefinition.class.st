Class {
	#name : 'CharacterFieldDefinition',
	#superclass : 'TableFieldDefinition',
	#instVars : [
		'fieldName',
		'fieldSize',
		'postDefinitionAction'
	],
	#category : 'Sagan-RDBMS-Fields',
	#package : 'Sagan-RDBMS',
	#tag : 'Fields'
}

{ #category : 'Instance Creation' }
CharacterFieldDefinition class >> named: aString sized: aSmallInteger [

	^ self named: aString sized: aSmallInteger applyingAfterDefinition: self makeFieldNotNullable
]

{ #category : 'Instance Creation' }
CharacterFieldDefinition class >> named: aString sized: aSmallInteger applyingAfterDefinition: aTwoArgBlock [

	^ self new initializeNamed: aString sized: aSmallInteger applyingAfterDefinition: aTwoArgBlock
]

{ #category : 'Instance Creation' }
CharacterFieldDefinition class >> named: aString sized: aSmallInteger withDefaultValue: aValue [

	^ self
		named: aString
		sized: aSmallInteger
		applyingAfterDefinition: [ :field :system | 
			( self makeFieldHaveDefaultValue: aValue ) value: field value: system.
			self makeFieldNotNullable value: field value: system
			]
]

{ #category : 'Instance Creation' }
CharacterFieldDefinition class >> nullableNamed: aString sized: aSmallInteger [

	^ self named: aString sized: aSmallInteger applyingAfterDefinition: self makeFieldNullable
]

{ #category : 'Instance Creation' }
CharacterFieldDefinition class >> toBePrimaryKeyNamed: aString sized: aSmallInteger [

	^ self named: aString sized: aSmallInteger applyingAfterDefinition: self makeFieldPrimaryKey
]

{ #category : 'Instance Creation' }
CharacterFieldDefinition class >> uniqueNamed: aString sized: aSmallInteger [

	^ self named: aString sized: aSmallInteger applyingAfterDefinition: self makeFieldUniqueNotNullable
]

{ #category : 'Defining' }
CharacterFieldDefinition >> defineFieldOn: aDatabaseTable using: aDescriptorSystem [

	| field |

	field := aDescriptorSystem defineCharacterFieldOn: aDatabaseTable named: fieldName sized: fieldSize.
	postDefinitionAction value: field value: aDescriptorSystem.
	^ field
]

{ #category : 'Initialization' }
CharacterFieldDefinition >> initializeNamed: aString sized: aSmallInteger applyingAfterDefinition: aTwoArgBlock [

	fieldName := aString.
	fieldSize := aSmallInteger.
	postDefinitionAction := aTwoArgBlock
]

{ #category : 'Printing' }
CharacterFieldDefinition >> printOn: aStream [

	aStream
		print: fieldName;
		space;
		nextPut: $(;
		nextPutAll: 'varchar';
		space;
		print: fieldSize;
		nextPut: $);
		yourself
]
