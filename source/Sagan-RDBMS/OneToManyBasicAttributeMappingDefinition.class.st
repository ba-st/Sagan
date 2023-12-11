Class {
	#name : 'OneToManyBasicAttributeMappingDefinition',
	#superclass : 'MappingDefinition',
	#instVars : [
		'attributeName',
		'resultFieldName',
		'translationDefinitions',
		'tableName',
		'positionFieldName',
		'postDefinitionAction'
	],
	#category : 'Sagan-RDBMS-Mappings',
	#package : 'Sagan-RDBMS',
	#tag : 'Mappings'
}

{ #category : 'Instance Creation' }
OneToManyBasicAttributeMappingDefinition class >> forAttributeNamed: anAttributeName obtainingValuesFrom: aFieldName andPositionFrom: aPositionFieldName on: aTableName translatingUsing: aTableFieldTranslationDefinition [

	^ self
		forAttributeNamed: anAttributeName
		obtainingValuesFrom: aFieldName
		andPositionFrom: aPositionFieldName
		on: aTableName
		translatingUsingAll: ( Array with: aTableFieldTranslationDefinition )
]

{ #category : 'Instance Creation' }
OneToManyBasicAttributeMappingDefinition class >> forAttributeNamed: anAttributeName obtainingValuesFrom: aFieldName andPositionFrom: aPositionFieldName on: aTableName translatingUsingAll: aTableFieldTranslationDefinitionCollection [

	^ self
		forAttributeNamed: anAttributeName
		obtainingValuesFrom: aFieldName
		andPositionFrom: aPositionFieldName
		on: aTableName
		translatingUsingAll: aTableFieldTranslationDefinitionCollection
		applyingAfterDefinition: self nullAction
]

{ #category : 'Instance Creation' }
OneToManyBasicAttributeMappingDefinition class >> forAttributeNamed: anAttributeName obtainingValuesFrom: aFieldName andPositionFrom: aPositionFieldName on: aTableName translatingUsingAll: aTableFieldTranslationDefinitionCollection applyingAfterDefinition: aOneArgBlock [

	^ self new
		initializeForAttributeNamed: anAttributeName
		obtainingValuesFrom: aFieldName
		andPositionFrom: aPositionFieldName
		on: aTableName asString
		translatingUsingAll: aTableFieldTranslationDefinitionCollection
		applyingAfterDefinition: aOneArgBlock
]

{ #category : 'Defining' }
OneToManyBasicAttributeMappingDefinition >> defineMappingOn: aDescriptor using: aDescriptorSystem [

	| mapping |

	mapping := aDescriptorSystem
		defineOneToManyBasicAttributeMappingOn: aDescriptor
		forAttributeNamed: attributeName
		obtainingValuesFrom: resultFieldName
		andPositionFrom: positionFieldName
		on: tableName
		usingAll: translationDefinitions.
	postDefinitionAction value: mapping value: aDescriptorSystem.
	^ mapping
]

{ #category : 'Initialization' }
OneToManyBasicAttributeMappingDefinition >> initializeForAttributeNamed: anAttributeName
	obtainingValuesFrom: aFieldName
	andPositionFrom: aPositionFieldName
	on: aTableName
	translatingUsingAll: aTableFieldTranslationDefinitionCollection
	applyingAfterDefinition: aTwoArgBlock [


	attributeName := anAttributeName.
	resultFieldName := aFieldName.
	positionFieldName := aPositionFieldName.
	tableName := aTableName.
	translationDefinitions := aTableFieldTranslationDefinitionCollection.
	postDefinitionAction := aTwoArgBlock
]

{ #category : 'Printing' }
OneToManyBasicAttributeMappingDefinition >> printOn: aStream [

	aStream
		print: attributeName;
		space;
		nextPutAll: '(one to many of basic attribute mapping)';
		yourself
]
