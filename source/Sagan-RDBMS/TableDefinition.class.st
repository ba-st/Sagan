Class {
	#name : 'TableDefinition',
	#superclass : 'PersistenceConceptDefinition',
	#category : 'Sagan-RDBMS-Core',
	#package : 'Sagan-RDBMS',
	#tag : 'Core'
}

{ #category : 'Defining' }
TableDefinition >> defineFor: aDatabaseTable using: aDescriptorSystem [

	^ self defineTableFor: aDatabaseTable using: aDescriptorSystem
]

{ #category : 'Defining' }
TableDefinition >> defineTableFor: aDatabaseTable using: aDescriptorSystem [

	self subclassResponsibility
]

{ #category : 'Testing' }
TableDefinition >> isFor: aDatabaseTable [

	^ aDatabaseTable name = self tableName
]

{ #category : 'Accessing' }
TableDefinition >> tableName [

	self subclassResponsibility
]
