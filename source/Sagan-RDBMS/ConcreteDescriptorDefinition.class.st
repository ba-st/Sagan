Class {
	#name : #ConcreteDescriptorDefinition,
	#superclass : #DescriptorDefinition,
	#instVars : [
		'tableName',
		'mappingDefinitions',
		'modelClass',
		'postDefinitionAction'
	],
	#category : #'Sagan-RDBMS-Descriptors'
}

{ #category : #'Instance Creation' }
ConcreteDescriptorDefinition class >> for: aModelClass onTableNamed: aTableName mappingsDefinedBy: aMappingDefinitions [

	^ self
		for: aModelClass
		onTableNamed: aTableName
		mappingsDefinedBy: aMappingDefinitions
		applyingAfterDefinition: [ :descriptor :system |  ]
]

{ #category : #'Instance Creation' }
ConcreteDescriptorDefinition class >> for: aModelClass onTableNamed: aTableName mappingsDefinedBy: aMappingDefinitions applyingAfterDefinition: aTwoArgBlock [

	^ self new
		initializeFor: aModelClass
		onTableNamed: aTableName asString
		mappingsDefinedBy: aMappingDefinitions
		applyingAfterDefinition: aTwoArgBlock
]

{ #category : #'Instance Creation' }
ConcreteDescriptorDefinition class >> for: aModelClass onTableNamed: aTableName mappingsDefinedBy: aMappingDefinitions usingFilteredTypeResolverFor: anAbstractClass keyedBy: aFilterTypeKey forFieldNamed: aFieldName [

	^ self
		for: aModelClass
		onTableNamed: aTableName
		mappingsDefinedBy: aMappingDefinitions
		applyingAfterDefinition: [ :descriptor :system | ( system typeResolverFor: anAbstractClass ) register: descriptor keyedBy: aFilterTypeKey field: ( ( system tableNamed: aTableName ) fieldNamed: aFieldName ) ]
]

{ #category : #'Instance Creation' }
ConcreteDescriptorDefinition class >> for: aModelClass onTableNamed: aTableName mappingsDefinedBy: aMappingDefinitions usingHorizontalTypeResolverFor: anAbstractClass [

	^ self
		for: aModelClass
		onTableNamed: aTableName
		mappingsDefinedBy: aMappingDefinitions
		applyingAfterDefinition: [ :descriptor :system | ( system typeResolverFor: anAbstractClass ) register: descriptor abstract: false ]
]

{ #category : #Defining }
ConcreteDescriptorDefinition >> defineDescriptorFor: aDescriptor using: aDescriptorSystem [

	| descriptor |

	descriptor := aDescriptorSystem defineConcreteDescriptorBasedOn: aDescriptor onTableNamed: tableName mappingsDefinedBy: mappingDefinitions.
	postDefinitionAction value: descriptor value: aDescriptorSystem.
	^ descriptor
]

{ #category : #Accessing }
ConcreteDescriptorDefinition >> describedClass [

	^ modelClass
]

{ #category : #Initialization }
ConcreteDescriptorDefinition >> initializeFor: aModelClass onTableNamed: aTableName mappingsDefinedBy: aMappingDefinitions applyingAfterDefinition: aTwoArgBlock [

	modelClass := aModelClass.
	tableName := aTableName.
	mappingDefinitions := aMappingDefinitions.
	postDefinitionAction := aTwoArgBlock
]

{ #category : #Printing }
ConcreteDescriptorDefinition >> printOn: aStream [

	aStream
		nextPutAll: 'Descriptor for concrete class ';
		print: modelClass;
		nextPutAll: ' on ';
		print: tableName;
		nextPut: $:;
		cr.
	mappingDefinitions do: [ :mappingDefinition | aStream print: mappingDefinition ] separatedBy: [ aStream cr ]
]
