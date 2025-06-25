# The Endogenous Aggregate Risk Aversion: Portfolio Choice and the Wealth Distribution

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

[cite_start]This repository provides the Julia replication code for the paper "The Endogenous Aggregate Risk Aversion: Portfolio Choice and the Wealth Distribution". [cite_start]The paper develops a continuous-time heterogeneous agent framework that reveals a novel economic mechanism: **Endogenous Aggregate Risk Aversion (EARA)**. [cite_start]This framework provides an endogenous rationalization for the limited participation puzzle and demonstrates a new channel through which aggregate risk shapes wealth inequality.

## About the Paper

> [cite_start]**Title**: The Endogenous Aggregate Risk Aversion: Portfolio Choice and the Wealth Distribution 
>
> [cite_start]**Author**: Mingzhe Li 
>
> **Version**: June 25, 2025
>
> **Link to Paper**: [Link to your SSRN, ArXiv, or personal website]

## Core Economic Mechanism

[cite_start]This code implements the quantitative analysis of the **EARA Strategic Adjustment** mechanism proposed in the paper. [cite_start]The core idea is that households, when optimizing, hedge against the endogenous risk to their own continuation value function that arises from common shocks. [cite_start]This hedging motive gives rise to a strategic portfolio adjustment, $\Omega_t^*$, whose sign and magnitude depend on a wealth-dependent **Endogenous Relative Risk Aversion (ERRA)** coefficient, $\eta_t(a)$.

## Key Results Reproduced

[cite_start]This code generates the main figures from **Section 5: Quantitative Analysis** of the paper, visualizing the core mechanisms:

* [cite_start]**Figure 1a:** The ERRA coefficient, $\eta(a)$, as a function of wealth.
* [cite_start]**Figure 1b:** The EARA Strategic Adjustment, $\Omega^*(a)$.
* [cite_start]**Figure 2a:** The optimal risky asset share, $\omega^*(a)$, demonstrating limited participation at low wealth and convergence to the Merton benchmark at high wealth.
* [cite_start]**Figure 2b:** Comparative statics of the optimal portfolio with respect to asset volatility, $\sigma_s$.
* [cite_start]**Figure 3:** The wealth drift function, $\mu_a(a)$, illustrating the "poverty trap" dynamics and accelerating wealth accumulation at the top.

## Repository Structure

```
.
├── 99main.jl               # Main script to run the entire analysis and generate all figures
├── 00struct.jl             # Defines model parameter structures and plotting themes
├── 01funct.jl              # Contains core economic functions (consumption, ERRA, EARA, etc.)
├── 02plot.jl               # Contains functions for generating all plots
├── 03analy.jl              # Contains functions to print text-based analysis to the console
├── Project.toml            # Julia project environment configuration (recommended)
└── README.md               # This README file
```

## Requirements and Installation

The code is written in **Julia**. To ensure a reproducible environment, please use the Julia package manager.

**Dependencies:**
* GLMakie
* LaTeXStrings
* Colors
* ColorSchemes
* CairoMakie

**Installation:**
1.  Clone this repository to your local machine.
2.  Navigate to the repository's root directory in a Julia REPL.
3.  Activate the project environment and instantiate the packages:
    ```julia
    using Pkg
    Pkg.activate(".")
    Pkg.instantiate()
    ```

## Usage

After installing the dependencies, run the main script from your terminal:

```bash
julia 99main.jl
```

The script will print a detailed analysis to the console and save the following figures in the root directory:
* `eta.png`
* `eara.png`
* `opt_fig_portfolio.png`
* `sigma_comparative.png`
* `wealth_drift.png`

## License

This project is licensed under the **MIT License**. See the `LICENSE` file for details.

## Citation

If you use this code or the findings from our paper in your research, please cite the paper:

> Li, Mingzhe. (2025). "The Endogenous Aggregate Risk Aversion: Portfolio Choice and the Wealth Distribution." *Working Paper*.

```bibtex
@techreport{Li2025EARA,
  author      = {Li, Mingzhe},
  title       = {The Endogenous Aggregate Risk Aversion: Portfolio Choice and the Wealth Distribution},
  year        = {2025},
  institution = {Shihezi University},
  type        = {Working Paper}
}
```
