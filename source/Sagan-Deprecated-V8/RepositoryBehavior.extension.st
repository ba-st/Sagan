Extension { #name : 'RepositoryBehavior' }

{ #category : '*Sagan-Deprecated-V8' }
RepositoryBehavior >> configureMappingsIn: aBlock [

	self
		deprecated: 'Use configureWith: instead'
		transformWith:
		'`@receiver configureMappingsIn: `@argument' -> '`@receiver configureWith: `@argument'.

	self configureWith: aBlock
]
