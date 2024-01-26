Class {
	#name : 'GemStoneRepositoryProviderModule',
	#superclass : 'SystemModule',
	#instVars : [
		'rootSystem'
	],
	#category : 'Sagan-GemStone',
	#package : 'Sagan-GemStone'
}

{ #category : 'instance creation' }
GemStoneRepositoryProviderModule class >> toInstallOn: aCompositeSystem [

	^ self new initializeToInstallOn: aCompositeSystem
]

{ #category : 'initialization' }
GemStoneRepositoryProviderModule >> initializeToInstallOn: aCompositeSystem [ 

	rootSystem := aCompositeSystem
]

{ #category : 'private' }
GemStoneRepositoryProviderModule >> name [

	^ 'GemStone Repository Provider'
]

{ #category : 'private' }
GemStoneRepositoryProviderModule >> registerRepositoryProviderSystemForInstallationIn: systems [

	^ self
		  register: [
			  RepositoryProviderSystem new
				  register: GemStoneRepositoryProvider new as: #mainDB;
				  yourself ]
		  in: systems
]

{ #category : 'private' }
GemStoneRepositoryProviderModule >> rootSystem [

	^ rootSystem
]

{ #category : 'private' }
GemStoneRepositoryProviderModule >> systemInterfacesToInstall [

	^ #(#RepositoryProviderSystem)
]
