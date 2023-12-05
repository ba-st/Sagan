"
I represent a builder of matching criteria.

My purpose it's to abstract away complex query construction for the repositories.
Usually every backend hast it's own DSL to create queries and you cannot switch 
easily between them.

My subclasses will resolve any specific details son it can generate efficient 
queries for each backend.

End users can also add new criteria and implement it for the different backends 
they use, so really complex cases and specific situations can be solved without 
sacrificing readability and polymorphism.

"
Class {
	#name : 'RepositoryMatchingCriteriaBuilder',
	#superclass : 'Object',
	#category : 'Sagan-Core',
	#package : 'Sagan-Core'
}

{ #category : 'identity operations' }
RepositoryMatchingCriteriaBuilder >> does: objectInRepository equal: objectInMemory [

	self subclassResponsibility 
]

{ #category : 'string matching' }
RepositoryMatchingCriteriaBuilder >> does: aStringInRepository includeSubstring: aString [

	self subclassResponsibility 
]

{ #category : 'identity operations' }
RepositoryMatchingCriteriaBuilder >> does: objectInRepository notEqual: objectInMemory [

	self subclassResponsibility 
]

{ #category : 'testing' }
RepositoryMatchingCriteriaBuilder >> is: anObject includedIn: aCollection [

	self subclassResponsibility 
]

{ #category : 'testing' }
RepositoryMatchingCriteriaBuilder >> isUndefined: anObject otherwiseSatisfy: aBooleanExpression [

	self subclassResponsibility 
]

{ #category : 'boolean operations' }
RepositoryMatchingCriteriaBuilder >> satisfying: aBooleanExpression and: aBlock [

	self subclassResponsibility 
]

{ #category : 'boolean operations' }
RepositoryMatchingCriteriaBuilder >> satisfying: aBooleanExpression or: aBlock [

	self subclassResponsibility 
]

{ #category : 'boolean operations' }
RepositoryMatchingCriteriaBuilder >> satisfyingAll: aBooleanExpressionCollection [

	self subclassResponsibility 
]

{ #category : 'boolean operations' }
RepositoryMatchingCriteriaBuilder >> satisfyingAny: aBooleanExpressionCollection [

	self subclassResponsibility 
]
