Class {
	#name : 'AbstractDescriptorDefinition',
	#superclass : 'DescriptorDefinition',
	#category : 'Sagan-RDBMS-Descriptors',
	#package : 'Sagan-RDBMS',
	#tag : 'Descriptors'
}

{ #category : 'Accessing' }
AbstractDescriptorDefinition >> abstractClass [

	self subclassResponsibility
]

{ #category : 'Defining' }
AbstractDescriptorDefinition >> defineAbstractDescriptorFor: aDescriptor using: aDescriptorSystem [

	self subclassResponsibility
]

{ #category : 'Defining' }
AbstractDescriptorDefinition >> defineDescriptorFor: aDescriptor using: aDescriptorSystem [

	^ self defineAbstractDescriptorFor: aDescriptor using: aDescriptorSystem
]

{ #category : 'Accessing' }
AbstractDescriptorDefinition >> describedClass [

	^ self abstractClass
]

{ #category : 'Printing' }
AbstractDescriptorDefinition >> printOn: aStream [

	aStream
		nextPutAll: 'Descriptor for abstract class ';
		print: self abstractClass;
		yourself
]
