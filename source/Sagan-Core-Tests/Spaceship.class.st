Class {
	#name : #Spaceship,
	#superclass : #SpaceshipBehavior,
	#instVars : [
		'sequentialNumber',
		'name',
		'firepower'
	],
	#category : #'Sagan-Core-Tests'
}

{ #category : #'instance creation' }
Spaceship class >> named: aName [

	^ self withoutFirepowerNamed: aName
]

{ #category : #'instance creation' }
Spaceship class >> named: aName firepower: aNumber [

	^ self new initializeNamed: aName firepower: aNumber
]

{ #category : #accessing }
Spaceship class >> noFirepower [

	^ 0
]

{ #category : #accessing }
Spaceship class >> unlimitedFirepower [

	^ Float infinity
]

{ #category : #'instance creation' }
Spaceship class >> withUnlimitedFirepowerNamed: aName [

	^ self named: aName firepower: self unlimitedFirepower
]

{ #category : #'instance creation' }
Spaceship class >> withoutFirepowerNamed: aName [

	^ self named: aName firepower: self noFirepower
]

{ #category : #accessing }
Spaceship >> firepower [

	^ firepower
]

{ #category : #initialization }
Spaceship >> initializeNamed: aName firepower: aNumber [

	name := aName.
	firepower := aNumber
]

{ #category : #accessing }
Spaceship >> name [

	^ name
]

{ #category : #updating }
Spaceship >> synchronizeWith: aSpaceship [

	name := aSpaceship name.
	firepower := aSpaceship firepower
]
