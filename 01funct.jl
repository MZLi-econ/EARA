# 01funct.jl
# ===== Core Theory Functions =====

# k = (ρ - (1- γ)(rf + (μs - rf)^2 / (2γσs^2)))/γ
function k(params::MPCParameters)
    result = (params.ρ - (1 - params.γ) * (params.rf + (params.μs - params.rf)^2 / (2 * params.γ * params.σs^2))) / params.γ
    return round(result, digits=3)
end

# Consumption function c(a) = (c₀ᵖ + (k·a)ᵖ)¹/ᵖ
function consumption(a::Float64, params::MPCParameters)
    c0_p = params.mean_y^params.p
    ka_p = (k(params) * a)^params.p
    return (c0_p + ka_p)^(1/params.p)
end

# Marginal propensity to consume MPC(a) = k * (k·a / c(a))⁽ᵖ⁻¹⁾
function MPC(a::Float64, params::MPCParameters)
    c_val = consumption(a, params)
    ratio = (k(params) * a) / c_val
    return k(params) * ratio^(params.p - 1)
end

# Consumption elasticity ε_c,a(a) = (k·a / c(a))ᵖ
function consumption_elasticity(a::Float64, params::MPCParameters)
    c_val = consumption(a, params)
    ratio = (k(params) * a) / c_val
    return ratio^params.p
end

# η_t(a) = (a/c(a)) * MPC(a) * γ
function erra(a::Float64, params::MPCParameters)
    if a ≤ 1e-10
        return 0.0  # Limit case handling
    end
    
    return consumption_elasticity(a, params) * params.γ
end

# Ω_t^*(a) = (1/(a*σs)) * (η_t(a)-1)/η_t(a)
function earaterm(a::Float64, params::MPCParameters)
    if a ≤ 1e-10
        return -1e6  # Limit case handling
    end
    
    η = erra(a, params)
    
    if abs(η) < 1e-10
        return -1e6  # Limit case handling
    end
    
    return (1 / (a * params.σs)) * (η - 1) / η
end

function merton_weight(a::Float64, params::MPCParameters)
    excess_return = params.μs - params.rf
    η = erra(a, params)
    return excess_return / (η * params.σs^2)
end

function optimal_portfolio_weight(a::Float64, params::MPCParameters)
    # Merton portfolio weight
    merton_w = merton_weight(a, params)
    
    # EARA strategic adjustment term
    adjustment = earaterm(a, params)
    
    # Optimal portfolio weight (constrained in [0,1] interval)
    optimal_weight = merton_w + adjustment
    
    return max(0.0, min(1.0, optimal_weight))
end