Alpha -> deepseek in expert mode with deepthink (deepseek R1)
Beta -> deepseek in expert mode with deepthink (deepseek R1)
Verifier -> deepseek in expert mode with deepthink (deepseek R1)
Observer -> Gemini 3.1 flash preview 
Director -> Gemini 3.1 Pro preveiw

folder naming :
[iteration].[alpha correction attempt].[beta correction attempt].[value]

the value at the end tells us if it's the final output for the iteration or if it's not.

if the value is 1, then it's the final output.
if it's 0 or isn't there, i.e the folder name is "1" then it's not the final output.
if it's the 1st attempt of the solvers (alpha and beta) and all other bots (other than the observer) accept the outputs then the name of the folder will be something like 

```
1.0.0.1
```

if there is only the iteration for example 
```
1
```

then automatclly assume it's both alpha and beta's 1st output, no correction yet and that this isn't the final output for the iteration.