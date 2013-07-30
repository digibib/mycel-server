## Mycel server
Rewrite Mycel in Go

### Why?
* Simpler deployment; one compiled, statically-linked binary with no depndencies except MySQL.
* Go has saner and more robust concurrency constructs than Ruby. Goodbye difficult to debug EventMachine deadlocks.
* A rewrite gives me an excuse to refactor and enhance some earlier bad program designs and decisions.