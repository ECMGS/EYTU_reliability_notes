#import "@preview/lilaq:0.5.0" as lq

= Testing & reliability additional notes

*Fault tolerance* is the ability of a system to continue performing its function in spite of faults. The main goal of this is to increase the dependability of a system.
- The *dependability* is the ability of a system to deliver its intended level of service to its users.

The level of application can be:
- *Safety critical application:* When it is critical to human safety or the natural environment. Very high probability to be operational for short periods of time (For example 99.999999% for 3 hours).
- *Mission critical applications:* When you have to complete the mission and repair is impossible or prohibitively expensive. (For example 95% for 10 years)
- *Business-critical application* Users need to have a gigh probability of receiving service when it is requested.

== Fault, failure and error:

- A *fault* is an underlying defect, imperfection, or flaw that has the potential to cause problems. They can be _latent_ if they haven't caused any flaws or _active_ it it is causing problems.
  - *Fault tolerance* consists of noticing active faults and component subsystem failures and doing something helpful in response.
- A *failure* is a non-performance of some action that is due or espected
- An *error* is a deviation of correctness or accuracy.

Whe have 3 parameters to measure the fault tolerance of a system:
- *Reliability $R(t)$* is the probability that a system operates without failure in the interval $[0,t]$, given that it worked at time 0.
  - Reliability isn't the same as fault tolerance, fault tolerance is a technique that can improve reliability, but a highly reliable system is not necessarily fault system.
- *Availability $A(t)$* is the probability that a system is functioning correctly at the instant time $t$. It depends on:
  - How frequently a system becomes non-operational.
  - How quickly can it be repaired.
  The _steady state availability_ $A(infinity)$ is when we assume a time-independent value after some initial time interval.

  $ A(infinity) = t_("on") / (t_("on") + t_("off") ) $

  One difference between _reliability_ and _availability_ is that the first one depends on an interval of time and the second one is taken at an instant of time.
- *Safety $S(t)$* is the probability that a system will either perform its function correctly or will stop functioning in a safe way. A system is safe if it functions correctly or if it fails, it remains in a safe state. Failures are partitioned into:
  - Fail-safe
  - Fail-unsafe

#pagebreak()

== Common fault tolerance measures:

- *Failure rate $lambda$* is the expected number of failures per unit time. Its units are usually given in terms of failures per hour, normalized fo ra single unit. It isn't really a probability, but rather an "expected value".

Usually the failure rate is divided in 3 sections depending on the life of the device:
+ *Infant mortality:* Failure rate decreases
+ *Lifetime:* Low failure rate
+ *Passed lifetime:* Failure rate increases

#text(red)[insert graphic]

- *Failure rate and reliability:* Reliability $R(t)$ is the conditional probability that the system will work correctly throughout $(0,t)$ given that it worked on time $0$

$ R(t) = N_"op"(t)/(N_"op"(t) + N_"fail"(t)) $

- The *Mean Time To Failure (MTTF)* is the expected time of the occurrence of the first system failure. For a system with $N$ identical components and we measure the time before each component fails:

$ "MTTF" = 1/n sum_(i = 0)^(n) t_i $

In terms of system reliability $R(t)$:

$ "MTTF" = integral_(0)^(infinity) R(t) d t $

If $R(t) = e^(- lambda t)$, then MTTF is the inverse of the failure rate:

$ "MTTF" = integral_(0)^(infinity) e^(-lambda t) d t = 1/lambda $

- The *Mean Time To Repair (MTTR)* is the expected time until a system is repaired. If we have a system with $N$ identical components and the $i$ component requires $t_i$ to repair:

$ "MTTR" = 1/n sum_(i = 0)^(n) t_i $

Normally it is specified in terms of the repair rate $mu$ which is the
average number of repairs that occur per time period


$ "MTTR" = 1/mu $

We can calculate the _steady-state availability_ as:

$ A(infinity) = (n "MTTF")/(n "MTTF" + n "MTTR") approx ("MTTF")/("MTTF" + "MTTR") $

#pagebreak()

- The *fault coverage ($C$)* is the conditional probability that, given the existence of a fault, the system detects it

$ C = "N. detected faults"/"Total N. faults" $

== Reliability evaluation

- *Reliability Block Diagrams (RBD)* break the system into its serial and parallel parts and compute the reliability of each part.
  - In *serial systems*, all components have to be operational.

  #text(red)[Include series diagram]

  $ R_"Series"(t) = product_(i=1)^N R_i (t) $
  $ lambda_"series" = sum _(i = 1)^N lambda_i $

  - In *parallel systems*, the system can work even if only one component work. Thus, we need to define the *unreliability factor* $Q(t) = 1 - R(t)$. If $C_i$ are independent.

  $ Q_"parallel"(t) = product_(i=1)^N Q_i (t) $
  $ R_"parallel"(t) = 1 - product_(i=1)^N (1-R_i (t)) $

- In fault tolerance, we deal with *Continuous Time Markov Chains*, which have a discrete number of states in a continuous time space. They can be illustrated by using _state transition diagrams_:
  - The *States* represent if the components are working or not
  - The *Transitions* represent when components fail or gets replaced

  - In a *single component system* with *no repair* we have only two states:
    + *Operational* (State 1)
    + *Failed* (State 2)

  If no repaired is allowed, there is a single, not reversible transition between these states. label $lambda$ represents the failure rate of the component.

  #text(red)[Insert transition diagram] 

  - In a *single component system* with *repair*, we have the same two states. However, now we have another transition from _Failed_ to _Operational_ with probability $mu$ that represents the repair rate.

  #text(red)[Insert transition diagram] 

  - We can also represent if the fail is *safe*, in this case, we will have two faulty states, _Failed-safe_ and _Failed-unsafe_. The transition probability between _Operational_ and _Failed-safe_ is $lambda C$ where $C$ is the probability that if a fail occurs, it is detected and handled appropriately. This is called *Fault Coverage $C$*. The probability to move between _Operational_ and _Failed-unsafe_ is $lambda(1-C)$

  - In a *two component system* where components are considered non repairable and independent, we can have two situations:

  #text(red)[Insert transition diagram]

    - If components are in _serial_, state 1 is operational and 2, 3 and 4 are failed states.
    - If components are in _parallel_, state 1, 2 and 3 are operational and 4 is failed sate. In this case we can do a *simplification*. #linebreak() If we suppose that $lambda_1 = lambda_2 = lambda$, it is not necessary to distinguish between states 2 and 3. This is because both represent a condition where one component is operational and one is failed. Since components are independent, transition rate from 1 to 2 is the sum of the two transition rates.

    #text(red)[Insert transition diagram]

  === Markov process analysis

    The aim of Markov process analysis is to compute $P_i (t)$, or the probability that the system is in state $i$ at time $t$. Once $P_i (t)$ is known, the reliability, availability or safety of the system can be compute as a sum taken from all the operating states. To compute $P_i (t)$, we derive a set of differential equations, called state transition equations, one for each state of the system. We usually arrange these equations in matrix form.

    The *transition matrix* $M$ has entries $m_"ij"$ representing the rates of transition between the states $i$ and $j$, where the first one is he column and the second one is the row. The full matrix has the following form

    $ M = mat(m_"11" m_"21"; m_"12" m_"22") $ 

    The entries in each column must add up to 0. Entries such as $m_"ii"$, corresponding to self transitions, are computed as $-(sum "entries in this column")$.

    Some important properties of the transition matrix are:
    - The sum of the values in each column add up to 1
    - Positive sign of $m_"ij"$ coefficient indicate that the transition originates rom from the $i$ state.
    - $M$ allows us to distinguish between operational and failed states, where each failed state $i$ has zero diagonal element $M_"ii"$.

    The *state transition equations* can be defined from a vector $arrow(P)_i (t)$ whose $i$ element is the probability $P_i (t)$ that a system is in state $i$ at time $t$. The matrix representation is given by the following equation:

    $ d/"dt" arrow(P) (t) = arrow(M) dot arrow(P) (t) $

    The resulting matrix equation in a system of three equations would be:

    $ d / "dt" mat(P_1 (t); P_2 (t); P_3 (t)) = mat(m_"11" m_"21" m_"31"; m_"12" m_"22" m_"32"; m_"13" m_"23" m_"33") dot mat(P_1 (t); P_2 (t); P_3 (t)) $

    === Dependent component case

    In a *dependent component case*, the value of the Markov chains become evident when component failures cannot be assumed to be independent. This because if two components share the same load and one fails, then the additional load on the second component increases its failure rate.


#text(red)[Insert until diapo 28 - 3rd ppt]

