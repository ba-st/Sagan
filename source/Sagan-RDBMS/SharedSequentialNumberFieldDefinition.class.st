Class {
	#name : 'SharedSequentialNumberFieldDefinition',
	#superclass : 'TableFieldDefinition',
	#instVars : [
		'abstractConceptClass'
	],
	#category : 'Sagan-RDBMS-Fields',
	#package : 'Sagan-RDBMS',
	#tag : 'Fields'
}

{ #category : 'Instance Creation' }
SharedSequentialNumberFieldDefinition class >> forAbstractConcept: anAbstractClass [

	^ self new initializeForAbstractConcept: anAbstractClass
]

{ #category : 'Defining' }
SharedSequentialNumberFieldDefinition >> defineFieldOn: aDatabaseTable using: aDescriptorSystem [

	^ aDescriptorSystem defineSharedSequentialNumberFieldOn: aDatabaseTable forAbstractConcept: abstractConceptClass
]

{ #category : 'Initialization' }
SharedSequentialNumberFieldDefinition >> initializeForAbstractConcept: anAbstractClass [

	abstractConceptClass := anAbstractClass
]

{ #category : 'Printing' }
SharedSequentialNumberFieldDefinition >> printOn: aStream [

	aStream
		nextPutAll: ( 'sharedSequentialNumber for <1p>' expandMacrosWith: abstractConceptClass name );
		space;
		nextPut: $(;
		nextPutAll: 'sequential number';
		nextPut: $);
		yourself
]
