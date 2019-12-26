Class {
	#name : #ConfigurableDescriptorSystem,
	#superclass : #DescriptorSystem,
	#instVars : [
		'tableDefinitions',
		'descriptorDefinitions',
		'classModelDefinitions',
		'typeResolverDefinitions',
		'tablesInCreationOrder'
	],
	#category : #'Sagan-RDBMS-Core'
}

{ #category : #configuring }
ConfigurableDescriptorSystem >> addClassModelDefinedBy: aClassModelDefinition [

	classModelDefinitions add: aClassModelDefinition.
	allClasses := OrderedCollection new
]

{ #category : #configuring }
ConfigurableDescriptorSystem >> addDescriptorDefinedBy: aDescriptorDefinition [

	descriptorDefinitions add: aDescriptorDefinition.
	descriptors := Dictionary new
]

{ #category : #configuring }
ConfigurableDescriptorSystem >> addTableDefinedBy: aTableDefinition [

	tableDefinitions add: aTableDefinition.
	tables := Dictionary new.
	tablesInCreationOrder := nil
]

{ #category : #configuring }
ConfigurableDescriptorSystem >> addTypeResolverDefinedBy: aTypeResolverDefinition [

	typeResolverDefinitions add: aTypeResolverDefinition.
	typeResolvers := Dictionary new
]

{ #category : #private }
ConfigurableDescriptorSystem >> allForeignKeyFieldDefinitions [

	^ tableDefinitions
		inject: OrderedCollection new
		into: [ :foreignKeyFieldDefinitions :tableDefinition | 
			foreignKeyFieldDefinitions
				addAll: ( tableDefinition fieldDefinitions select: [ :fieldDefinition | fieldDefinition isForForeignKeys ] );
				yourself
			]
]

{ #category : #private }
ConfigurableDescriptorSystem >> allTableNames [

	^ tableDefinitions collect: [ :definition | definition tableName ]
]

{ #category : #accessing }
ConfigurableDescriptorSystem >> allTables [

	( tablesInCreationOrder isNil or: [ tablesInCreationOrder isEmpty ] )
		ifTrue: [ 
			super allTables.
			tablesInCreationOrder := tableDefinitions collect: [ :aTableDefinition | self tableNamed: aTableDefinition tableName ]
			].
	^ tablesInCreationOrder
]

{ #category : #private }
ConfigurableDescriptorSystem >> assertForeignKeyFieldDoNotPointToImaginaryTables [

	self allForeignKeyFieldDefinitions
		do: [ :foreignKeyFieldDefinition | 
			| foreignTable |

			foreignTable := self tableNamed: foreignKeyFieldDefinition foreignTableName.
			self
				tableDefinitionFor: foreignTable
				ifFound: [ :tableDefinition | 
					( tableDefinition isA: ImaginaryTableDefinition )
						ifTrue: [ self error: 'Cannot define a foreign key against an imaginary table' ]
					]
				ifNotFound: [ self signalDefinitionMissingFor: foreignTable ]
			]
]

{ #category : #private }
ConfigurableDescriptorSystem >> assertRealTablesHaveAtLeastOneFieldDeclaredAsPrimaryKey [

	tables
		reject: [ :table | table isImaginary ]
		thenDo: [ :realTable | 
			realTable primaryKeyFields isEmpty
				ifTrue: [ self error: ( 'Table <1> don''t have any field declared as primary key' expandMacrosWith: realTable ) ]
			]
]

{ #category : #private }
ConfigurableDescriptorSystem >> classModelDefinitionFor: aClassModel ifFound: aOneArgBlock ifNotFound: aZeroArgBlock [

	^ classModelDefinitions detect: [ :definition | definition isFor: aClassModel ] ifFound: aOneArgBlock ifNone: aZeroArgBlock
]

{ #category : #private }
ConfigurableDescriptorSystem >> constructAllClasses [

	classModelDefinitions do: [ :definition | allClasses add: definition modelClass ].
	^ allClasses
]

{ #category : #private }
ConfigurableDescriptorSystem >> constructAllTables [

	self allTableNames do: [ :tableName | self tableNamed: tableName ].
	self assertRealTablesHaveAtLeastOneFieldDeclaredAsPrimaryKey.
	self assertForeignKeyFieldDoNotPointToImaginaryTables.
	^ tables
]

{ #category : #'defining descriptors' }
ConfigurableDescriptorSystem >> defineAbstractDescriptorUsingFilteredTypeResolverBasedOn: aDescriptor onTableNamed: aTableName mappingsDefinedBy: mappingDefinitions [

	aDescriptor table: ( self tableNamed: aTableName ).
	mappingDefinitions do: [ :mappingDefinition | mappingDefinition defineFor: aDescriptor using: self ].
	^ aDescriptor
]

{ #category : #'defining descriptors' }
ConfigurableDescriptorSystem >> defineAbstractDescriptorUsingHorizontalTypeResolverBasedOn: aDescriptor [

	^ aDescriptor
]

{ #category : #'defining mappings' }
ConfigurableDescriptorSystem >> defineAdHocMappingOn: aDescriptor forAttributeNamed: anAttributeName sending: aMessageToPrepareModel to: anObjectToPrepareModel toMapAssociations: aFieldValueAssociationsCollection [

	| mapping fields |

	fields := aFieldValueAssociationsCollection
		collect:
			[ :aFieldValueAssociation | ( self tableNamed: aFieldValueAssociation tableName ) fieldNamed: aFieldValueAssociation fieldName ].
	mapping := aDescriptor newMapping: AdHocMapping.
	mapping
		forAttribute: anAttributeName
		fromDb: [ :row :elementBuilder :context | 
			| instanceCreationParameters |

			instanceCreationParameters := aFieldValueAssociationsCollection
				collect: [ :aFieldValueAssociation | 
					| field |

					field := ( self tableNamed: aFieldValueAssociation tableName ) fieldNamed: aFieldValueAssociation fieldName.
					aFieldValueAssociation fromDatabaseToSmalltalkConversion
						value: ( elementBuilder valueOfField: ( context translateField: field ) in: row )
					].
			anObjectToPrepareModel perform: aMessageToPrepareModel withArguments: instanceCreationParameters asArray
			]
		toDb: [ :rows :attribute :attributeRows | 
			aFieldValueAssociationsCollection
				do: [ :aFieldValueAssociation | 
					| table field value |

					table := self tableNamed: aFieldValueAssociation tableName.
					field := table fieldNamed: aFieldValueAssociation fieldName.
					value := attribute perform: aFieldValueAssociation accessorMessage.
					( rows at: table ) at: field put: ( aFieldValueAssociation fromSmalltalkToDatabaseConversion value: value )
					]
			]
		mappingFields:
			( fields isEmpty
				ifTrue: [ #() ]
				ifFalse: [ OrderedCollection with: fields first ] ).
	^ mapping
]

{ #category : #'defining attributes' }
ConfigurableDescriptorSystem >> defineBasicAttributeOn: aGlorpClassModel named: attributeName [

	aGlorpClassModel newAttributeNamed: attributeName
]

{ #category : #'defining attributes' }
ConfigurableDescriptorSystem >> defineBasicAttributeOn: aGlorpClassModel withoutDirectAccessNamed: attributeName [

	( aGlorpClassModel newAttributeNamed: attributeName ) useDirectAccess: false
]

{ #category : #'defining fields' }
ConfigurableDescriptorSystem >> defineBinaryLargeObjectFieldOn: aDatabaseTable named: fieldName [

	| field |

	field := DatabaseField named: fieldName type: platform blob.
	aDatabaseTable addField: field.
	^ field
]

{ #category : #'defining fields' }
ConfigurableDescriptorSystem >> defineBooleanFieldOn: aDatabaseTable named: fieldName [

	| field |

	field := DatabaseField named: fieldName type: platform boolean.
	aDatabaseTable addField: field.
	^ field
]

{ #category : #'defining fields' }
ConfigurableDescriptorSystem >> defineCharacterFieldOn: aDatabaseTable named: fieldName sized: fieldSize [

	| field |

	field := DatabaseField named: fieldName type: ( platform varChar: fieldSize ).
	aDatabaseTable addField: field.
	^ field
]

{ #category : #'defining fields' }
ConfigurableDescriptorSystem >> defineCharacterLargeObjectFieldOn: aDatabaseTable named: fieldName [

	| field |

	field := DatabaseField named: fieldName type: platform clob.
	aDatabaseTable addField: field.
	^ field
]

{ #category : #'defining other' }
ConfigurableDescriptorSystem >> defineClassModelBasedOn: aGlorpClassModel withAttributesDefinedBy: attributeDefinitions [

	attributeDefinitions do: [ :attributeDefinition | attributeDefinition defineFor: aGlorpClassModel using: self ]
]

{ #category : #'defining descriptors' }
ConfigurableDescriptorSystem >> defineConcreteDescriptorBasedOn: aDescriptor onTableNamed: tableName mappingsDefinedBy: mappingDefinitions [

	aDescriptor table: ( self tableNamed: tableName ).
	mappingDefinitions do: [ :mappingDefinition | mappingDefinition defineFor: aDescriptor using: self ].
	^ aDescriptor
]

{ #category : #'defining mappings' }
ConfigurableDescriptorSystem >> defineConditionalMappingOn: aDescriptor fromAttributeNamed: attributeName sending: conditionalMessage choosingFrom: aCollectionOfMappingDefinitions accordingTo: aCollectionOfTestingBlocks [

	| mapping defaultMapping |

	mapping := aDescriptor newMapping: ConditionalMapping.
	mapping attributeName: attributeName.
	mapping conditionalMethod: conditionalMessage.
	aCollectionOfMappingDefinitions
		with: aCollectionOfTestingBlocks
		do: [ :mappingDefinition :testingBlock | 
			| eachMapping |

			eachMapping := mappingDefinition defineFor: mapping using: self.
			mapping if: testingBlock then: eachMapping
			].
	defaultMapping := ConstantMapping new
		constantValue: [ Error signal: 'Cannot find an applicable condition.' ];
		yourself.
	mapping otherwise: defaultMapping.
	^ mapping
]

{ #category : #'defining mappings' }
ConfigurableDescriptorSystem >> defineConstantMappingOn: aDescriptor fromAttributeNamed: attributeName mappedTo: constant [

	^ ( aDescriptor newMapping: ConstantMapping )
		attributeName: attributeName;
		constantValue: constant
]

{ #category : #'defining fields' }
ConfigurableDescriptorSystem >> defineDecimalFieldOn: aDatabaseTable named: fieldName withPrecision: precision andScale: scale [

	| field |

	field := DatabaseField
		named: fieldName
		type:
			( platform decimal
				precision: precision;
				scale: scale;
				yourself ).
	aDatabaseTable addField: field.
	^ field
]

{ #category : #'defining mappings' }
ConfigurableDescriptorSystem >> defineDirectMappingOn: aDescriptor fromAttributeNamed: attributeName toFieldNamed: fieldName onTableNamed: tableName conversionDefinedBy: conversionDefinition [

	| table mapping |

	table := self tableNamed: tableName.
	mapping := ( aDescriptor newMapping: DirectMapping )
		from: attributeName to: ( table fieldNamed: fieldName );
		yourself.
	^ conversionDefinition defineFor: mapping using: self
]

{ #category : #'defining mappings' }
ConfigurableDescriptorSystem >> defineEmbeddedValueOneToOneMappingOn: aDescriptor forAttributeNamed: attributeName [

	| mapping |

	mapping := aDescriptor newMapping: EmbeddedValueOneToOneMapping.
	mapping attributeName: attributeName.
	^ mapping
]

{ #category : #'defining mappings' }
ConfigurableDescriptorSystem >> defineEmbeddedValueOneToOneMappingWithTranslationOn: aDescriptor
	translatingFieldsUsingAll: fieldTranslationDefinitions
	basedOn: basicDefinition [


	| translation mapping |

	translation := Join new.
	mapping := basicDefinition defineFor: aDescriptor using: self.
	fieldTranslationDefinitions
		do: [ :translationDefinition | translationDefinition defineFor: translation using: self ].
	mapping fieldTranslation: translation.
	^ mapping
]

{ #category : #'defining type resolvers' }
ConfigurableDescriptorSystem >> defineFilteredTypeResolverFor: anAbstractClass [

	^ FilteredTypeResolver forRootClass: anAbstractClass
]

{ #category : #'defining fields' }
ConfigurableDescriptorSystem >> defineForeignKeyFieldOn: aDatabaseTable named: fieldName toFieldNamed: foreignFieldName onTableNamed: foreignTableName [

	| field foreignField |

	field := ( IntegerFieldDefinition named: fieldName ) defineFor: aDatabaseTable using: self.
	foreignField := ( self tableNamed: foreignTableName ) fieldNamed: foreignFieldName.
	aDatabaseTable addForeignKeyFrom: field to: foreignField.
	^ field
]

{ #category : #'defining type resolvers' }
ConfigurableDescriptorSystem >> defineHorizontalTypeResolverFor: anAbstractClass [

	^ HorizontalTypeResolver forRootClass: anAbstractClass
]

{ #category : #'defining tables' }
ConfigurableDescriptorSystem >> defineImaginaryTableBasedOn: aDatabaseTable using: tableDefinition [

	aDatabaseTable isImaginary: true.
	tableDefinition defineFor: aDatabaseTable using: self
]

{ #category : #'defining other' }
ConfigurableDescriptorSystem >> defineIndexOn: aDatabaseTable forFieldsNamed: aFieldNameCollection [

	| fields index |

	fields := aFieldNameCollection
		collect: [ :fieldName | 
			aDatabaseTable fields
				detect: [ :field | field name = fieldName ]
				ifNone: [ Error
						signal:
							( 'Cannot create an index over the field <1p>, because it was not found in <2p>'
								expandMacrosWith: fieldName
								with: aDatabaseTable name )
					]
			].
	index := DatabaseIndex forFields: fields.
	aDatabaseTable addIndex: index.
	^ index
]

{ #category : #'defining fields' }
ConfigurableDescriptorSystem >> defineIntegerFieldOn: aDatabaseTable named: fieldName [

	| field |

	field := DatabaseField named: fieldName type: platform integer.
	aDatabaseTable addField: field.
	^ field
]

{ #category : #'defining mappings' }
ConfigurableDescriptorSystem >> defineJoinBasedMappingOn: aDescriptor forAttributeNamed: attributeName joiningFieldNamed: sourceFieldName onTableNamed: sourceTableName toFieldNamed: targetFieldName onTableNamed: targetTableName conversionDefinedBy: conversionDefinition [

	| mapping sourceTable targetTable |

	mapping := aDescriptor newMapping: DirectMapping.
	sourceTable := self tableNamed: sourceTableName.
	targetTable := self tableNamed: targetTableName.
	aDescriptor
		addMultipleTableJoin:
			( Join
				from: ( sourceTable fieldNamed: sourceFieldName )
				to: ( targetTable fieldNamed: RDBMSConstants sequentialNumberFieldName ) ).
	mapping attributeName: attributeName.
	mapping field: ( targetTable fieldNamed: targetFieldName ).
	^ conversionDefinition defineFor: mapping using: self
]

{ #category : #'defining joins' }
ConfigurableDescriptorSystem >> defineJoinBasedOn: aJoin usingAll: aTranslationDefinitionCollection [

	aTranslationDefinitionCollection
		do: [ :translationDefinition | translationDefinition defineFor: aJoin using: self ].
	^ aJoin
]

{ #category : #'defining mappings' }
ConfigurableDescriptorSystem >> defineManyToManyMappingOn: aDescriptor forAttributeNamed: attributeName translatingFieldsUsingAll: classTranslationDefinitions [

	| join mapping |

	join := Join new.
	mapping := aDescriptor newMapping: ManyToManyMapping.
	mapping attributeName: attributeName.
	classTranslationDefinitions do: [ :translationDefinition | translationDefinition defineFor: join using: self ].
	mapping join: join.
	^ mapping
]

{ #category : #'defining attributes' }
ConfigurableDescriptorSystem >> defineOneToManyBasicAttributeMappingOn: aDescriptor forAttributeNamed: attributeName obtainingValuesFrom: aFieldName andPositionFrom: aPositionFieldName on: aTableName usingAll: classTranslationDefinitions [

	| join mapping |

	join := Join new.
	mapping := aDescriptor newMapping: DirectToManyMapping.
	mapping
		attributeName: attributeName;
		resultField: ( ( self tableNamed: aTableName ) fieldNamed: aFieldName );
		writeTheOrderField;
		orderBy: [ :each | ( each getTable: aTableName ) getField: aPositionFieldName ].
	classTranslationDefinitions do: [ :translationDefinition | translationDefinition defineFor: join using: self ].
	mapping join: join.
	^ mapping
]

{ #category : #'defining mappings' }
ConfigurableDescriptorSystem >> defineOneToManyMappingOn: aDescriptor forAttributeNamed: attributeName translatingFieldsUsingAll: classTranslationDefinitions [

	| join mapping |

	join := Join new.
	mapping := aDescriptor newMapping: OneToManyMapping.
	mapping attributeName: attributeName.
	classTranslationDefinitions do: [ :translationDefinition | translationDefinition defineFor: join using: self ].
	mapping join: join.
	^ mapping
]

{ #category : #'defining mappings' }
ConfigurableDescriptorSystem >> defineOneToOneMappingOn: aDescriptor forAttributeNamed: attributeName [

	| mapping |

	mapping := aDescriptor newMapping: OneToOneMapping.
	mapping attributeName: attributeName.
	^ mapping
]

{ #category : #'defining mappings' }
ConfigurableDescriptorSystem >> defineOneToOneMappingWithTranslationOn: aDescriptor
	basedOn: aBasicDefinition
	translatingFieldsUsingAll: aTranslationDefinitionCollection [


	| join mapping |

	join := Join new.
	mapping := aBasicDefinition defineFor: aDescriptor using: self.
	aTranslationDefinitionCollection do: [ :translationDefinition | translationDefinition defineFor: join using: self ].
	mapping join: join.
	^ mapping
]

{ #category : #'defining mappings' }
ConfigurableDescriptorSystem >> defineOneToOneVariableMappingOn: aDescriptor
	forAttributeNamed: anAttributeName
	joiningFieldNamed: aSourceFieldName
	onTableNamed: aSourceTableName
	toFieldNamed: aTargetFieldName
	onEachTableDefinedFor: aModelClassCollection [


	| mapping join |

	mapping := ( OneToOneMappingDefinition forAttributeNamed: anAttributeName ) defineFor: aDescriptor using: self.
	join := ( VariableJoinDefinition
		fromFieldNamed: aSourceFieldName
		onTableNamed: aSourceTableName
		toFieldNamed: aTargetFieldName
		onEachTableDefinedFor: ( aModelClassCollection intersection: allClasses ) ) defineFor: VariableJoin new using: self.
	mapping join: join.
	^ mapping
]

{ #category : #'defining other' }
ConfigurableDescriptorSystem >> definePluggableConversionOn: aMapping
	named: aName
	convertingFromDatabaseToSmalltalkUsing: aFromDatabaseConversionBlock
	fromSmalltalkToDatabaseUsing: aFromSmalltalkConversionBlock [


	^ aMapping
		converter:
			( PluggableDatabaseConverter new
				name: aName;
				dbToStConverter: aFromDatabaseConversionBlock;
				stToDbConverter: aFromSmalltalkConversionBlock;
				yourself );
		yourself
]

{ #category : #'defining tables' }
ConfigurableDescriptorSystem >> defineRealTableBasedOn: aDatabaseTable fieldsDefinedBy: fieldDefinitions indexesDefinedBy: indexDefinitions [

	fieldDefinitions do: [ :definition | definition defineFor: aDatabaseTable using: self ].
	indexDefinitions do: [ :definition | definition defineFor: aDatabaseTable using: self ].
	aDatabaseTable postInitializeIn: self.
	self deferentialSetSchema: aDatabaseTable
]

{ #category : #'defining fields' }
ConfigurableDescriptorSystem >> defineSequentialNumberFieldOn: aDatabaseTable [

	^ ( aDatabaseTable createFieldNamed: RDBMSConstants sequentialNumberFieldName type: platform sequence )
		bePrimaryKey;
		yourself
]

{ #category : #'defining mappings' }
ConfigurableDescriptorSystem >> defineSequentialNumberMappingOn: aDescriptor onTableNamed: tableName [

	| mapping |

	mapping := DirectMappingDefinition
		fromAttributeNamed: RDBMSConstants sequentialNumberAttribute
		toFieldNamed: RDBMSConstants sequentialNumberFieldName
		onTableNamed: tableName.
	^ mapping defineFor: aDescriptor using: self
]

{ #category : #'defining fields' }
ConfigurableDescriptorSystem >> defineSharedSequentialNumberFieldOn: aDatabaseTable forAbstractConcept: anAbstractClass [

	^ ( aDatabaseTable
		createFieldNamed: RDBMSConstants sequentialNumberFieldName
		type: ( platform sharedSequenceForAbstractConcept: anAbstractClass ) )
		bePrimaryKey;
		yourself
]

{ #category : #'defining fields' }
ConfigurableDescriptorSystem >> defineTimestampFieldOn: aDatabaseTable named: fieldName [

	| field |

	field := DatabaseField named: fieldName type: platform timestamp.
	aDatabaseTable addField: field.
	^ field
]

{ #category : #'defining other' }
ConfigurableDescriptorSystem >> defineTranslationBasedOn: aJoin fromFieldNamed: sourceFieldName onTableNamed: sourceTableName toFieldNamed: targetFieldName onTableNamed: targetTableName [

	| sourceTable targetTable |

	sourceTable := self tableNamed: sourceTableName.
	targetTable := self tableNamed: targetTableName.
	aJoin addSource: ( sourceTable fieldNamed: sourceFieldName ) target: ( targetTable fieldNamed: targetFieldName )
]

{ #category : #'defining attributes' }
ConfigurableDescriptorSystem >> defineTypedAttributeOn: aGlorpClassModel named: attributeName typed: attributeType [

	aGlorpClassModel newAttributeNamed: attributeName type: attributeType
]

{ #category : #'defining attributes' }
ConfigurableDescriptorSystem >> defineTypedAttributeOn: aGlorpClassModel named: attributeName typed: attributeType inCollectionOfType: aCollectionType [

	aGlorpClassModel newAttributeNamed: attributeName collection: aCollectionType of: attributeType
]

{ #category : #'defining joins' }
ConfigurableDescriptorSystem >> defineVariableJoinBasedOn: aVariableJoin fromFieldNamed: aSourceFieldName onTableNamed: aSourceTableName toFieldNamed: aTargetFieldName onEachTableDefinedFor: aModelClassCollection [

	aModelClassCollection
		do: [ :currentModelClass | 
			| joinCurrentModelClass |

			joinCurrentModelClass := ( StandardJoinDefinition
				for:
					( TableFieldTranslationDefinition
						translatingFieldNamed: aSourceFieldName
						onTableNamed: aSourceTableName
						toFieldNamed: aTargetFieldName
						onTableNamed: ( self descriptorFor: currentModelClass ) primaryTable name ) )
				defineFor: Join new
				using: self.
			aVariableJoin addJoinFor: currentModelClass as: joinCurrentModelClass
			].
	^ aVariableJoin
]

{ #category : #private }
ConfigurableDescriptorSystem >> descriptorDefinitionFor: aDescriptor ifFound: aOneArgBlock ifNotFound: aZeroArgBlock [

	^ descriptorDefinitions detect: [ :definition | definition isFor: aDescriptor ] ifFound: aOneArgBlock ifNone: aZeroArgBlock
]

{ #category : #initialization }
ConfigurableDescriptorSystem >> initialize [

	super initialize.
	tableDefinitions := OrderedCollection new.
	descriptorDefinitions := OrderedCollection new.
	classModelDefinitions := OrderedCollection new.
	typeResolverDefinitions := OrderedCollection new
]

{ #category : #private }
ConfigurableDescriptorSystem >> initializeClassModel: aClassModel [

	self
		classModelDefinitionFor: aClassModel
		ifFound: [ :definition | definition defineFor: aClassModel using: self ]
		ifNotFound: [ self signalDefinitionMissingFor: aClassModel ]
]

{ #category : #private }
ConfigurableDescriptorSystem >> initializeDescriptor: aDescriptor [

	self
		descriptorDefinitionFor: aDescriptor
		ifFound: [ :definition | definition defineFor: aDescriptor using: self ]
		ifNotFound: [ self signalDefinitionMissingFor: aDescriptor ]
]

{ #category : #private }
ConfigurableDescriptorSystem >> initializeTable: aDatabaseTable [

	self
		tableDefinitionFor: aDatabaseTable
		ifFound: [ :definition | definition defineFor: aDatabaseTable using: self ]
		ifNotFound: [ self signalDefinitionMissingFor: aDatabaseTable ]
]

{ #category : #private }
ConfigurableDescriptorSystem >> newTypeResolverFor: aClass [

	^ typeResolverDefinitions
		detect: [ :definition | definition isFor: aClass ]
		ifFound: [ :definition | definition defineFor: aClass using: self ]
		ifNone: [ self signalDefinitionMissingFor: aClass ]
]

{ #category : #copying }
ConfigurableDescriptorSystem >> postCopy [

	" Need to refresh the Descriptors because these references
	the original system - jvanecek "

	descriptors := Dictionary new
]

{ #category : #private }
ConfigurableDescriptorSystem >> signalDefinitionMissingFor: aGlorpObject [

	self error: ( 'Definition for <1p> missing.' expandMacrosWith: aGlorpObject )
]

{ #category : #private }
ConfigurableDescriptorSystem >> tableDefinitionFor: aDatabaseTable ifFound: aOneArgBlock ifNotFound: aZeroArgBlock [

	^ tableDefinitions detect: [ :definition | definition isFor: aDatabaseTable ] ifFound: aOneArgBlock ifNone: aZeroArgBlock
]
