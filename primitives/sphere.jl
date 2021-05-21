include("../vector/vector.jl")

# primitiva geométrica que representa a esfera
struct Sphere{T <: AbstractFloat}
    center::vec3{T} # centro do tipo vec3
    radius::T # raio do tipo float

    function Sphere{T}(c::vec3{T}, r::T) where T
        new(c, r)
    end

end

function Sphere(c::vec3{T}, r::T) where T
    Sphere{T}(c, r)
end
