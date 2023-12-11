Class {
	#name : 'DateFieldDefinition',
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
DateFieldDefinition class >> named: aString [

	^ self named: aString applyingAfterDefinition: self makeFieldNotNullable
]

{ #category : 'Instance Creation' }
DateFieldDefinition class >> named: aString applyingAfterDefinition: aTwoArgBlock [

	^ self new initializeNamed: aString applyingAfterDefinition: aTwoArgBlock
]

{ #category : 'Instance Creation' }
DateFieldDefinition class >> nullableNamed: aString [

	^ self named: aString applyingAfterDefinition: self makeFieldNullable
]

{ #category : 'Defining' }
DateFieldDefinition >> defineFieldOn: aDatabaseTable using: aDescriptorSystem [

	| field |

	field := aDescriptorSystem defineDateFieldOn: aDatabaseTable named: fieldName.
	postDefinitionAction value: field value: aDescriptorSystem.
	^ field
]

{ #category : 'Initialization' }
DateFieldDefinition >> initializeNamed: aString applyingAfterDefinition: aTwoArgBlock [

	fieldName := aString.
	postDefinitionAction := aTwoArgBlock
]

{ #category : 'Printing' }
DateFieldDefinition >> printOn: aStream [

	aStream
		print: fieldName;
		space;
		nextPut: $(;
		nextPutAll: 'date';
		nextPut: $);
		yourself
]
