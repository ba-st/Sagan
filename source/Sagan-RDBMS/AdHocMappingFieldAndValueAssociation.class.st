Class {
	#name : #AdHocMappingFieldAndValueAssociation,
	#superclass : #Object,
	#instVars : [
		'accessorMessage',
		'fieldName',
		'tableName',
		'fromDatabaseToSmalltalkConversion',
		'fromSmalltalkToDatabaseConversion'
	],
	#category : #'Sagan-RDBMS-Mappings'
}

{ #category : #'Instance Creation' }
AdHocMappingFieldAndValueAssociation class >> forDecimalRelating: anAccessorMessage to: aFieldName on: aTableName [

	^ self
		relating: anAccessorMessage
		to: aFieldName
		on: aTableName
		convertingFromDatabaseToSmalltalkUsing: [ :anScaledDecimal | anScaledDecimal ]
		fromSmalltalkToDatabaseUsing: [ :aNumber | aNumber asScaledDecimal ]
]

{ #category : #'Instance Creation' }
AdHocMappingFieldAndValueAssociation class >> relating: anAccessorMessage to: aFieldName on: aTableName [

	^ self
		relating: anAccessorMessage
		to: aFieldName
		on: aTableName
		convertingFromDatabaseToSmalltalkUsing: [ :anObject | anObject ]
		fromSmalltalkToDatabaseUsing: [ :anObject | anObject ]
]

{ #category : #'Instance Creation' }
AdHocMappingFieldAndValueAssociation class >> relating: anAccessorMessage
	to: aFieldName
	on: aTableName
	convertingFromDatabaseToSmalltalkUsing: fromDatabaseToSmalltalkBlock
	fromSmalltalkToDatabaseUsing: fromSmalltalkToDatabaseBlock [


	^ self new
		initializeRelating: anAccessorMessage
		to: aFieldName
		on: aTableName asString
		convertingFromDatabaseToSmalltalkUsing: fromDatabaseToSmalltalkBlock
		fromSmalltalkToDatabaseUsing: fromSmalltalkToDatabaseBlock
]

{ #category : #Accessing }
AdHocMappingFieldAndValueAssociation >> accessorMessage [

	^ accessorMessage
]

{ #category : #Accessing }
AdHocMappingFieldAndValueAssociation >> fieldName [

	^ fieldName
]

{ #category : #Accessing }
AdHocMappingFieldAndValueAssociation >> fromDatabaseToSmalltalkConversion [

	^ fromDatabaseToSmalltalkConversion
]

{ #category : #Accessing }
AdHocMappingFieldAndValueAssociation >> fromSmalltalkToDatabaseConversion [

	^ fromSmalltalkToDatabaseConversion
]

{ #category : #Initialization }
AdHocMappingFieldAndValueAssociation >> initializeRelating: anAccessorMessage
	to: aFieldName
	on: aTableName
	convertingFromDatabaseToSmalltalkUsing: aFromDatabaseToSmalltalkBlock
	fromSmalltalkToDatabaseUsing: aFromSmalltalkToDatabaseBlock [


	accessorMessage := anAccessorMessage.
	fieldName := aFieldName.
	tableName := aTableName.
	fromDatabaseToSmalltalkConversion := aFromDatabaseToSmalltalkBlock.
	fromSmalltalkToDatabaseConversion := aFromSmalltalkToDatabaseBlock
]

{ #category : #Accessing }
AdHocMappingFieldAndValueAssociation >> tableName [

	^ tableName
]
