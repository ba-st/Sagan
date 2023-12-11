| symbolDictionary |

symbolDictionary := Rowan image 
	symbolDictNamed: 'Sagan'
	ifAbsent: [Error signal: 'Sagan symbol dictionary missing' ].

"Register system interfaces"
(symbolDictionary at: #RepositoryProviderSystem) registerInterfaces.
