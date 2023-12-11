Class {
	#name : 'JoinDefinition',
	#superclass : 'PersistenceConceptDefinition',
	#category : 'Sagan-RDBMS-Mappings',
	#package : 'Sagan-RDBMS',
	#tag : 'Mappings'
}

{ #category : 'Defining' }
JoinDefinition >> defineFor: aJoin using: aDescriptorSystem [

	^ self defineJoinFor: aJoin using: aDescriptorSystem
]

{ #category : 'Defining' }
JoinDefinition >> defineJoinFor: aDescriptor using: aDescriptorSystem [

	self subclassResponsibility
]
