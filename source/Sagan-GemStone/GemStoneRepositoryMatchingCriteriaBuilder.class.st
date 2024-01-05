"
I'm an implementation for GemStone Repositories.
I will try to solve everything using plain messages without any DSL.
"
Class {
	#name : 'GemStoneRepositoryMatchingCriteriaBuilder',
	#superclass : 'RepositoryMatchingCriteriaBuilder',
	#category : 'Sagan-GemStone',
	#package : 'Sagan-GemStone'
}

{ #category : 'identity operations' }
GemStoneRepositoryMatchingCriteriaBuilder >> does: anObjectInRepository equal: anObject [

	^ anObjectInRepository = anObject
]

{ #category : 'string matching' }
GemStoneRepositoryMatchingCriteriaBuilder >> does: aStringInRepository includeSubstring: aString [

	^ aStringInRepository includesSubstring: aString
]

{ #category : 'identity operations' }
GemStoneRepositoryMatchingCriteriaBuilder >> does: objectInRepository notEqual: objectInMemory [

	^ objectInRepository ~= objectInMemory
]

{ #category : 'testing' }
GemStoneRepositoryMatchingCriteriaBuilder >> is: anObject includedIn: aCollection [

	^ aCollection includes: anObject
]

{ #category : 'testing' }
GemStoneRepositoryMatchingCriteriaBuilder >> isUndefined: anObject otherwiseSatisfy: aBooleanExpression [
	"It is assumed anObject will always be defined when in memory.
	 By defined we refer to any object except nil."

	^ aBooleanExpression
]

{ #category : 'boolean operations' }
GemStoneRepositoryMatchingCriteriaBuilder >> satisfying: aBoolean and: aBlock [

	^ aBoolean and: aBlock
]

{ #category : 'boolean operations' }
GemStoneRepositoryMatchingCriteriaBuilder >> satisfying: aBoolean or: aBlock [

	^ aBoolean or: aBlock
]

{ #category : 'boolean operations' }
GemStoneRepositoryMatchingCriteriaBuilder >> satisfyingAll: aBooleanCollection [

	^ aBooleanCollection allSatisfy: [ :each | each ]
]

{ #category : 'boolean operations' }
GemStoneRepositoryMatchingCriteriaBuilder >> satisfyingAny: aBooleanCollection [

	^ aBooleanCollection anySatisfy: [ :each | each ]
]
