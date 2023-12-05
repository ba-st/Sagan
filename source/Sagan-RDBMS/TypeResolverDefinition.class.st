Class {
	#name : 'TypeResolverDefinition',
	#superclass : 'PersistenceConceptDefinition',
	#category : 'Sagan-RDBMS-Core',
	#package : 'Sagan-RDBMS',
	#tag : 'Core'
}

{ #category : 'Defining' }
TypeResolverDefinition >> abstractClass [

	self subclassResponsibility
]

{ #category : 'Defining' }
TypeResolverDefinition >> defineFor: aModelClass using: aDescriptorSystem [

	^ self defineTypeResolverFor: aModelClass using: aDescriptorSystem
]

{ #category : 'Defining' }
TypeResolverDefinition >> defineTypeResolverFor: aModelClass using: aDescriptorSystem [

	self subclassResponsibility
]

{ #category : 'Testing' }
TypeResolverDefinition >> isFor: aClass [

	^ aClass = self abstractClass
]
