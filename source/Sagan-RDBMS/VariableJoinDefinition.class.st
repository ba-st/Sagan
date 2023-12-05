Class {
	#name : 'VariableJoinDefinition',
	#superclass : 'JoinDefinition',
	#instVars : [
		'sourceFieldName',
		'sourceTableName',
		'targetFieldName',
		'modelClassCollection'
	],
	#category : 'Sagan-RDBMS-Mappings',
	#package : 'Sagan-RDBMS',
	#tag : 'Mappings'
}

{ #category : 'Instance Creation' }
VariableJoinDefinition class >> fromFieldNamed: aSourceFieldName onTableNamed: aSourceTableName toFieldNamed: aTargetFieldName onEachTableDefinedFor: aModelClassCollection [

	^ self new
		initializeFromFieldNamed: aSourceFieldName
		onTableNamed: aSourceTableName asString
		toFieldNamed: aTargetFieldName
		onEachTableDefinedFor: aModelClassCollection
]

{ #category : 'Defining' }
VariableJoinDefinition >> defineJoinFor: aJoin using: aDescriptorSystem [

	^ aDescriptorSystem
		defineVariableJoinBasedOn: aJoin
		fromFieldNamed: sourceFieldName
		onTableNamed: sourceTableName
		toFieldNamed: targetFieldName
		onEachTableDefinedFor: modelClassCollection
]

{ #category : 'Initialization' }
VariableJoinDefinition >> initializeFromFieldNamed: aSourceFieldName
	onTableNamed: aSourceTableName
	toFieldNamed: aTargetFieldName
	onEachTableDefinedFor: aModelClassCollection [

	sourceFieldName := aSourceFieldName.
	sourceTableName := aSourceTableName.
	targetFieldName := aTargetFieldName.
	modelClassCollection := aModelClassCollection
]
