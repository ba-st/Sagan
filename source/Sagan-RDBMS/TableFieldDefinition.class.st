Class {
	#name : 'TableFieldDefinition',
	#superclass : 'PersistenceConceptDefinition',
	#category : 'Sagan-RDBMS-Fields',
	#package : 'Sagan-RDBMS',
	#tag : 'Fields'
}

{ #category : 'Post Definition Actions' }
TableFieldDefinition class >> makeFieldHaveDefaultValue: aValue [

	^ [ :field :system | field defaultValue: aValue ]
]

{ #category : 'Post Definition Actions' }
TableFieldDefinition class >> makeFieldNotNullable [

	^ [ :field :system | field beNullable: false ]
]

{ #category : 'Post Definition Actions' }
TableFieldDefinition class >> makeFieldNullable [

	^ [ :field :system | field beNullable: true ]
]

{ #category : 'Post Definition Actions' }
TableFieldDefinition class >> makeFieldPrimaryKey [

	^ [ :field :system | field bePrimaryKey ]
]

{ #category : 'Post Definition Actions' }
TableFieldDefinition class >> makeFieldUniqueNotNullable [

	^ [ :field :system | 
	field
		isUnique: true;
		beNullable: false
	]
]

{ #category : 'Post Definition Actions' }
TableFieldDefinition class >> nullAction [

	^ [ :field :system |  ]
]

{ #category : 'Defining' }
TableFieldDefinition >> defineFieldOn: aDatabaseTable using: aDescriptorSystem [

	self subclassResponsibility
]

{ #category : 'Defining' }
TableFieldDefinition >> defineFor: aDatabaseTable using: aDescriptorSystem [

	^ self defineFieldOn: aDatabaseTable using: aDescriptorSystem
]

{ #category : 'testing' }
TableFieldDefinition >> isForForeignKeys [

	^ false
]
