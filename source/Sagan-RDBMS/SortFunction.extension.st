Extension { #name : #SortFunction }

{ #category : #'*Sagan-RDBMS' }
SortFunction >> asOrderByIn: aQuery [

	self subclassResponsibility
]

{ #category : #'*Sagan-RDBMS' }
SortFunction >> asReversedOrderByIn: aQuery [

	self subclassResponsibility
]
