Class {
	#name : #DecimalFieldDefinition,
	#superclass : #TableFieldDefinition,
	#instVars : [
		'fieldName',
		'precision',
		'scale',
		'postDefinitionAction'
	],
	#category : #'Sagan-RDBMS-Fields'
}

{ #category : #'Instance Creation' }
DecimalFieldDefinition class >> named: aString [

	^ self named: aString withPrecision: 22 andScale: 8
]

{ #category : #'Instance Creation' }
DecimalFieldDefinition class >> named: aString withPrecision: aPrecisionNumber andScale: aScaleNumber [

	^ self
		named: aString
		withPrecision: aPrecisionNumber
		andScale: aScaleNumber
		applyingAfterDefinition: self makeFieldNotNullable
]

{ #category : #'Instance Creation' }
DecimalFieldDefinition class >> named: aString withPrecision: aPrecisionNumber andScale: aScaleNumber applyingAfterDefinition: aTwoArgBlock [

	^ self new
		initializeNamed: aString
		withPrecision: aPrecisionNumber
		andScale: aScaleNumber
		applyingAfterDefinition: aTwoArgBlock
]

{ #category : #'Instance Creation' }
DecimalFieldDefinition class >> nullableNamed: aString [

	^ self nullableNamed: aString withPrecision: 22 andScale: 8
]

{ #category : #'Instance Creation' }
DecimalFieldDefinition class >> nullableNamed: aString withPrecision: aPrecisionNumber andScale: aScaleNumber [

	^ self
		named: aString
		withPrecision: aPrecisionNumber
		andScale: aScaleNumber
		applyingAfterDefinition: self makeFieldNullable
]

{ #category : #Defining }
DecimalFieldDefinition >> defineFieldOn: aDatabaseTable using: aDescriptorSystem [

	| field |

	field := aDescriptorSystem
		defineDecimalFieldOn: aDatabaseTable
		named: fieldName
		withPrecision: precision
		andScale: scale.
	postDefinitionAction value: field value: aDescriptorSystem.
	^ field
]

{ #category : #Initialization }
DecimalFieldDefinition >> initializeNamed: aString withPrecision: aPrecisionNumber andScale: aScaleNumber applyingAfterDefinition: aTwoArgBlock [

	fieldName := aString.
	precision := aPrecisionNumber.
	scale := aScaleNumber.
	postDefinitionAction := aTwoArgBlock
]

{ #category : #Printing }
DecimalFieldDefinition >> printOn: aStream [

	aStream
		print: fieldName;
		space;
		nextPut: $(;
		nextPutAll: 'decimal p: ';
		print: precision;
		nextPutAll: ' s: ';
		print: scale;
		nextPut: $);
		yourself
]
