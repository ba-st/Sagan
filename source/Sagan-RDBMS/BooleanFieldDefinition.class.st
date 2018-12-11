Class {
	#name : #BooleanFieldDefinition,
	#superclass : #TableFieldDefinition,
	#instVars : [
		'fieldName',
		'postDefinitionAction'
	],
	#category : #'Sagan-RDBMS-Fields'
}

{ #category : #'Instance Creation' }
BooleanFieldDefinition class >> named: aString [

	^ self named: aString applyingAfterDefinition: self makeFieldNotNullable
]

{ #category : #'Instance Creation' }
BooleanFieldDefinition class >> named: aString applyingAfterDefinition: aTwoArgBlock [

	^ self new initializeNamed: aString applyingAfterDefinition: aTwoArgBlock
]

{ #category : #'Instance Creation' }
BooleanFieldDefinition class >> nullableNamed: aString [

	^ self named: aString applyingAfterDefinition: self makeFieldNullable
]

{ #category : #Defining }
BooleanFieldDefinition >> defineFieldOn: aDatabaseTable using: aDescriptorSystem [

	| field |

	field := aDescriptorSystem defineBooleanFieldOn: aDatabaseTable named: fieldName.
	postDefinitionAction value: field value: aDescriptorSystem.
	^ field
]

{ #category : #Initialization }
BooleanFieldDefinition >> initializeNamed: aString applyingAfterDefinition: aTwoArgBlock [

	fieldName := aString.
	postDefinitionAction := aTwoArgBlock
]

{ #category : #Printing }
BooleanFieldDefinition >> printOn: aStream [

	aStream
		print: fieldName;
		space;
		nextPut: $(;
		nextPutAll: 'boolean';
		nextPut: $);
		yourself
]
