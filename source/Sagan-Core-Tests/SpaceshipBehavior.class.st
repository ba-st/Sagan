Class {
	#name : #SpaceshipBehavior,
	#superclass : #Object,
	#category : #'Sagan-Core-Tests'
}

{ #category : #accessing }
SpaceshipBehavior >> name [

	self subclassResponsibility
]

{ #category : #printing }
SpaceshipBehavior >> printOn: aStream [

	aStream nextPutAll: self name
]
