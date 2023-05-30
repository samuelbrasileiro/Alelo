# Alelo Challenge

## Running Locally

These are the necessary setups to generate .xcodeproj file and run project locally

### Setting up the environment

Install the latest version of [XcodeGen](https://github.com/yonaskolb/XcodeGen).
```bash
brew instal xcodegen
```

Install the latest version of [SwiftGen](https://github.com/SwiftGen/SwiftGen).
```bash
brew instal swiftgen
```

### Creating Project

Clone the project

```bash
git clone https://github.com/samuelbrasileiro/AleloChallenge.git
```

Enter in project directory

```bash
cd AleloChallenge
```

Generate AleloChallenge's xcodeproj using xcodegen

```bash
make project
```

Open the xcodeproj, build and run.

## Visualizing Dependency Graph

To visualize AleloChallenge' dependency graph, run
```bash
make graph
```

Obs.: It's necessary to have [Graphviz](https://graphviz.org/) visualization software to generate the graph image. To do so, run in console the following code

```bash
brew instal graphviz
```
