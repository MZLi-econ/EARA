# 03analy.jl
function print_comprehensive_analysis(params::MPCParameters = default_parameters())
    println("=" ^ 80)
    println("MPC function and portfolio allocation analysis - Complete parameter version")
    println("=" ^ 80)
    
    println("\n📊 Model parameters:")
    println("  Asymptotic MPC of wealthy households (k): $(k(params))")
    println("  Maximum MPC of households with borrowing constraints: $(params.MPC_max)")
    println("  Decay parameter (p): $(params.p)")
    println("  Relative risk aversion coefficient (γ): $(params.γ)")
    println("  Expected stock return (μs): $(params.μs)")
    println("  Risk-free rate (rf): $(params.rf)")
    println("  Stock volatility (σs): $(params.σs)")
    println("  Income volatility (σy): $(params.σy)")
    println("  Stock-income correlation (ρ_sy): $(params.ρ_sy)")
    
    # Detailed analysis of key wealth levels
    test_points = [0.1, 1, 4, 10, 40, 100, 400, 1000, 10000]
    
    println("\n📈 Detailed analysis of key wealth levels:")
    println("Wealth level\tMPC\t\tη_t\t\tω_t^*\t\tc(a)")
    println("-" ^ 70)
    
    for a in test_points
        mpc_val = MPC(a, params)
        eta_val = erra(a, params)
        omega_val = optimal_portfolio_weight(a, params)
        c_val = consumption(a, params)
        
        println("$(lpad(round(a, digits=2), 8))\t$(lpad(round(mpc_val, digits=4), 8))\t$(lpad(round(eta_val, digits=4), 8))\t$(lpad(round(omega_val, digits=4), 8))\t$(lpad(round(c_val, digits=4), 8))")
    end
    

    println("\n✅ Theoretical property verification:")
    a_test = [0.1:0.0001:1.0;     
    1.001:0.001:10.0;      
    10.01:0.01:100.0;      
    100.1:0.1:1000.0         
    1000.1:1:10000.0]
    mpc_test = [MPC(a, params) for a in a_test]
    eta_test = [erra(a, params) for a in a_test]
    
    println("1. MPC monotonicity: ", all(diff(mpc_test) .≤ 1e-10) ? "✓" : "✗")
    println("2. η at low wealth approach 0: ", erra(0.01, params) < 0.1 ? "✓" : "✗")
    println("3. η at high wealth approach γ: ", abs(erra(1000.0, params) - params.γ) < 0.2 ? "✓" : "✗")
    println("4. ω at low wealth approach 0 (finite participation): ", optimal_portfolio_weight(0.01, params) < 0.05 ? "✓" : "✗")
    
end