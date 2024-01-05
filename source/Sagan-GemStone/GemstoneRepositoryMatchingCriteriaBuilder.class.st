"
I'm an implementation for Gemstone Repositories.
I will try to solve everything using plain messages without any DSL.
"
Class {
	#name : 'GemstoneRepositoryMatchingCriteriaBuilder',
	#superclass : 'RepositoryMatchingCriteriaBuilder',
	#category : 'Sagan-GemStone',
	#package : 'Sagan-GemStone'
}

{ #category : 'identity operations' }
GemstoneRepositoryMatchingCriteriaBuilder >> does: anObjectInRepository equal: anObject [

	^ anObjectInRepository = anObject
]

{ #category : 'string matching' }
GemstoneRepositoryMatchingCriteriaBuilder >> does: aStringInRepository includeSubstring: aString [

	^ aStringInRepository includesSubstring: aString
]

{ #category : 'identity operations' }
GemstoneRepositoryMatchingCriteriaBuilder >> does: objectInRepository notEqual: objectInMemory [

	^ objectInRepository ~= objectInMemory
]

{ #category : 'testing' }
GemstoneRepositoryMatchingCriteriaBuilder >> is: anObject includedIn: aCollection [

	^ aCollection includes: anObject
]

{ #category : 'testing' }
GemstoneRepositoryMatchingCriteriaBuilder >> isUndefined: anObject otherwiseSatisfy: aBooleanExpression [
	"It is assumed anObject will always be defined when in memory.
	 By defined we refer to any object except nil."

	^ aBooleanExpression
]

{ #category : 'boolean operations' }
GemstoneRepositoryMatchingCriteriaBuilder >> satisfying: aBoolean and: aBlock [

	^ aBoolean and: aBlock
]

{ #category : 'boolean operations' }
GemstoneRepositoryMatchingCriteriaBuilder >> satisfying: aBoolean or: aBlock [

	^ aBoolean or: aBlock
]

{ #category : 'boolean operations' }
GemstoneRepositoryMatchingCriteriaBuilder >> satisfyingAll: aBooleanCollection [

	^ aBooleanCollection allSatisfy: [ :each | each ]
]

{ #category : 'boolean operations' }
GemstoneRepositoryMatchingCriteriaBuilder >> satisfyingAny: aBooleanCollection [

	^ aBooleanCollection anySatisfy: [ :each | each ]
]
