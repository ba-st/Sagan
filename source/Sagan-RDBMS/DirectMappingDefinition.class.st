Class {
	#name : #DirectMappingDefinition,
	#superclass : #MappingDefinition,
	#instVars : [
		'attributeName',
		'fieldName',
		'conversionDefinition',
		'tableName',
		'postDefinitionAction'
	],
	#category : #'Sagan-RDBMS-Mappings'
}

{ #category : #'Conversion Definitions' }
DirectMappingDefinition class >> booleanToIntegerConversionDefinition [

	^ PluggableMappingConversionDefinition
		named: 'booleanToInteger'
		convertingFromDatabaseToSmalltalkUsing: [ :anInteger | anInteger > 0 ]
		fromSmalltalkToDatabaseUsing: [ :aBoolean | aBoolean ]
]

{ #category : #'Instance Creation' }
DirectMappingDefinition class >> fromAttributeNamed: anAttributeName toFieldNamed: aFieldName onTableNamed: aTableName [

	^ self
		fromAttributeNamed: anAttributeName
		toFieldNamed: aFieldName
		onTableNamed: aTableName
		conversionDefinedBy: self nullConversionDefinition
]

{ #category : #'Instance Creation' }
DirectMappingDefinition class >> fromAttributeNamed: anAttributeName toFieldNamed: aFieldName onTableNamed: aTableName conversionDefinedBy: aConversionDefinition [

	^ self
		fromAttributeNamed: anAttributeName
		toFieldNamed: aFieldName
		onTableNamed: aTableName
		conversionDefinedBy: aConversionDefinition
		applyingAfterDefinition: self nullAction
]

{ #category : #'Instance Creation' }
DirectMappingDefinition class >> fromAttributeNamed: anAttributeName toFieldNamed: aFieldName onTableNamed: aTableName conversionDefinedBy: aConversionDefinition applyingAfterDefinition: aTwoArgBlock [

	^ self new
		initializeFromAttributeNamed: anAttributeName
		toFieldNamed: aFieldName
		onTableNamed: aTableName asString
		conversionDefinedBy: aConversionDefinition
		applyingAfterDefinition: aTwoArgBlock
]

{ #category : #'Instance Creation' }
DirectMappingDefinition class >> fromBooleanAttributeNamed: anAttributeName toFieldNamed: aFieldName onTableNamed: aTableName [

	^ self
		fromAttributeNamed: anAttributeName
		toFieldNamed: aFieldName
		onTableNamed: aTableName
		conversionDefinedBy: self booleanToIntegerConversionDefinition
]

{ #category : #'Instance Creation' }
DirectMappingDefinition class >> fromPseudoAttributeNamed: anAttributeName toFieldNamed: aFieldName onTableNamed: aTableName [

	^ self
		fromPseudoAttributeNamed: anAttributeName
		toFieldNamed: aFieldName
		onTableNamed: aTableName
		conversionDefinedBy: self nullConversionDefinition
]

{ #category : #'Instance Creation' }
DirectMappingDefinition class >> fromPseudoAttributeNamed: anAttributeName toFieldNamed: aFieldName onTableNamed: aTableName conversionDefinedBy: aConversionDefinition [

	^ self
		fromAttributeNamed: anAttributeName
		toFieldNamed: aFieldName
		onTableNamed: aTableName
		conversionDefinedBy: aConversionDefinition
		applyingAfterDefinition: self makeMappingForPseudoVariable
]

{ #category : #'Instance Creation' }
DirectMappingDefinition class >> fromReadOnlyAttributeNamed: anAttributeName toFieldNamed: aFieldName onTableNamed: aTableName [

	^ self
		fromAttributeNamed: anAttributeName
		toFieldNamed: aFieldName
		onTableNamed: aTableName
		conversionDefinedBy: self nullConversionDefinition
		applyingAfterDefinition: self makeMappingReadOnly
]

{ #category : #'Instance Creation' }
DirectMappingDefinition class >> fromSymbolAttributeNamed: anAttributeName toFieldNamed: aFieldName onTableNamed: aTableName [

	^ self
		fromAttributeNamed: anAttributeName
		toFieldNamed: aFieldName
		onTableNamed: aTableName
		conversionDefinedBy: self symbolToStringConversionDefinition
]

{ #category : #'Conversion Definitions' }
DirectMappingDefinition class >> nullConversionDefinition [

	^ NullMappingConversionDefinition new
]

{ #category : #'Conversion Definitions' }
DirectMappingDefinition class >> symbolToStringConversionDefinition [

	^ PluggableMappingConversionDefinition
		named: 'symbolToString'
		convertingFromDatabaseToSmalltalkUsing: [ :aString | aString asSymbol ]
		fromSmalltalkToDatabaseUsing: [ :aSymbol | aSymbol asString ]
]

{ #category : #Defining }
DirectMappingDefinition >> defineMappingOn: aDescriptor using: aDescriptorSystem [

	| mapping |

	mapping := aDescriptorSystem
		defineDirectMappingOn: aDescriptor
		fromAttributeNamed: attributeName
		toFieldNamed: fieldName
		onTableNamed: tableName
		conversionDefinedBy: conversionDefinition.
	postDefinitionAction value: mapping value: aDescriptorSystem.
	^ mapping
]

{ #category : #Initialization }
DirectMappingDefinition >> initializeFromAttributeNamed: anAttributeName
	toFieldNamed: aFieldName
	onTableNamed: aTableName
	conversionDefinedBy: aConversionDefinition
	applyingAfterDefinition: aTwoArgBlock [


	attributeName := anAttributeName.
	fieldName := aFieldName.
	tableName := aTableName.
	conversionDefinition := aConversionDefinition.
	postDefinitionAction := aTwoArgBlock
]

{ #category : #Printing }
DirectMappingDefinition >> printOn: aStream [

	aStream
		print: attributeName;
		nextPutAll: ' -> ';
		print: fieldName;
		space;
		nextPut: $(;
		print: tableName;
		nextPut: $);
		space;
		nextPutAll: '(direct mapping)';
		yourself
]
