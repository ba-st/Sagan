Class {
	#name : 'DescriptorDefinition',
	#superclass : 'PersistenceConceptDefinition',
	#category : 'Sagan-RDBMS-Descriptors',
	#package : 'Sagan-RDBMS',
	#tag : 'Descriptors'
}

{ #category : 'Defining' }
DescriptorDefinition >> defineDescriptorFor: aDescriptor using: aDescriptorSystem [

	self subclassResponsibility
]

{ #category : 'Defining' }
DescriptorDefinition >> defineFor: aDescriptor using: aDescriptorSystem [

	^ self defineDescriptorFor: aDescriptor using: aDescriptorSystem
]

{ #category : 'Accessing' }
DescriptorDefinition >> describedClass [

	self subclassResponsibility
]

{ #category : 'Testing' }
DescriptorDefinition >> isFor: aDescriptor [

	^ self describedClass = aDescriptor describedClass
]
