Class {
	#name : 'RepositoryProviderSystemBasedTest',
	#superclass : 'TestCase',
	#instVars : [
		'repositoryProviderSystem',
		'celestialBodies'
	],
	#category : 'Sagan-RDBMS-Tests',
	#package : 'Sagan-RDBMS-Tests'
}

{ #category : 'testing' }
RepositoryProviderSystemBasedTest class >> isAbstract [ 

	^self name = #RepositoryProviderSystemBasedTest
]

{ #category : 'running' }
RepositoryProviderSystemBasedTest >> repositoriesContainerName [

	^ 'mainDb'
]

{ #category : 'running' }
RepositoryProviderSystemBasedTest >> repositoryProvider [

	^ RDBMSRepositoryProvider using: SingleSessionRDMBSRepositoryTest login
]

{ #category : 'running' }
RepositoryProviderSystemBasedTest >> setUp [

	super setUp.

	repositoryProviderSystem := RepositoryProviderSystem new.
	repositoryProviderSystem register: self repositoryProvider as: self repositoriesContainerName.
	self setUpRepositories.
	repositoryProviderSystem prepareForInitialPersistence
]

{ #category : 'running' }
RepositoryProviderSystemBasedTest >> setUpRepositories [

	self subclassResponsibility
]

{ #category : 'running' }
RepositoryProviderSystemBasedTest >> tearDown [

	repositoryProviderSystem destroyRepositories
]
