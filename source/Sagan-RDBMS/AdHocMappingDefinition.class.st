Class {
	#name : 'AdHocMappingDefinition',
	#superclass : 'MappingDefinition',
	#instVars : [
		'attributeName',
		'messageToPrepareModel',
		'objectToPrepareModel',
		'fieldValueAssociations',
		'postDefinitionAction'
	],
	#category : 'Sagan-RDBMS-Mappings',
	#package : 'Sagan-RDBMS',
	#tag : 'Mappings'
}

{ #category : 'Instance Creation' }
AdHocMappingDefinition class >> forAttributeNamed: anAttributeName sending: aMessage to: anObjectToPrepareModel toMapAssociations: aFieldValueAssociationsCollection [

	^ self
		forAttributeNamed: anAttributeName
		sending: aMessage
		to: anObjectToPrepareModel
		toMapAssociations: aFieldValueAssociationsCollection
		applyingAfterDefinition: self nullAction
]

{ #category : 'Instance Creation' }
AdHocMappingDefinition class >> forAttributeNamed: anAttributeName sending: aMessage to: anObjectToPrepareModel toMapAssociations: aFieldValueAssociationsCollection applyingAfterDefinition: aOneArgBlock [

	^ self new
		initializeForAttributeNamed: anAttributeName
		sending: aMessage
		to: anObjectToPrepareModel
		toMapAssociations: aFieldValueAssociationsCollection
		applyingAfterDefinition: aOneArgBlock
]

{ #category : 'Instance Creation' }
AdHocMappingDefinition class >> forNullableAttributeNamed: anAttributeName
	toMapSingleAssociationTo: aFieldName
	on: aTableName
	convertingFromDatabaseToSmalltalkUsing: dbToStBlock
	fromSmalltalkToDatabaseUsing: stToDbBlock
	consideringNullAs: aNullObject [


	^ self
		forAttributeNamed: anAttributeName
		sending: #value:
		to: [ :nullableObject | nullableObject ]
		toMapAssociations:
			( Array
				with:
					( AdHocMappingFieldAndValueAssociation
						forNullableField: aFieldName
						on: aTableName
						convertingFromDatabaseToSmalltalkUsing: dbToStBlock
						fromSmalltalkToDatabaseUsing: stToDbBlock
						consideringNullAs: aNullObject ) )
]

{ #category : 'Instance Creation' }
AdHocMappingDefinition class >> forProxyAttributeNamed: anAttributeName sending: aMessage to: anObjectToPrepareModel toMapAssociations: aFieldValueAssociationsCollection [

	^ self
		forAttributeNamed: anAttributeName
		sending: aMessage
		to: anObjectToPrepareModel
		toMapAssociations: aFieldValueAssociationsCollection
		applyingAfterDefinition: self makeMappingToUseProxies
]

{ #category : 'Instance Creation' }
AdHocMappingDefinition class >> forReadOnlyAttributeNamed: anAttributeName
	sending: aMessage
	to: anObjectToPrepareModel
	toMapAssociations: aFieldValueAssociationsCollection [


	^ self
		forAttributeNamed: anAttributeName
		sending: aMessage
		to: anObjectToPrepareModel
		toMapAssociations: aFieldValueAssociationsCollection
		applyingAfterDefinition: self makeMappingReadOnly
]

{ #category : 'Accessing' }
AdHocMappingDefinition class >> makeMappingToUseProxies [

	^ [ :mapping :system | mapping shouldProxy: true ]
]

{ #category : 'Defining' }
AdHocMappingDefinition >> defineMappingOn: aDescriptor using: aDescriptorSystem [

	| mapping |

	mapping := aDescriptorSystem
		defineAdHocMappingOn: aDescriptor
		forAttributeNamed: attributeName
		sending: messageToPrepareModel
		to: objectToPrepareModel
		toMapAssociations: fieldValueAssociations.
	self definePseudoAttributesForNotDeclaredFieldsOn: aDescriptor using: aDescriptorSystem.
	postDefinitionAction value: mapping value: aDescriptorSystem.
	^ mapping
]

{ #category : 'Defining' }
AdHocMappingDefinition >> definePseudoAttributesForNotDeclaredFieldsOn: aDescriptor using: aDescriptorSystem [

	fieldValueAssociations copyWithoutFirst
		do: [ :anAssociation | 
			( DirectMappingDefinition
				fromPseudoAttributeNamed: anAssociation accessorMessage
				toFieldNamed: anAssociation fieldName
				onTableNamed: anAssociation tableName ) defineFor: aDescriptor using: aDescriptorSystem
			]
]

{ #category : 'Initialization' }
AdHocMappingDefinition >> initializeForAttributeNamed: anAttributeName
	sending: aMessage
	to: anObjectToPrepareModel
	toMapAssociations: aFieldValueAssociationsCollection
	applyingAfterDefinition: aOneArgBlock [


	attributeName := anAttributeName.
	messageToPrepareModel := aMessage.
	objectToPrepareModel := anObjectToPrepareModel.
	fieldValueAssociations := aFieldValueAssociationsCollection.
	postDefinitionAction := aOneArgBlock
]

{ #category : 'Printing' }
AdHocMappingDefinition >> printOn: aStream [

	aStream
		print: attributeName;
		space;
		nextPutAll: '(ad-hoc mapping)';
		yourself
]
