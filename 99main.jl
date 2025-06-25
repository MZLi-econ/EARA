# 99main.jl
using GLMakie, LaTeXStrings, Colors, ColorSchemes, CairoMakie
GLMakie.activate!()

include("00struct.jl")
include("01funct.jl")
include("02plot.jl")
include("03analy.jl")

function generate_analysis(params::MPCParameters = default_parameters())
    
    a_grid = [
        0.1:0.0001:1.0;     
        1.001:0.001:10.0;     
        10.01:0.01:100.0;      
        100.1:0.1:1000.0        
        1000.1:1:10000.0
    ]
    
    mpc_values = [MPC(a, params) for a in a_grid]
    consumption_values = [consumption(a, params) for a in a_grid]
    eta_values = [erra(a, params) for a in a_grid]
    eara_values = [earaterm(a, params) for a in a_grid]
    omega_values = [optimal_portfolio_weight(a, params) for a in a_grid]
    merton_values = min.([merton_weight(a, params) for a in a_grid], 1)
    
    return a_grid, mpc_values, consumption_values, eta_values, eara_values, omega_values, merton_values
end

# ===== main =====

function main()
    setup_econometrica_theme()
    
    params = default_parameters()
    
    print_comprehensive_analysis(params)
    
    println("\n🎨 Generating high-quality graphics...")
    
    a_grid, mpc_vals, c_vals, eta_vals, eara_vals, omega_vals, merton_vals = generate_analysis(params)

    fig_eta = create_clean_eta_plot(a_grid, eta_vals, params)
    fig_eara = create_eara_adjustment_plot(a_grid, params)
    fig_opt_fig_portfolio = create_optimized_portfolio_plot(a_grid, omega_vals, merton_vals, params)
    fig_sigma_comparative = create_sigma_comparative_plot(a_grid, params)
    fig_wealth_drift = create_wealth_drift_plot(a_grid, params)

    println("✨ Graphic generation complete！")

    return fig_eta, fig_eara, fig_opt_fig_portfolio, fig_sigma_comparative, fig_wealth_drift, params
end

results = main()

save("eta.png", results[1])
save("eara.png", results[2])
save("opt_fig_portfolio.png", results[3])
save("sigma_comparative.png", results[4])
save("wealth_drift.png", results[5])
