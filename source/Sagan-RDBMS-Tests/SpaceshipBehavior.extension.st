Extension { #name : 'SpaceshipBehavior' }

{ #category : '*Sagan-RDBMS-Tests' }
SpaceshipBehavior >> = anObject [

	^ PersistentObjectComparer new shouldConsider: self asEqualTo: anObject
]

{ #category : '*Sagan-RDBMS-Tests' }
SpaceshipBehavior >> hash [ 

	^ PersistentObjectComparer new hashFor: self
]

{ #category : '*Sagan-RDBMS-Tests' }
SpaceshipBehavior >> sequentialNumber [

	self subclassResponsibility 
]
