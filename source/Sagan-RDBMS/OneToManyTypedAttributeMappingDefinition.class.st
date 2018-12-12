Class {
	#name : #OneToManyTypedAttributeMappingDefinition,
	#superclass : #MappingDefinition,
	#instVars : [
		'attributeName',
		'translationDefinitions',
		'postDefinitionAction'
	],
	#category : #'Sagan-RDBMS-Mappings'
}

{ #category : #'Instance Creation' }
OneToManyTypedAttributeMappingDefinition class >> exclusiveForAttributeNamed: anAttributeName
	translatingFieldsUsing: aTableFieldTranslationDefinition [


	^ self
		exclusiveForAttributeNamed: anAttributeName
		translatingFieldsUsingAll: ( Array with: aTableFieldTranslationDefinition )
]

{ #category : #'Instance Creation' }
OneToManyTypedAttributeMappingDefinition class >> exclusiveForAttributeNamed: anAttributeName
	translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection [


	^ self
		forAttributeNamed: anAttributeName
		translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection
		applyingAfterDefinition: self makeMappingExclusive
]

{ #category : #'Instance Creation' }
OneToManyTypedAttributeMappingDefinition class >> exclusiveForAttributeNamed: anAttributeName
	withPositionAt: aPositionFieldName
	on: aTableName
	translatingFieldsUsing: aTableFieldTranslationDefinitionCollection [


	^ self
		forAttributeNamed: anAttributeName
		translatingFieldsUsingAll: ( Array with: aTableFieldTranslationDefinitionCollection )
		applyingAfterDefinition: [ :mapping :system | 
			self makeMappingExclusive value: mapping value: system.
			self make: mapping beOrderedBy: aPositionFieldName in: aTableName
			]
]

{ #category : #'Instance Creation' }
OneToManyTypedAttributeMappingDefinition class >> exclusiveForNonProxyAttributeNamed: anAttributeName
	translatingFieldsUsing: aTableFieldTranslationDefinition [


	^ self
		exclusiveForNonProxyAttributeNamed: anAttributeName
		translatingFieldsUsingAll: ( Array with: aTableFieldTranslationDefinition )
]

{ #category : #'Instance Creation' }
OneToManyTypedAttributeMappingDefinition class >> exclusiveForNonProxyAttributeNamed: anAttributeName
	translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection [


	^ self
		forAttributeNamed: anAttributeName
		translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection
		applyingAfterDefinition: [ :mapping :system | 
			self makeMappingExclusive value: mapping value: system.
			self makeMappingToNotProxy value: mapping value: system
			]
]

{ #category : #'Instance Creation' }
OneToManyTypedAttributeMappingDefinition class >> exclusiveForNonProxyAttributeNamed: anAttributeName
	withPositionAt: aPositionFieldName
	on: aTableName
	translatingFieldsUsing: aTableFieldTranslationDefinition [


	^ self
		exclusiveForNonProxyAttributeNamed: anAttributeName
		withPositionAt: aPositionFieldName
		on: aTableName
		translatingFieldsUsingAll: ( Array with: aTableFieldTranslationDefinition )
]

{ #category : #'Instance Creation' }
OneToManyTypedAttributeMappingDefinition class >> exclusiveForNonProxyAttributeNamed: anAttributeName
	withPositionAt: aPositionFieldName
	on: aTableName
	translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection [


	^ self
		forAttributeNamed: anAttributeName
		translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection
		applyingAfterDefinition: [ :mapping :system | 
			self makeMappingExclusive value: mapping value: system.
			self makeMappingToNotProxy value: mapping value: system.
			self make: mapping beOrderedBy: aPositionFieldName in: aTableName
			]
]

{ #category : #'Instance Creation' }
OneToManyTypedAttributeMappingDefinition class >> forAttributeNamed: anAttributeName translatingFieldsUsing: aTableFieldTranslationDefinition [

	^ self
		forAttributeNamed: anAttributeName
		translatingFieldsUsingAll: ( Array with: aTableFieldTranslationDefinition )
]

{ #category : #'Instance Creation' }
OneToManyTypedAttributeMappingDefinition class >> forAttributeNamed: anAttributeName translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection [

	^ self
		forAttributeNamed: anAttributeName
		translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection
		applyingAfterDefinition: self nullAction
]

{ #category : #'Instance Creation' }
OneToManyTypedAttributeMappingDefinition class >> forAttributeNamed: anAttributeName translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection applyingAfterDefinition: aTwoArgBlock [

	^ self new
		initializeForAttributeNamed: anAttributeName
		translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection
		applyingAfterDefinition: aTwoArgBlock
]

{ #category : #'Instance Creation' }
OneToManyTypedAttributeMappingDefinition class >> make: mapping beOrderedBy: aPositionFieldName in: aTableName [

	^ mapping
		writeTheOrderField;
		orderBy: [ :each | ( each getTable: aTableName ) getField: aPositionFieldName ]
]

{ #category : #Defining }
OneToManyTypedAttributeMappingDefinition >> defineMappingOn: aDescriptor using: aDescriptorSystem [

	| mapping |

	mapping := aDescriptorSystem
		defineOneToManyMappingOn: aDescriptor
		forAttributeNamed: attributeName
		translatingFieldsUsingAll: translationDefinitions.
	postDefinitionAction value: mapping value: aDescriptorSystem.
	^ mapping
]

{ #category : #Initialization }
OneToManyTypedAttributeMappingDefinition >> initializeForAttributeNamed: anAttributeName
	translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection
	applyingAfterDefinition: aTwoArgBlock [


	attributeName := anAttributeName.
	translationDefinitions := aTableFieldTranslationDefinitionCollection.
	postDefinitionAction := aTwoArgBlock
]

{ #category : #Printing }
OneToManyTypedAttributeMappingDefinition >> printOn: aStream [

	aStream
		print: attributeName;
		space;
		nextPutAll: '(one to many mapping)';
		yourself
]
