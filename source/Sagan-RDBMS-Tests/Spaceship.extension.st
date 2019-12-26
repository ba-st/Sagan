Extension { #name : #Spaceship }

{ #category : #'*Sagan-RDBMS-Tests' }
Spaceship >> = anObject [

	^ PersistentObjectComparer new shouldConsider: self asEqualTo: anObject
]

{ #category : #'*Sagan-RDBMS-Tests' }
Spaceship >> hash [ 

	^ PersistentObjectComparer new hashFor: self
]
