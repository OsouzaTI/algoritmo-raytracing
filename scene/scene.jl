import Base.push!

include("../vector/vector.jl")

abstract type SceneObject

end

mutable struct HitRecord{T <: AbstractFloat}
    intersectPoint::vec3{T}
    t::T
    normal::vec3{T}
    function HitRecord{T}(p::vec3{T}, t::T, normal::vec3{T}) where T
        new(p, t, normal)
    end
end

function HitRecord(p::vec3{T}, t::T, n::vec3{T}) where T
    HitRecord{T}(p, t, n)
end

function HitRecord()
    HitRecord{Float64}(vec3(0.0, 0.0, 0.0), 0.0, vec3(0.0, 0.0, 0.0))
end


struct SceneList <: SceneObject
    objects::Vector{SceneObject}

    function SceneList(obj::Vector{SceneObject})
        new(obj)
    end

end

function SceneList()
    SceneList(Vector{SceneObject}())
end

function push!(scenelist::SceneList, object::SceneObject)
    push!(scenelist.objects, object)
end