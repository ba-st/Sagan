Class {
	#name : #SequentialNumberFieldDefinition,
	#superclass : #TableFieldDefinition,
	#category : #'Sagan-RDBMS-Fields'
}

{ #category : #Defining }
SequentialNumberFieldDefinition >> defineFieldOn: aDatabaseTable using: aDescriptorSystem [

	^ aDescriptorSystem defineSequentialNumberFieldOn: aDatabaseTable
]

{ #category : #Printing }
SequentialNumberFieldDefinition >> printOn: aStream [

	aStream
		print: RDBMSConstants sequentialNumberAttribute;
		space;
		nextPut: $(;
		nextPutAll: 'sequential number';
		nextPut: $);
		yourself
]
