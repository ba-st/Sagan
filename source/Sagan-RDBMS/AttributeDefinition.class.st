Class {
	#name : 'AttributeDefinition',
	#superclass : 'PersistenceConceptDefinition',
	#category : 'Sagan-RDBMS-Attributes',
	#package : 'Sagan-RDBMS',
	#tag : 'Attributes'
}

{ #category : 'Defining' }
AttributeDefinition >> defineAttributesOn: aGlorpClassModel using: aDescriptorSystem [

	self subclassResponsibility
]

{ #category : 'Defining' }
AttributeDefinition >> defineFor: aGlorpClassModel using: aDescriptorSystem [

	self defineAttributesOn: aGlorpClassModel using: aDescriptorSystem
]
