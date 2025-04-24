# Module 4: Monte Carlo & Randomness – Quick Revision Sheet

## 1. Key Concepts & Formulas

### Random Number Generators (RNGs)
* **Middle-Square Method:** Seed $x_0$, square it, take middle digits; poor period.
* **Linear Congruential Generator (LCG):**
    * Formula: $x_n = (a\,x_{n-1} + c) \bmod M$
    * Full period if: $\gcd(c,M)=1$, $a-1$ divisible by all prime factors of $M$, and if $M$ multiple of 4 then $a-1$ divisible by 4.
* **Mersenne Twister:** Period $2^{19937}-1$, fast, low correlation. Used in many simulations.
* **Blum Blum Shub:** $x_{n+1}=x_n^2\bmod M$. Cryptographically secure but computationally slow.

### Testing Uniformity
* **Mean:** For samples $S_i$ in $[0,1]$, expect $\lim_{N\to\infty}(1/N)\sum S_i = 0.5$.
* **Moments:** Expect $\langle x^k\rangle\approx1/(k+1)$ with error $O(1/\sqrt N)$.

### Monte Carlo Pi Estimation
* Sample points $(x,y)$ uniformly from the square $[0,1]^2$.
* Count the number of points (let's call this $N_{inside}$) that fall within the quarter circle defined by $x^2+y^2\le1$.
* Formula: $\pi\approx4\times\frac{N_{inside}}{N}$, where $N$ is the total number of samples.

### Monte Carlo $\sqrt n$ Estimation
* Sample points $x$ uniformly from the interval $[0,n]$.
* Count the number of points where $x^2\le n$ (let's call this count $N_{valid}$).
* Formula: $\sqrt n\approx n\times\frac{N_{valid}}{N}$.

### Inverse Transform Sampling
* Method to sample from a probability distribution $p(y)$ given its Cumulative Distribution Function (CDF), $F(y)=\int_{-\infty}^y p(t)dt$ (or $F(y)=\int_{0}^y p(t)dt$ if defined on $[0, \infty)$).
* Generate a random number $z$ from a uniform distribution $U(0,1)$.
* The desired sample $y$ is obtained by computing the inverse CDF: $y=F^{-1}(z)$.

### 1D Random Walk
* A sequence of steps, each of size $\pm1$, taken with equal probability $p=q=1/2$.
* Position after $n$ steps: $X_n = \sum_{i=1}^n x_i$, where $x_i$ is the size of the $i$-th step.
* Mean position: $\mathbb E[X_n]=0$.
* Mean squared displacement: $\mathbb E[X_n^2]=n$.
* Root Mean Square (RMS) displacement: $\sqrt{\mathbb E[X_n^2]} = \sqrt{n}$.

### Monte Carlo Integration
* Method to estimate the definite integral $I=\int_a^b f(x)dx$.
* Sample $N$ points $x_i$ uniformly from the interval $[a,b]$.
* Estimator formula: $I\approx(b-a)\frac1N\sum_{i=1}^N f(x_i)$.
* The error typically decreases as $O(1/\sqrt{N})$, regardless of the dimension of the integral, making it advantageous for high-dimensional problems.

### Histograms & Binning
* **Purpose:** To visualize the distribution of a dataset.
* **Steps:**
    1.  Determine the range of the data: $[\min, \max]$.
    2.  Choose the number of bins, $k$.
    3.  Calculate the bin width: $\Delta = (\max-\min)/k$.
    4.  Define bin edges: $b_0=\min, b_1=\min+\Delta, \dots, b_k=\max$.
    5.  Count the number of data points falling into each bin $[b_{j-1}, b_j)$.
    6.  Plot the counts (or frequency/density) against bin centers or edges.

## 2. Flashcards

* **Q:** Write the formula for a Linear Congruential Generator (LCG).
    **A:** $x_n=(a\,x_{n-1}+c)\bmod M$.

* **Q:** Name two modern Pseudo-Random Number Generators (PRNGs) and state a typical use case for each.
    **A:** Mersenne Twister (used for simulations due to speed and large period), Blum Blum Shub (used in cryptography due to its security properties).

* **Q:** What is the Monte Carlo formula for estimating $\pi$?
    **A:** $\pi\approx4(N_{inside}/N)$, where $N_{inside}$ is the count inside the quadrant.

* **Q:** How do you use inverse transform sampling to generate samples from an exponential distribution $p(x)=\lambda e^{-\lambda x}$ for $x \ge 0$?
    **A:** Use the formula $x=-\frac1\lambda\ln(1-z)$, where $z$ is a random number drawn from $U(0,1)$. (Note: Since $1-z$ is also $U(0,1)$, $x=-\frac1\lambda\ln(z)$ is often used).

* **Q:** What is the Root Mean Square (RMS) displacement after $n$ steps in an unbiased 1D random walk?
    **A:** $\sqrt{n}$.

* **Q:** What is the estimator formula for Monte Carlo integration of $f(x)$ from $a$ to $b$?
    **A:** $(b-a)\times \frac{1}{N}\sum_{i=1}^N f(x_i)$, where $x_i$ are sampled uniformly from $[a,b]$.

* **Q:** What are the conditions for an LCG to have a full period $M$?
    **A:** 1. $\gcd(c,M)=1$. 2. $a-1$ must be divisible by all prime factors of $M$. 3. If $M$ is a multiple of 4, $a-1$ must also be a multiple of 4.

* **Q:** Why is Monte Carlo integration particularly useful in high dimensions?
    **A:** Its convergence rate of $O(1/\sqrt{N})$ is independent of the number of dimensions, unlike many deterministic methods (e.g., grid-based quadrature) which suffer from the "curse of dimensionality".

## 3. Practice MCQs

1.  Which PRNG is known for its extremely long period of $2^{19937}-1$?
    A) Linear Congruential Generator
    B) Middle-Square Method
    C) Mersenne Twister
    D) Blum Blum Shub

2.  In the inverse transform sampling method, if you want to generate random numbers according to a probability density function $p(y)$, what function's inverse do you need?
    A) The inverse of the Probability Density Function (PDF)
    B) The inverse of the Cumulative Distribution Function (CDF)
    C) The PDF itself
    D) The derivative of the CDF

3.  For an unbiased 1D random walk starting at $x=0$, what is the expected mean square displacement $\langle X_n^2\rangle$ after $n=100$ steps?
    A) 10
    B) 50
    C) 100
    D) 200

4.  The Monte Carlo estimation of the integral $I=\int_0^1 x^2 dx$ using $N$ uniform random samples $x_i$ from $[0,1]$ is calculated as:
    A) $\frac{1}{N}\sum_{i=1}^N x_i^2$
    B) $\frac{1}{N}\sum_{i=1}^N x_i$
    C) $\frac{1}{N}\sum_{i=1}^N x_i^3$
    D) $\frac{1}{N}\sum_{i=1}^N (1-x_i^2)$
    *(Note: The general formula $I\approx(b-a)\frac1N\sum f(x_i)$ simplifies here because $b-a = 1-0 = 1$)*

5.  Which step in creating a histogram primarily determines that all bins will have the same width?
    A) Defining the data range $[\min, \max]$.
    B) Counting the number of points in each interval.
    C) Choosing the number of bins ($k$) and calculating width $\Delta = (\max-\min)/k$.
    D) Computing the Probability Density Function (PDF) from the counts.

**Answer Key:** 1.C  2.B  3.C  4.A  5.C

Good luck with your revision!
