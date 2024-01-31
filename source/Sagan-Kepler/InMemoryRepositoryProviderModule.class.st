Class {
	#name : 'InMemoryRepositoryProviderModule',
	#superclass : 'SystemModule',
	#instVars : [
		'rootSystem'
	],
	#category : 'Sagan-Kepler',
	#package : 'Sagan-Kepler'
}

{ #category : 'instance creation' }
InMemoryRepositoryProviderModule class >> toInstallOn: aCompositeSystem [

	^ self new initializeToInstallOn: aCompositeSystem
]

{ #category : 'initialization' }
InMemoryRepositoryProviderModule >> initializeToInstallOn: aCompositeSystem [ 

	rootSystem := aCompositeSystem
]

{ #category : 'private' }
InMemoryRepositoryProviderModule >> name [

	^ 'In Memory Repository Provider'
]

{ #category : 'private' }
InMemoryRepositoryProviderModule >> registerRepositoryProviderSystemForInstallationIn: systems [

	^ self
		  register: [
			  RepositoryProviderSystem new
				  register: InMemoryRepositoryProvider new as: #mainDB;
				  yourself ]
		  in: systems
]

{ #category : 'private' }
InMemoryRepositoryProviderModule >> rootSystem [

	^ rootSystem
]

{ #category : 'private' }
InMemoryRepositoryProviderModule >> systemInterfacesToInstall [

	^ #(#RepositoryProviderSystem)
]
