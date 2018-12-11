Class {
	#name : #ManyToManyAttributeMappingDefinition,
	#superclass : #MappingDefinition,
	#instVars : [
		'attributeName',
		'translationDefinitions',
		'postDefinitionAction'
	],
	#category : #'Sagan-RDBMS-Mappings'
}

{ #category : #'Instance Creation' }
ManyToManyAttributeMappingDefinition class >> forAttributeNamed: anAttributeName translatingFieldsUsing: aTableFieldTranslationDefinition [

	^ self
		forAttributeNamed: anAttributeName
		translatingFieldsUsingAll: ( Array with: aTableFieldTranslationDefinition )
]

{ #category : #'Instance Creation' }
ManyToManyAttributeMappingDefinition class >> forAttributeNamed: anAttributeName translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection [

	^ self
		forAttributeNamed: anAttributeName
		translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection
		applyingAfterDefinition: self nullAction
]

{ #category : #'Instance Creation' }
ManyToManyAttributeMappingDefinition class >> forAttributeNamed: anAttributeName translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection applyingAfterDefinition: aTwoArgBlock [

	^ self new
		initializeForAttributeNamed: anAttributeName
		translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection
		applyingAfterDefinition: aTwoArgBlock
]

{ #category : #Defining }
ManyToManyAttributeMappingDefinition >> defineMappingOn: aDescriptor using: aDescriptorSystem [

	| mapping |

	mapping := aDescriptorSystem
		defineManyToManyMappingOn: aDescriptor
		forAttributeNamed: attributeName
		translatingFieldsUsingAll: translationDefinitions.
	postDefinitionAction value: mapping value: aDescriptorSystem.
	^ mapping
]

{ #category : #Initialization }
ManyToManyAttributeMappingDefinition >> initializeForAttributeNamed: anAttributeName
	translatingFieldsUsingAll: aTableFieldTranslationDefinitionCollection
	applyingAfterDefinition: aTwoArgBlock [


	attributeName := anAttributeName.
	translationDefinitions := aTableFieldTranslationDefinitionCollection.
	postDefinitionAction := aTwoArgBlock
]

{ #category : #Printing }
ManyToManyAttributeMappingDefinition >> printOn: aStream [

	aStream
		print: attributeName;
		space;
		nextPutAll: '(many to many mapping)';
		yourself
]
