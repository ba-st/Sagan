"
I'm an implementation for In Memory Repositories.
I will try to solve everything using plain messages without any DSL.
"
Class {
	#name : #InMemoryRepositoryMatchingCriteriaBuilder,
	#superclass : #RepositoryMatchingCriteriaBuilder,
	#category : #'Sagan-Core'
}

{ #category : #'identity operations' }
InMemoryRepositoryMatchingCriteriaBuilder >> does: anObjectInRepository equal: anObject [

	^ anObjectInRepository = anObject
]

{ #category : #'string matching' }
InMemoryRepositoryMatchingCriteriaBuilder >> does: aStringInRepository includeSubstring: aString [

	^ aStringInRepository includesSubstring: aString
]

{ #category : #'identity operations' }
InMemoryRepositoryMatchingCriteriaBuilder >> does: objectInRepository notEqual: objectInMemory [

	^ objectInRepository ~= objectInMemory
]

{ #category : #testing }
InMemoryRepositoryMatchingCriteriaBuilder >> is: anObject includedIn: aCollection [

	^ aCollection includes: anObject
]

{ #category : #'boolean operations' }
InMemoryRepositoryMatchingCriteriaBuilder >> satisfying: aBoolean and: aBlock [

	^ aBoolean and: aBlock
]

{ #category : #'boolean operations' }
InMemoryRepositoryMatchingCriteriaBuilder >> satisfying: aBoolean or: aBlock [

	^ aBoolean or: aBlock
]

{ #category : #'boolean operations' }
InMemoryRepositoryMatchingCriteriaBuilder >> satisfyingAll: aBooleanCollection [

	^ aBooleanCollection allSatisfy: [ :each | each ]
]

{ #category : #'boolean operations' }
InMemoryRepositoryMatchingCriteriaBuilder >> satisfyingAny: aBooleanCollection [

	^ aBooleanCollection anySatisfy: [ :each | each ]
]
