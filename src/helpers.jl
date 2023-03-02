# Additional file to tweak the simulation except
include("Dijkstra.jl")

alpha_to_classic::Dict{Char, Char} = Dict(
    'B' => 'W',
    'C' => 'W',
    'D' => 'S',
    'E' => 'T',
    'K' => '@',
    'P' => '.',
    'F' => 'S',
    'N' => 'S',
    'M' => 'S',
    'I' => 'S',
    

)

function alphamap_to_classic(map::Matrix{Char})

end