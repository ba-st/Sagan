Class {
	#name : #Spaceship,
	#superclass : #SpaceshipBehavior,
	#instVars : [
		'sequentialNumber',
		'name'
	],
	#category : #'Sagan-Core-Tests'
}

{ #category : #'instance creation' }
Spaceship class >> named: aName [

	^ self new initializeNamed: aName
]

{ #category : #initialization }
Spaceship >> initializeNamed: aName [

	name := aName
]

{ #category : #accessing }
Spaceship >> name [

	^ name
]

{ #category : #updating }
Spaceship >> synchronizeWith: aSpaceship [

	name := aSpaceship name
]
