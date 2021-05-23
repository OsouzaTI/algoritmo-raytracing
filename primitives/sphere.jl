include("../vector/vector.jl")
include("../scene/scene.jl")
include("../material/material.jl")

# primitiva geométrica que representa a esfera
struct Sphere{T <: AbstractFloat} <: SceneObject
    center::vec3{T} # centro do tipo vec3
    radius::T # raio do tipo float
    material::Material
    function Sphere{T}(c::vec3{T}, r::T, m::Material) where T
        new(c, r, m)
    end

end

function Sphere(c::vec3{T}, r::T, material::Material) where T
    Sphere{T}(c, r, material)
end
