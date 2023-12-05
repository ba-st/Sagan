Class {
	#name : 'FilteredTypeResolverDefinition',
	#superclass : 'TypeResolverDefinition',
	#instVars : [
		'abstractClass'
	],
	#category : 'Sagan-RDBMS-Core',
	#package : 'Sagan-RDBMS',
	#tag : 'Core'
}

{ #category : 'Instance Creation' }
FilteredTypeResolverDefinition class >> for: anAbstractClass [

	^ self new initializeFor: anAbstractClass
]

{ #category : 'Accessing' }
FilteredTypeResolverDefinition >> abstractClass [

	^ abstractClass
]

{ #category : 'Defining' }
FilteredTypeResolverDefinition >> defineTypeResolverFor: aModelClass using: aDescriptorSystem [

	^ aDescriptorSystem defineFilteredTypeResolverFor: aModelClass
]

{ #category : 'Initialization' }
FilteredTypeResolverDefinition >> initializeFor: anAbstractClass [

	abstractClass := anAbstractClass
]
