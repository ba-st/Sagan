Class {
	#name : 'RDBMSRepositoryMatchingCriteriaBuilder',
	#superclass : 'RepositoryMatchingCriteriaBuilder',
	#category : 'Sagan-RDBMS-Repository',
	#package : 'Sagan-RDBMS',
	#tag : 'Repository'
}

{ #category : 'testing' }
RDBMSRepositoryMatchingCriteriaBuilder >> does: anObjectInRepository equal: anObjectInMemory [

	^ anObjectInRepository sequentialNumber notNIL AND: [ anObjectInRepository sequentialNumber = anObjectInMemory sequentialNumber ]
]

{ #category : 'testing' }
RDBMSRepositoryMatchingCriteriaBuilder >> does: aStringInRepository includeSubstring: aString [

	"#similarTo: is not implemented per-se but if you look at
	FunctionExpression>>#createBasicFunctionsFor: , GLORP can handle it gracefully
	and produce a LIKE."

	^ aStringInRepository similarTo: ( '<1s><2s><1s>' expandMacrosWith: '%' with: aString )
]

{ #category : 'testing' }
RDBMSRepositoryMatchingCriteriaBuilder >> does: objectInRepository notEqual: objectInMemory [

	^ objectInRepository sequentialNumber notNIL AND: [ objectInRepository sequentialNumber ~= objectInMemory sequentialNumber ]
]

{ #category : 'testing' }
RDBMSRepositoryMatchingCriteriaBuilder >> is: anObject includedIn: aCollection [

	^ anObject in: aCollection
]

{ #category : 'testing' }
RDBMSRepositoryMatchingCriteriaBuilder >> isUndefined: anObject otherwiseSatisfy: aBooleanExpression [

	^ self satisfying: anObject isNIL or: aBooleanExpression
]

{ #category : 'testing' }
RDBMSRepositoryMatchingCriteriaBuilder >> satisfying: aBooleanExpression and: aBlock [

	^ aBooleanExpression AND: aBlock value
]

{ #category : 'testing' }
RDBMSRepositoryMatchingCriteriaBuilder >> satisfying: aBooleanExpression or: aBlock [

	^ aBooleanExpression OR: aBlock value
]

{ #category : 'testing' }
RDBMSRepositoryMatchingCriteriaBuilder >> satisfyingAll: aBooleanExpressionCollection [

	^ aBooleanExpressionCollection inject: true into: [ :result :expression | result & expression ]
]

{ #category : 'testing' }
RDBMSRepositoryMatchingCriteriaBuilder >> satisfyingAny: aBooleanExpressionCollection [

	^ aBooleanExpressionCollection inject: false into: [ :result :expression | result | expression ]
]
