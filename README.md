# DSO-MATLAB

Drone Squadron Optimization is a new self-adaptive
metaheuristic for global numerical optimization which is updated online
by a hyper-heuristic. It is the first meta-heuristic that can improve 
its own code during the optimization process.

DSO is an artifact-inspired technique, as opposed
to many nature-inspired algorithms used today. DSO is
very flexible because it is not related to natural behaviors or  phenomena.

DSO has two core parts: the semi-autonomous drones that fly over a
landscape to explore, and the command center that processes the retrieved
data and updates the drones' firmware whenever necessary. 

![Images from the Internet](command_center.jpg)

## Perturbations

The self-adaptive
aspect of DSO in this work is the perturbation/movement scheme, which
is the procedure used to generate target coordinates. This procedure
is evolved by the command center during the global optimization process
in order to adapt DSO to the search landscape. 

![Examples of perturbations](perturbations.jpg)

As one may wonder, DSO can automatically generate formulas that are exactly the same of 
many nature-inspired meta-heuristics. Moreover, it can automatically improve them!

## Capabilities

Because of its automatic adaptation, DSO can do the following:

### Escape from local-optima

![Example of escaping](escaping.jpg)

### Detect stagnation and explore other regions of the search-space (MaxStagnation and Pacc)

![Example of stagnation recovery](stagnation.jpg)

### Detect convergence (lack of population diversity) and restart to continuing exploring (ConvThres)

![Example of restart](restart.jpg)

### Discover perturbations that intensify the seach

![Examples of intensification](intensification.jpg)

We evaluated DSO on
a set of widely employed single-objective benchmark functions. The
statistical analysis of the results shows that the proposed method
is competitive with the other methods, but we plan
several future improvements to make it more powerful and robust.


## Hyper-heuristic configuration

Please, check file DSO/InitGPConfig.m

## Toolbox

We provide a Matlab (R) toolbox for testing purposes. It has controls for several
parameters, while the others must be changed in the source code.

![Toolbox](Toolbox.jpg)

`Please cite:`
de Melo, V.V. & Banzhaf, W. Neural Comput & Applic (2017). doi:10.1007/s00521-017-2881-3

`https://link.springer.com/article/10.1007/s00521-017-2881-3`







