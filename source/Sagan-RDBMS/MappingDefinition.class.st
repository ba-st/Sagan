Class {
	#name : #MappingDefinition,
	#superclass : #PersistenceConceptDefinition,
	#category : #'Sagan-RDBMS-Mappings'
}

{ #category : #'Post Definition Actions' }
MappingDefinition class >> makeMappingExclusive [

	^ [ :mapping :system | mapping beExclusive ]
]

{ #category : #'Post Definition Actions' }
MappingDefinition class >> makeMappingForPseudoVariable [

	^ [ :mapping :system | mapping beForPseudoVariable ]
]

{ #category : #'Post Definition Actions' }
MappingDefinition class >> makeMappingReadOnly [

	^ [ :mapping :system | mapping beReadOnly ]
]

{ #category : #'Post Definition Actions' }
MappingDefinition class >> makeMappingToNotProxy [

	^ [ :mapping :system | mapping shouldProxy: false ]
]

{ #category : #'Post Definition Actions' }
MappingDefinition class >> nullAction [

	^ [ :mapping :system |  ]
]

{ #category : #Defining }
MappingDefinition >> defineFor: aDescriptor using: aDescriptorSystem [

	^ self defineMappingOn: aDescriptor using: aDescriptorSystem
]

{ #category : #Defining }
MappingDefinition >> defineMappingOn: aDescriptor using: aDescriptorSystem [

	self subclassResponsibility
]
