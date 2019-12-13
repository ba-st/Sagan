Extension { #name : #Extraterrestrial }

{ #category : #'*Sagan-RDBMS-Tests' }
Extraterrestrial >> = anObject [

	^ PersistentObjectComparer new shouldConsider: self asEqualTo: anObject
]

{ #category : #'*Sagan-RDBMS-Tests' }
Extraterrestrial >> hash [ 

	^ PersistentObjectComparer new hashFor: self
]
