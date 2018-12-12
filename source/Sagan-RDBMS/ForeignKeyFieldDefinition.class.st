Class {
	#name : #ForeignKeyFieldDefinition,
	#superclass : #TableFieldDefinition,
	#instVars : [
		'fieldName',
		'foreignFieldName',
		'foreignTableName',
		'postDefinitionAction'
	],
	#category : #'Sagan-RDBMS-Fields'
}

{ #category : #'Instance Creation' }
ForeignKeyFieldDefinition class >> named: aFieldName toFieldNamed: aForeignFieldName onTableNamed: aForeignTableName [

	^ self
		named: aFieldName
		toFieldNamed: aForeignFieldName
		onTableNamed: aForeignTableName
		applyingAfterDefinition: self nullAction
]

{ #category : #'Instance Creation' }
ForeignKeyFieldDefinition class >> named: aFieldName toFieldNamed: aForeignFieldName onTableNamed: aForeignTableName applyingAfterDefinition: aTwoArgBlock [

	^ self new
		initializeNamed: aFieldName
		toFieldNamed: aForeignFieldName
		onTableNamed: aForeignTableName
		applyingAfterDefinition: aTwoArgBlock
]

{ #category : #'Instance Creation' }
ForeignKeyFieldDefinition class >> nullableNamed: aFieldName toFieldNamed: aForeignFieldName onTableNamed: aForeignTableName [

	^ self
		named: aFieldName
		toFieldNamed: aForeignFieldName
		onTableNamed: aForeignTableName
		applyingAfterDefinition: self makeFieldNullable
]

{ #category : #'Instance Creation' }
ForeignKeyFieldDefinition class >> toBePrimaryKeyNamed: aFieldName toFieldNamed: aForeignFieldName onTableNamed: aForeignTableName [

	^ self
		named: aFieldName
		toFieldNamed: aForeignFieldName
		onTableNamed: aForeignTableName
		applyingAfterDefinition: self makeFieldPrimaryKey
]

{ #category : #Defining }
ForeignKeyFieldDefinition >> defineFieldOn: aDatabaseTable using: aDescriptorSystem [

	| field |

	field := aDescriptorSystem
		defineForeignKeyFieldOn: aDatabaseTable
		named: fieldName
		toFieldNamed: foreignFieldName
		onTableNamed: foreignTableName.
	postDefinitionAction value: field value: aDescriptorSystem.
	^ field
]

{ #category : #Accessing }
ForeignKeyFieldDefinition >> foreignTableName [

	^ foreignTableName
]

{ #category : #Initialization }
ForeignKeyFieldDefinition >> initializeNamed: aFieldName toFieldNamed: aForeignFieldName onTableNamed: aForeignTableName applyingAfterDefinition: aTwoArgBlock [

	fieldName := aFieldName.
	foreignFieldName := aForeignFieldName.
	foreignTableName := aForeignTableName.
	postDefinitionAction := aTwoArgBlock
]

{ #category : #testing }
ForeignKeyFieldDefinition >> isForForeignKeys [

	^ true
]

{ #category : #Printing }
ForeignKeyFieldDefinition >> printOn: aStream [

	aStream
		print: fieldName;
		space;
		nextPut: $(;
		nextPutAll: 'foreign key';
		nextPut: $);
		yourself
]
