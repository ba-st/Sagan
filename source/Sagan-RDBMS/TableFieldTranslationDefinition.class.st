Class {
	#name : 'TableFieldTranslationDefinition',
	#superclass : 'PersistenceConceptDefinition',
	#instVars : [
		'sourceTableName',
		'targetTableName',
		'sourceFieldName',
		'targetFieldName'
	],
	#category : 'Sagan-RDBMS-Fields',
	#package : 'Sagan-RDBMS',
	#tag : 'Fields'
}

{ #category : 'Instance Creation' }
TableFieldTranslationDefinition class >> translatingFieldNamed: aSourceFieldName onTableNamed: aSourceTableName toFieldNamed: aTargetFieldName onTableNamed: aTargetTableName [

	^ self new
		initializeTranslatingFieldNamed: aSourceFieldName
		onTableNamed: aSourceTableName
		toFieldNamed: aTargetFieldName
		onTableNamed: aTargetTableName
]

{ #category : 'Defining' }
TableFieldTranslationDefinition >> defineFor: aJoin using: aDescriptorSystem [

	aDescriptorSystem
		defineTranslationBasedOn: aJoin
		fromFieldNamed: sourceFieldName
		onTableNamed: sourceTableName
		toFieldNamed: targetFieldName
		onTableNamed: targetTableName
]

{ #category : 'Initialization' }
TableFieldTranslationDefinition >> initializeTranslatingFieldNamed: aSourceFieldName onTableNamed: aSourceTableName toFieldNamed: aTargetFieldName onTableNamed: aTargetTableName [

	sourceFieldName := aSourceFieldName.
	sourceTableName := aSourceTableName.
	targetFieldName := aTargetFieldName.
	targetTableName := aTargetTableName
]

{ #category : 'Printing' }
TableFieldTranslationDefinition >> printOn: aStream [

	aStream
		nextPutAll: sourceTableName;
		nextPut: $.;
		nextPutAll: sourceFieldName;
		nextPutAll: ' -> ';
		nextPutAll: targetTableName;
		nextPut: $.;
		nextPutAll: targetFieldName
]
