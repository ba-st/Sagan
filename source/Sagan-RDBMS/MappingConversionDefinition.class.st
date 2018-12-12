Class {
	#name : #MappingConversionDefinition,
	#superclass : #PersistenceConceptDefinition,
	#category : #'Sagan-RDBMS-Mappings'
}

{ #category : #Defining }
MappingConversionDefinition >> defineConversionOn: aMapping using: aDescriptorSystem [

	self subclassResponsibility
]

{ #category : #Defining }
MappingConversionDefinition >> defineFor: aMapping using: aDescriptorSystem [

	^ self defineConversionOn: aMapping using: aDescriptorSystem
]
