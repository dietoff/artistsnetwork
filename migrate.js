// mongoimport --db artistdb --collection artists --type csv --headerline combined.csv
////////
// mongoimport --db artistdb --collection armorynode --type csv --headerline cleaned/armory4Nodes.csv
// mongoimport --db artistdb --collection armoryedge --type csv --headerline cleaned/armory4Edges.csv

// mongoimport --db artistdb --collection datenode --type csv --headerline cleaned/dateNodes.csv
// mongoimport --db artistdb --collection dateedge --type csv --headerline cleaned/dateEdges.csv

// mongoimport --db artistdb --collection locnode --type csv --headerline cleaned/locNodes.csv
// mongoimport --db artistdb --collection locedge --type csv --headerline cleaned/locEdges.csv

// mongoimport --db artistdb --collection orgnode --type csv --headerline cleaned/orgNodes.csv
// mongoimport --db artistdb --collection orgedge --type csv --headerline cleaned/orgEdges.csv


// samples
// mongoimport --db artistdb --collection sampleartists --type csv --headerline sample.csv
// mongoimport --db artistdb --collection samplebios --type csv --headerline samplebios.csv
// mongoimport --db artistdb --collection armoryedge --type csv --headerline cleaned/armory4Edgessample.csv


// mongoimport --db artistdb --collection artists --type csv --headerline combined_clean.csv
// mongoimport --db artistdb --collection artists --type csv --headerline combined_clean_reduced.csv
// mongoimport --db artistdb --collection samplebios --type csv --headerline mergedFILE.csv

// mongoimport --db artistdb --collection bios --type json --file xmlTojson3.json --jsonArray