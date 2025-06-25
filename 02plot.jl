# 02plot.jl
function create_clean_eta_plot(a_grid, eta_vals, params::MPCParameters; gamma_val=2.0)
    fig = Figure(size=(480, 360), dpi=600, fontsize=12)
    ax = Axis(fig[1, 1],
        title=L"ERRA $\eta(a)$", 
        xlabel=L"Wealth level $a$ ",
        ylabel=L"$\eta(a)$",
        xscale = log10
    )
    
    # Check critical point where η(a) = 1
    critical_index = findfirst(eta_vals .> 1)
    critical_a = critical_index !== nothing ? a_grid[critical_index] : NaN
    
    # Use light color bands to separate η < 1 and η > 1
    band!(ax, [minimum(a_grid), critical_a], -1, 10, 
          color=(:blue, 0.05))
    band!(ax, [critical_a, maximum(a_grid)], -1, 10, 
          color=(:red, 0.05))

    # Main curve
    lines!(ax, a_grid, eta_vals, 
           color=:navy, 
           linewidth=3,
           label=L"$\eta(a)$")
    
    hlines!(ax, [gamma_val], 
            color=:crimson, 
            linestyle=:dash, 
            linewidth=2.5,
            label=L"$\gamma = 2$")
    
    hlines!(ax, [1.0], 
            color=:gray30, 
            linestyle=:dot, 
            linewidth=2,
            label=L"\eta(a) = 1")
    
    if !isnan(critical_a)
        vlines!(ax, [critical_a], 
                color=:gray30, 
                linestyle=:dashdot, 
                linewidth=1.5)
    end
    
    axislegend(ax, position=:rt, labelsize=16)
    
    ylims!(ax, -0.1, gamma_val * 1.5)
    
    return fig
end

function create_eara_adjustment_plot(a_grid, params::MPCParameters)

    function eara_adjustment(a, eta_val, σs)
        if a < 1e-6 || abs(eta_val) < 1e-6
            return NaN # Avoid division by zero
        end
        return (1 / (a * σs)) * (eta_val - 1) / eta_val
    end

    # Along the grid, calculate eta and eara adjustment
    eta_vals = [erra(a, params) for a in a_grid] 
    eara_vals = [eara_adjustment(a, eta, params.σs) for (a, eta) in zip(a_grid, eta_vals)]

    fig = Figure(size=(480, 360), dpi=600, fontsize=12)
    ax = Axis(fig[1, 1],
        title=L"EARA Strategic Adjustment $\Omega^*(a)$",
        xlabel=L"Wealth level $a$ ",
        ylabel=L"$\Omega^*(a)$",
        xscale=log10
    )

    critical_index_eara = findfirst(eara_vals .> 0)
    critical_eara = critical_index_eara !== nothing ? a_grid[critical_index_eara] : NaN

    min_y_band, max_y_band = -100, 2 # Adjust these based on expected omega_vals range
    
    band!(ax, [minimum(a_grid), critical_eara], min_y_band, max_y_band, 
          color=(:blue, 0.05)) # For eta < 1
    band!(ax, [critical_eara, maximum(a_grid)], min_y_band, max_y_band, 
          color=(:red, 0.05)) # For eta > 1

    lines!(ax, a_grid, eara_vals, color=:navy, linewidth=3)

    hlines!(ax, [0], color=:black, linestyle=:dash, linewidth=1.5)

    ylims!(ax, -10, 2) 

    if !isnan(critical_eara)
        # Find the omega value at the critical point
        critical_eara_val = eara_vals[critical_index_eara]
        
        # Add a scatter point for the intersection
        scatter!(ax, [critical_eara], [critical_eara_val], 
                 color = :darkgreen, 
                 markersize = 12, 
                 marker = :circle)
        
        vlines!(ax, [critical_eara], 
                color=:gray30, 
                linestyle=:dashdot, 
                linewidth=1.5)
        
        text!(ax, critical_eara, critical_eara_val, 
              text = L"$\Omega^*(a)=0$", 
              offset = (10, -30), 
              align = (:left, :bottom),
              fontsize = 16,
              color = :darkgreen)
    end

    return fig
end

function create_optimized_portfolio_plot(a_grid, omega_vals, myopic_vals, params::MPCParameters)
    xticks_pos = [0.1, 1.0, 10.0, 100.0, 1000.0, 10000.0]
    xtick_labels = ["0.1", "1", "10", "100", "1k", "10k"]
    
    fig = Figure(size=(480, 360), dpi=600, fontsize=12)
    ax = Axis(fig[1, 1],
        title=L"Optimal Portfolio Allocation $\omega^*(a)$",
        xlabel=L"Wealth level $a$ ",
        ylabel=L"Risky Asset Share",
        xscale = log10,
        xticks = (xticks_pos, xtick_labels)
    )
    
    critical_index_eta = findfirst(omega_vals .> myopic_vals)
    critical_a_eta = critical_index_eta !== nothing ? a_grid[critical_index_eta] : NaN

    min_y_band, max_y_band = -0.1, 1.2 
    
    band!(ax, [minimum(a_grid), critical_a_eta], min_y_band, max_y_band, 
          color=(:blue, 0.05)) # For eta < 1
    band!(ax, [critical_a_eta, maximum(a_grid)], min_y_band, max_y_band, 
          color=(:red, 0.05)) # For eta > 1
    
    lines!(ax, a_grid, omega_vals, 
           color = :purple, 
           linewidth = 3.5,
           label = L"$\omega^*$")
           
    lines!(ax, a_grid, myopic_vals, 
           color = :navy, 
           linestyle = :dash,
           linewidth = 2.5,
           label = L"$\omega_{\text{myopic}}$")
    
    excess_return = params.μs - params.rf
    merton_baseline = excess_return / (params.γ * params.σs^2)
    hlines!(ax, [merton_baseline], 
            color = :crimson, 
            linestyle = :dot, 
            linewidth = 2.5,
            label = L"baseline")

    if !isnan(critical_a_eta)
        critical_omega_val = omega_vals[critical_index_eta]
        
        scatter!(ax, [critical_a_eta], [critical_omega_val], 
                 color = :darkgreen, 
                 markersize = 12, 
                 marker = :circle)
        
        # Add a vertical line for visual guidance
        vlines!(ax, [critical_a_eta], 
                color=:gray30, 
                linestyle=:dashdot, 
                linewidth=1.5)
        
        # Add text annotation for the critical point
        text!(ax, critical_a_eta, critical_omega_val, 
              text = L"$\eta(a)=1$", # Use LaTeX for annotation
              offset = (10, 10), # Adjust offset as needed
              align = (:left, :bottom),
              fontsize = 18,
              color = :darkgreen)
    end

    axislegend(ax, position = :rb, labelsize=16)
    ylims!(ax, -0.05, max(1.0, 1.2 * merton_baseline)) 

    return fig
end

function create_sigma_comparative_plot(a_grid, base_params::MPCParameters)
    sigmas_to_compare = [0.25, 0.30, 0.4] 
    colors = [:royalblue, :purple, :darkorange] 

    fig = Figure(size=(480, 360), dpi=600, fontsize=12)
    ax = Axis(fig[1, 1],
        title=L"Portfolio Allocation for Different Volatility levels $\sigma_s$",
        xlabel=L"Wealth level $a$ ",
        ylabel=L"Optimal Risky Share $\omega^*(a)$",
        xscale=log10
    )

    function eara_adjustment(a, eta_val, σs)
        if a < 1e-6 || abs(eta_val) < 1e-6
            return NaN 
        end
        return (1 / (a * σs)) * (eta_val - 1) / eta_val
    end

    for (i, sigma) in enumerate(sigmas_to_compare)
        temp_params = MPCParameters(base_params.MPC_max, base_params.p,
                                    base_params.γ, base_params.ρ, base_params.μs,
                                    base_params.rf, base_params.mean_y, sigma, 
                                    base_params.σy, base_params.ρ_sy)
        
        eta_vals = [erra(a, temp_params) for a in a_grid]
        myopic_vals = [(temp_params.μs - temp_params.rf) / (eta * temp_params.σs^2) for eta in eta_vals]
        eara_vals = [eara_adjustment(a, eta, temp_params.σs) for (a, eta) in zip(a_grid, eta_vals)]
        omega_vals = max.(0, myopic_vals .+ eara_vals) 

        lines!(ax, a_grid, omega_vals,
               color=colors[i],
               linewidth=3,
               label=L"\sigma_s = %$(sigma)")
    end
    
    axislegend(ax, position=:rb, labelsize=16)
    ylims!(ax, -0.05, 1.05) 
    
    return fig
end

function create_wealth_drift_plot(a_grid, params::MPCParameters)
    
    function wealth_drift(a, params)
        omega_star = optimal_portfolio_weight(a, params) 
        consumption_star = consumption(a, params)      
        
        y = params.mean_y 
        
        drift = (omega_star * (params.μs - params.rf) + params.rf) * a + y - consumption_star
        return drift
    end
    drift_vals = [wealth_drift(a, params) for a in a_grid]

    fig = Figure(size=(480, 360), dpi=600, fontsize=12)
    ax = Axis(fig[1, 1],
        title=L"Wealth Drift Function $\mu_a(a)$",
        xlabel=L"Wealth level $a$ ",
        ylabel=L"Expected Change in Wealth, $E[da]/dt$",
        xscale=log10
    )

    lines!(ax, a_grid, drift_vals, color=:teal, linewidth=3, label=L"$\mu_a(a)$")

    hlines!(ax, [0], color=:black, linestyle=:dash, linewidth=1.5)

    axislegend(ax, position=:rt, labelsize=16)

    return fig
end
