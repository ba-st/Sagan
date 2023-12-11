Class {
	#name : 'OneToOneVariableMappingDefinition',
	#superclass : 'MappingDefinition',
	#instVars : [
		'attributeName',
		'sourceFieldName',
		'sourceTableName',
		'targetFieldName',
		'modelClassCollection',
		'postDefinitionAction'
	],
	#category : 'Sagan-RDBMS-Mappings',
	#package : 'Sagan-RDBMS',
	#tag : 'Mappings'
}

{ #category : 'Accessing' }
OneToOneVariableMappingDefinition class >> allConcreteSubclassesOf: anAbstractModelClass [

	^ anAbstractModelClass allSubclasses select: [ :class | class subclasses isEmpty ]
]

{ #category : 'Instance Creation' }
OneToOneVariableMappingDefinition class >> forAttributeNamed: anAttributeName joiningFieldNamed: aSourceFieldName onTableNamed: aSourceTableName toFieldNamed: aTargetFieldName onTableDeterminedByCaseBetweenDescribedForAnyOf: aModelClassCollection [

	^ self
		forAttributeNamed: anAttributeName
		joiningFieldNamed: aSourceFieldName
		onTableNamed: aSourceTableName
		toFieldNamed: aTargetFieldName
		onTableDeterminedByCaseBetweenDescribedForAnyOf: aModelClassCollection
		applyingAfterDefinition: self nullAction
]

{ #category : 'Instance Creation' }
OneToOneVariableMappingDefinition class >> forAttributeNamed: anAttributeName joiningFieldNamed: aSourceFieldName onTableNamed: aSourceTableName toFieldNamed: aTargetFieldName onTableDeterminedByCaseBetweenDescribedForAnyOf: aModelClassCollection applyingAfterDefinition: aTwoArgBlock [

	^ self new
		initializeForAttributeNamed: anAttributeName
		joiningFieldNamed: aSourceFieldName
		onTableNamed: aSourceTableName asString
		toFieldNamed: aTargetFieldName
		onTableDeterminedByCaseBetweenDescribedForAnyOf: aModelClassCollection
		applyingAfterDefinition: aTwoArgBlock
]

{ #category : 'Instance Creation' }
OneToOneVariableMappingDefinition class >> forAttributeNamed: anAttributeName joiningFieldNamed: aSourceFieldName onTableNamed: aSourceTableName toFieldNamed: aTargetFieldName onTableDeterminedByCaseBetweenDescribedForAnySubclassOf: anAbstractModelClass [

	^ self
		forAttributeNamed: anAttributeName
		joiningFieldNamed: aSourceFieldName
		onTableNamed: aSourceTableName
		toFieldNamed: aTargetFieldName
		onTableDeterminedByCaseBetweenDescribedForAnyOf: ( self allConcreteSubclassesOf: anAbstractModelClass )
]

{ #category : 'Instance Creation' }
OneToOneVariableMappingDefinition class >> forReadOnlyAttributeNamed: anAttributeName joiningFieldNamed: aSourceFieldName onTableNamed: aSourceTableName toFieldNamed: aTargetFieldName onTableDescribedFor: aModelClass [

	^ self
		forAttributeNamed: anAttributeName
		joiningFieldNamed: aSourceFieldName
		onTableNamed: aSourceTableName
		toFieldNamed: aTargetFieldName
		onTableDeterminedByCaseBetweenDescribedForAnyOf: ( Array with: aModelClass )
		applyingAfterDefinition: self makeMappingReadOnly
]

{ #category : 'Instance Creation' }
OneToOneVariableMappingDefinition class >> forReadOnlyAttributeNamed: anAttributeName
	joiningFieldNamed: aSourceFieldName
	onTableNamed: aSourceTableName
	toFieldNamed: aTargetFieldName
	onTableDeterminedByCaseBetweenDescribedForAnySubclassOf: anAbstractModelClass [


	^ self
		forAttributeNamed: anAttributeName
		joiningFieldNamed: aSourceFieldName
		onTableNamed: aSourceTableName
		toFieldNamed: aTargetFieldName
		onTableDeterminedByCaseBetweenDescribedForAnyOf: ( self allConcreteSubclassesOf: anAbstractModelClass )
		applyingAfterDefinition: self makeMappingReadOnly
]

{ #category : 'Defining' }
OneToOneVariableMappingDefinition >> defineMappingOn: aDescriptor using: aDescriptorSystem [

	| mapping |

	mapping := aDescriptorSystem
		defineOneToOneVariableMappingOn: aDescriptor
		forAttributeNamed: attributeName
		joiningFieldNamed: sourceFieldName
		onTableNamed: sourceTableName
		toFieldNamed: targetFieldName
		onEachTableDefinedFor: modelClassCollection.
	postDefinitionAction value: mapping value: aDescriptorSystem.
	^ mapping
]

{ #category : 'Initialization' }
OneToOneVariableMappingDefinition >> initializeForAttributeNamed: anAttributeName
	joiningFieldNamed: aSourceFieldName
	onTableNamed: aSourceTableName
	toFieldNamed: aTargetFieldName
	onTableDeterminedByCaseBetweenDescribedForAnyOf: aModelClassCollection
	applyingAfterDefinition: aTwoArgBlock [


	attributeName := anAttributeName.
	sourceFieldName := aSourceFieldName.
	sourceTableName := aSourceTableName.
	targetFieldName := aTargetFieldName.
	modelClassCollection := aModelClassCollection.
	postDefinitionAction := aTwoArgBlock
]

{ #category : 'Printing' }
OneToOneVariableMappingDefinition >> printOn: aStream [

	aStream
		print: attributeName;
		space;
		nextPutAll: '(one to one variable mapping)';
		yourself
]
