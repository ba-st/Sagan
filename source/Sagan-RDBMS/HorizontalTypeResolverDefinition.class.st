Class {
	#name : 'HorizontalTypeResolverDefinition',
	#superclass : 'TypeResolverDefinition',
	#instVars : [
		'abstractClass'
	],
	#category : 'Sagan-RDBMS-Core',
	#package : 'Sagan-RDBMS',
	#tag : 'Core'
}

{ #category : 'Instance Creation' }
HorizontalTypeResolverDefinition class >> for: anAbstractClass [

	^ self new initializeFor: anAbstractClass
]

{ #category : 'Accessing' }
HorizontalTypeResolverDefinition >> abstractClass [

	^ abstractClass
]

{ #category : 'Defining' }
HorizontalTypeResolverDefinition >> defineTypeResolverFor: aModelClass using: aDescriptorSystem [

	^ aDescriptorSystem defineHorizontalTypeResolverFor: aModelClass
]

{ #category : 'Initialization' }
HorizontalTypeResolverDefinition >> initializeFor: anAbstractClass [

	abstractClass := anAbstractClass
]
