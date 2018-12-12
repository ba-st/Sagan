Class {
	#name : #TimestampFieldDefinition,
	#superclass : #TableFieldDefinition,
	#instVars : [
		'fieldName',
		'postDefinitionAction'
	],
	#category : #'Sagan-RDBMS-Fields'
}

{ #category : #'Instance Creation' }
TimestampFieldDefinition class >> named: aString [

	^ self named: aString applyingAfterDefinition: self makeFieldNotNullable
]

{ #category : #'Instance Creation' }
TimestampFieldDefinition class >> named: aString applyingAfterDefinition: aTwoArgBlock [

	^ self new initializeNamed: aString applyingAfterDefinition: aTwoArgBlock
]

{ #category : #'Instance Creation' }
TimestampFieldDefinition class >> nullableNamed: aString [

	^ self named: aString applyingAfterDefinition: self makeFieldNullable
]

{ #category : #Defining }
TimestampFieldDefinition >> defineFieldOn: aDatabaseTable using: aDescriptorSystem [

	| field |

	field := aDescriptorSystem defineTimestampFieldOn: aDatabaseTable named: fieldName.
	postDefinitionAction value: field value: aDescriptorSystem.
	^ field
]

{ #category : #Initialization }
TimestampFieldDefinition >> initializeNamed: aString applyingAfterDefinition: aTwoArgBlock [

	fieldName := aString.
	postDefinitionAction := aTwoArgBlock
]

{ #category : #Printing }
TimestampFieldDefinition >> printOn: aStream [

	aStream
		print: fieldName;
		space;
		nextPut: $(;
		nextPutAll: 'timestamp';
		nextPut: $);
		yourself
]
