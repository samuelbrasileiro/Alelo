project:
	xcodegen generate

graph:
	xcodegen dump --type graphviz --file Disposed/graph.viz
	dot -Tpng Disposed/graph.viz > Disposed/graph.png
	open Disposed/graph.png