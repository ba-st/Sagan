Class {
	#name : #OneToOneMappingWithTranslationDefinition,
	#superclass : #MappingDefinition,
	#instVars : [
		'basicDefinition',
		'postDefinitionAction',
		'translationDefinitions'
	],
	#category : #'Sagan-RDBMS-Mappings'
}

{ #category : #'Instance Creation' }
OneToOneMappingWithTranslationDefinition class >> exclusiveForAttributeNamed: anAttributeName
	translatingFieldsUsing: aTableFieldTranslationDefinition [


	^ self
		forAttributeNamed: anAttributeName
		translatingFieldsUsingAll: ( Array with: aTableFieldTranslationDefinition )
		applyingAfterDefinition: self makeMappingExclusive
]

{ #category : #'Instance Creation' }
OneToOneMappingWithTranslationDefinition class >> exclusiveForAttributeNamed: anAttributeName
	translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection [


	^ self
		forAttributeNamed: anAttributeName
		translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection
		applyingAfterDefinition: self makeMappingExclusive
]

{ #category : #'Instance Creation' }
OneToOneMappingWithTranslationDefinition class >> forAttributeNamed: anAttributeName translatingFieldsUsing: aTableFieldTranslationDefinition [

	^ self
		forAttributeNamed: anAttributeName
		translatingFieldsUsingAll: ( Array with: aTableFieldTranslationDefinition )
]

{ #category : #'Instance Creation' }
OneToOneMappingWithTranslationDefinition class >> forAttributeNamed: anAttributeName translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection [

	^ self
		forAttributeNamed: anAttributeName
		translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection
		applyingAfterDefinition: self nullAction
]

{ #category : #'Instance Creation' }
OneToOneMappingWithTranslationDefinition class >> forAttributeNamed: anAttributeName translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection applyingAfterDefinition: aTwoArgBlock [ 
	^self new
	initializeForAttributeNamed: anAttributeName
	translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection
	applyingAfterDefinition: aTwoArgBlock
]

{ #category : #'Instance Creation' }
OneToOneMappingWithTranslationDefinition class >> forPseudoAttributeNamed: anAttributeName ofType: aModelClass translatingFieldsUsing: aTableFieldTranslationDefinition [

	^ self
		forPseudoAttributeNamed: anAttributeName
		ofType: aModelClass
		translatingFieldsUsingAll: ( Array with: aTableFieldTranslationDefinition )
]

{ #category : #'Instance Creation' }
OneToOneMappingWithTranslationDefinition class >> forPseudoAttributeNamed: anAttributeName ofType: aModelClass translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection [

	^ self
		forAttributeNamed: anAttributeName
		translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection
		applyingAfterDefinition: [ :mapping :system | 
			mapping
				referenceClass: aModelClass;
				beForPseudoVariable
			]
]

{ #category : #'Instance Creation' }
OneToOneMappingWithTranslationDefinition class >> forReadOnlyAttributeNamed: anAttributeName
	translatingFieldsUsing: aTableFieldTranslationDefinition [


	^ self
		forAttributeNamed: anAttributeName
		translatingFieldsUsingAll: ( Array with: aTableFieldTranslationDefinition )
		applyingAfterDefinition: self makeMappingReadOnly
]

{ #category : #'Instance Creation' }
OneToOneMappingWithTranslationDefinition class >> forReadOnlyAttributeNamed: anAttributeName
	translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection [


	^ self
		forAttributeNamed: anAttributeName
		translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection
		applyingAfterDefinition: self makeMappingReadOnly
]

{ #category : #'as yet unclassified' }
OneToOneMappingWithTranslationDefinition class >> forReadOnlyNonProxyAttributeNamed: anAttributeName
	translatingFieldsUsing: aTableFieldTranslationDefinition [

	^self
		forAttributeNamed: anAttributeName
		translatingFieldsUsingAll: (Array with: aTableFieldTranslationDefinition)
		applyingAfterDefinition: [:mapping :system |
			self makeMappingReadOnly value: mapping value: system.
			self makeMappingToNotProxy value: mapping value: system]
]

{ #category : #Defining }
OneToOneMappingWithTranslationDefinition >> defineMappingOn: aDescriptor using: aDescriptorSystem [

	| mapping |

	mapping := aDescriptorSystem
		defineOneToOneMappingWithTranslationOn: aDescriptor
		basedOn: basicDefinition
		translatingFieldsUsingAll: translationDefinitions.
	postDefinitionAction value: mapping value: aDescriptorSystem.
	^ mapping
]

{ #category : #Initialization }
OneToOneMappingWithTranslationDefinition >> initializeForAttributeNamed: anAttributeName
	translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection
	applyingAfterDefinition: aTwoArgBlock [


	basicDefinition := OneToOneMappingDefinition forAttributeNamed: anAttributeName.
	translationDefinitions := aTableFieldTranslationDefinitionCollection.
	postDefinitionAction := aTwoArgBlock
]

{ #category : #Printing }
OneToOneMappingWithTranslationDefinition >> printOn: aStream [

	aStream
		print: basicDefinition;
		space;
		nextPutAll: '(with explicit translation)';
		yourself
]
