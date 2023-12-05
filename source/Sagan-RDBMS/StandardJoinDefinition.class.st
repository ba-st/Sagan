Class {
	#name : 'StandardJoinDefinition',
	#superclass : 'JoinDefinition',
	#instVars : [
		'translationDefinitions'
	],
	#category : 'Sagan-RDBMS-Mappings',
	#package : 'Sagan-RDBMS',
	#tag : 'Mappings'
}

{ #category : 'Instance Creation' }
StandardJoinDefinition class >> for: aTranslationDefinition [

	^ self forAll: ( Array with: aTranslationDefinition )
]

{ #category : 'Instance Creation' }
StandardJoinDefinition class >> forAll: aTranslationDefinitionCollection [

	^ self new initializeForAll: aTranslationDefinitionCollection
]

{ #category : 'Defining' }
StandardJoinDefinition >> defineJoinFor: aJoin using: aDescriptorSystem [

	^ aDescriptorSystem defineJoinBasedOn: aJoin usingAll: translationDefinitions
]

{ #category : 'Initialization' }
StandardJoinDefinition >> initializeForAll: aTranslationDefinitionCollection [

	translationDefinitions := aTranslationDefinitionCollection
]
