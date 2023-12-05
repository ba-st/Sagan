Class {
	#name : 'SequentialNumberMappingDefinition',
	#superclass : 'MappingDefinition',
	#instVars : [
		'tableName'
	],
	#category : 'Sagan-RDBMS-Mappings',
	#package : 'Sagan-RDBMS',
	#tag : 'Mappings'
}

{ #category : 'Instance Creation' }
SequentialNumberMappingDefinition class >> onTableNamed: aTableName [

	^ self new initializeOnTableNamed: aTableName asString
]

{ #category : 'Defining' }
SequentialNumberMappingDefinition >> defineMappingOn: aDescriptor using: aDescriptorSystem [

	^ aDescriptorSystem defineSequentialNumberMappingOn: aDescriptor onTableNamed: tableName
]

{ #category : 'Initialization' }
SequentialNumberMappingDefinition >> initializeOnTableNamed: aTableName [

	tableName := aTableName
]

{ #category : 'Printing' }
SequentialNumberMappingDefinition >> printOn: aStream [

	aStream
		print: RDBMSConstants sequentialNumberAttribute;
		nextPutAll: ' -> ';
		print: RDBMSConstants sequentialNumberFieldName;
		space;
		nextPut: $(;
		print: tableName;
		nextPut: $);
		space;
		nextPutAll: '(sequential number mapping)';
		yourself
]
