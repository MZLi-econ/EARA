# 00struct.jl
struct MPCParameters
    MPC_max::Float64     # Maximum MPC for borrowing-constrained households
    p::Float64           # Decay rate parameter
    γ::Float64           # Risk aversion parameter
    ρ::Float64           # Time discount rate
    μs::Float32          # Expected stock return
    rf::Float32          # Risk-free rate
    mean_y::Float32      # Income mean
    σs::Float32          # Stock volatility
    σy::Float32          # Income volatility
    ρ_sy::Float32        # Correlation between stock and income
end

function default_parameters()
    return MPCParameters(
        0.72,      # MPC_max
        0.8,       # p: 
        2.0,       # γ: 
        0.05,      # ρ:
        0.08f0,    # μs:
        0.03f0,    # rf: 
        1.0f0,     # mean_y: 
        0.30f0,    # σs: 
        0.30f0,    # σy: 
        0f0     # ρ_sy: 
    )
end

const ACADEMIC_COLORS = (
    primary = "#2C3E50",     
    secondary = "#E74C3C",    
    accent = "#27AE60",      
    neutral = "#7F8C8D",      
    light_blue = "#E8F4F8", 
    light_red = "#FFEAEA"    
)

function setup_econometrica_theme()
    theme = Theme(

        font = "Computer Modern",  
        fontsize = 12,  
        
        Axis = (
            xlabelsize = 12,        
            ylabelsize = 12,
            titlesize = 14,         
            xticklabelsize = 10,    
            yticklabelsize = 10,
            
            spinewidth = 1.2,
            xtickwidth = 1.0,
            ytickwidth = 1.0,
            
            xgridwidth = 0.5,
            ygridwidth = 0.5,
            xgridcolor = (:gray, 0.15),  
            ygridcolor = (:gray, 0.15),
            
            leftspinevisible = true,
            rightspinevisible = false,  
            topspinevisible = false,   
            bottomspinevisible = true,
        ),
        
        Lines = (linewidth = 2.0,),     
        Scatter = (markersize = 6,),    
        
        Legend = (
            framevisible = false,       
            labelsize = 10,
        )
    )
    set_theme!(theme)
end