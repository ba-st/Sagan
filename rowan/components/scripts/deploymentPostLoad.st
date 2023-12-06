| symbolDictionary |

symbolDictionary := Rowan image 
	symbolDictNamed: 'Sagan'
	ifAbsent: [Error signal: 'Sagan symbol dictionary missing' ].

"Register system interfaces"
(OrderedCollection new
	add: #RepositoryProviderSystem;
	yourself)
		do: [:each | (symbolDictionary at: each) registerInterfaces].
